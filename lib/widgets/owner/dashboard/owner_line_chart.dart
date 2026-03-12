import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';

class OwnerLineChart extends StatefulWidget {
  final List<int> data;
  final List<String> labels;
  final Color color;
  final bool filled;
  final double height;
  final String tooltipPrefix; // e.g. 'coins'

  const OwnerLineChart({
    super.key,
    required this.data,
    required this.labels,
    this.color = AppColors.primary,
    this.filled = false,
    this.height = 200,
    this.tooltipPrefix = 'coins',
  });

  @override
  State<OwnerLineChart> createState() => _OwnerLineChartState();
}

class _OwnerLineChartState extends State<OwnerLineChart> {
  int? _selectedIndex;

  void _handleTap(Offset local, Size size) {
    if (widget.data.length < 2) return;
    const leftPad   = 46.0;
    const bottomPad = 28.0;
    const topPad    = 10.0;
    final chartW = size.width - leftPad;
    final chartH = size.height - bottomPad - topPad;
    final maxVal = widget.data.reduce(max).toDouble();
    final minVal = (widget.data.reduce(min) * 0.85).toDouble();
    final range  = maxVal - minVal;
    final step   = chartW / (widget.data.length - 1);

    for (var i = 0; i < widget.data.length; i++) {
      final x = leftPad + step * i;
      final y = topPad + chartH -
          (chartH * (widget.data[i] - minVal) / range);
      if ((local - Offset(x, y)).distance < 14) {
        setState(() =>
        _selectedIndex = (_selectedIndex == i) ? null : i);
        return;
      }
    }
    setState(() => _selectedIndex = null);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (d) {
        final box = context.findRenderObject() as RenderBox;
        _handleTap(box.globalToLocal(d.globalPosition), box.size);
      },
      child: SizedBox(
        height: widget.height,
        width: double.infinity,
        child: CustomPaint(
          painter: _LinePainter(
            data: widget.data,
            labels: widget.labels,
            color: widget.color,
            filled: widget.filled,
            selectedIndex: _selectedIndex,
            tooltipPrefix: widget.tooltipPrefix,
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

// ─── Painter ──────────────────────────────────────────────────────────────────

class _LinePainter extends CustomPainter {
  final List<int> data;
  final List<String> labels;
  final Color color;
  final bool filled;
  final int? selectedIndex;
  final String tooltipPrefix;

  _LinePainter({
    required this.data,
    required this.labels,
    required this.color,
    required this.filled,
    required this.tooltipPrefix,
    this.selectedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;

    const leftPad   = 46.0;
    const bottomPad = 28.0;
    const topPad    = 10.0;
    final chartW = size.width - leftPad;
    final chartH = size.height - bottomPad - topPad;
    final maxVal = data.reduce(max).toDouble();
    final minVal = (data.reduce(min) * 0.85).toDouble();
    final range  = maxVal - minVal;
    final step   = chartW / (data.length - 1);

    // ── Grid + Y labels ──
    final gridPaint = Paint()
      ..color = const Color(0xFFF3F4F6)
      ..strokeWidth = 1;
    for (var i = 0; i <= 4; i++) {
      final y = topPad + chartH - (chartH * i / 4);
      canvas.drawLine(
          Offset(leftPad, y), Offset(size.width, y), gridPaint);
      final val = (minVal + range * i / 4).round();
      _text(canvas, '$val', Offset(0, y - 6),
          const TextStyle(
              fontSize: 9, color: AppColors.textSecondary));
    }

    // ── Points ──
    final points = List.generate(data.length, (i) {
      final x = leftPad + step * i;
      final y = topPad + chartH -
          (chartH * (data[i] - minVal) / range);
      return Offset(x, y);
    });

    // ── Selected vertical line ──
    if (selectedIndex != null) {
      canvas.drawLine(
        Offset(points[selectedIndex!].dx, topPad),
        Offset(points[selectedIndex!].dx, topPad + chartH),
        Paint()
          ..color = color.withOpacity(0.2)
          ..strokeWidth = 1.5,
      );
    }

    // ── Fill ──
    if (filled) {
      final fillPath = Path()
        ..moveTo(points.first.dx, topPad + chartH);
      for (final p in points) {
        fillPath.lineTo(p.dx, p.dy);
      }
      fillPath
        ..lineTo(points.last.dx, topPad + chartH)
        ..close();
      canvas.drawPath(
        fillPath,
        Paint()
          ..shader = LinearGradient(
            colors: [
              color.withOpacity(0.25),
              color.withOpacity(0.0)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(
              Rect.fromLTWH(leftPad, topPad, chartW, chartH))
          ..style = PaintingStyle.fill,
      );
    }

    // ── Line ──
    final linePath = Path()
      ..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(
      linePath,
      Paint()
        ..color = color
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // ── Dots ──
    for (var i = 0; i < points.length; i++) {
      final p = points[i];
      final isSelected = selectedIndex == i;
      canvas.drawCircle(p, isSelected ? 6.0 : 4.5,
          Paint()..color = Colors.white);
      canvas.drawCircle(p, isSelected ? 4.5 : 3.0,
          Paint()..color = color);
    }

    // ── X labels (every 2nd) ──
    for (var i = 0; i < labels.length; i++) {
      if (i % 2 == 0) {
        _text(
          canvas,
          labels[i],
          Offset(points[i].dx - 8, topPad + chartH + 6),
          const TextStyle(
              fontSize: 9, color: AppColors.textSecondary),
        );
      }
    }

    // ── Tooltip ──
    if (selectedIndex != null) {
      final i = selectedIndex!;
      _drawTooltip(
        canvas, size,
        anchorX: points[i].dx,
        anchorY: points[i].dy,
        line1: labels[i],
        line2: '$tooltipPrefix : ${data[i]}',
        line2Color: color,
      );
    }
  }

  void _drawTooltip(Canvas canvas, Size size,
      {required double anchorX,
        required double anchorY,
        required String line1,
        required String line2,
        required Color line2Color}) {
    const w = 148.0, h = 56.0, r = 10.0, pad = 12.0;
    double tx = anchorX - w / 2;
    double ty = anchorY - h - 14;
    if (tx < 4) tx = 4;
    if (tx + w > size.width - 4) tx = size.width - w - 4;
    if (ty < 4) ty = anchorY + 16;

    // Shadow
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(tx + 2, ty + 4, w, h),
          const Radius.circular(r)),
      Paint()
        ..color = Colors.black.withOpacity(0.10)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    // White bg
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(tx, ty, w, h),
          const Radius.circular(r)),
      Paint()..color = Colors.white,
    );

    // Line 1
    _text(canvas, line1, Offset(tx + pad, ty + 9),
        const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary));

    // Line 2 — split 'prefix : value'
    final parts  = line2.split(' : ');
    final prefix = '${parts[0]} : ';
    final val    = parts.length > 1 ? parts[1] : '';

    _text(canvas, prefix, Offset(tx + pad, ty + 30),
        const TextStyle(
            fontSize: 12, color: AppColors.textSecondary));
    final prefixW = _measureText(prefix, 12);
    _text(canvas, val, Offset(tx + pad + prefixW, ty + 30),
        TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: line2Color));
  }

  double _measureText(String text, double fontSize) {
    final tp = TextPainter(
        text: TextSpan(
            text: text, style: TextStyle(fontSize: fontSize)),
        textDirection: TextDirection.ltr)
      ..layout();
    return tp.width;
  }

  void _text(Canvas canvas, String text, Offset offset,
      TextStyle style) {
    final tp = TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: TextDirection.ltr)
      ..layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(_LinePainter old) =>
      old.selectedIndex != selectedIndex;
}