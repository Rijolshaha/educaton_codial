import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';

class OwnerBarChart extends StatefulWidget {
  final List<int> data;
  final List<String> labels;
  final double height;
  final Color barColor;

  const OwnerBarChart({
    super.key,
    required this.data,
    required this.labels,
    this.height = 220,
    this.barColor = AppColors.orange,
  });

  @override
  State<OwnerBarChart> createState() => _OwnerBarChartState();
}

class _OwnerBarChartState extends State<OwnerBarChart> {
  int? _selectedIndex;

  late final List<int> _data;
  late final List<String> _labels;

  @override
  void initState() {
    super.initState();
    _data = [];
    _labels = [];
    for (var i = 0; i < widget.data.length; i++) {
      if (widget.data[i] > 0) {
        _data.add(widget.data[i]);
        _labels.add(widget.labels[i]);
      }
    }
  }

  void _handleTap(Offset local, Size size) {
    if (_data.isEmpty) return;
    const leftPad   = 52.0;
    const bottomPad = 36.0;
    const topPad    = 10.0;
    final chartW = size.width - leftPad;
    final chartH = size.height - bottomPad - topPad;
    final maxVal = _data.reduce(max).toDouble();
    final barW   = (chartW / _data.length) * 0.6;
    final gap    = chartW / _data.length;

    for (var i = 0; i < _data.length; i++) {
      final x    = leftPad + gap * i + gap / 2 - barW / 2;
      final barH = chartH * (_data[i] / maxVal);
      final y    = topPad + chartH - barH;
      if (Rect.fromLTWH(x - 6, y - 6, barW + 12, barH + 6)
          .contains(local)) {
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
          painter: _BarPainter(
            data: _data,
            labels: _labels,
            barColor: widget.barColor,
            selectedIndex: _selectedIndex,
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

// ─── Painter ──────────────────────────────────────────────────────────────────

class _BarPainter extends CustomPainter {
  final List<int> data;
  final List<String> labels;
  final Color barColor;
  final int? selectedIndex;

  _BarPainter({
    required this.data,
    required this.labels,
    required this.barColor,
    this.selectedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    const leftPad   = 52.0;
    const bottomPad = 36.0;
    const topPad    = 10.0;
    final chartW = size.width - leftPad;
    final chartH = size.height - bottomPad - topPad;
    final maxVal = data.reduce(max).toDouble();
    final barW   = (chartW / data.length) * 0.6;
    final gap    = chartW / data.length;

    // ── Grid + Y labels ──
    final gridPaint = Paint()
      ..color = const Color(0xFFF3F4F6)
      ..strokeWidth = 1;
    for (var i = 0; i <= 4; i++) {
      final y = topPad + chartH - (chartH * i / 4);
      canvas.drawLine(
          Offset(leftPad, y), Offset(size.width, y), gridPaint);
      _text(canvas, _fmtK((maxVal * i / 4).round()),
          Offset(0, y - 6),
          const TextStyle(fontSize: 9, color: AppColors.textSecondary));
    }

    // ── Bars ──
    for (var i = 0; i < data.length; i++) {
      final x    = leftPad + gap * i + gap / 2 - barW / 2;
      final barH = chartH * (data[i] / maxVal);
      final y    = topPad + chartH - barH;
      final isSelected = selectedIndex == i;

      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(x, y, barW, barH),
          topLeft: const Radius.circular(4),
          topRight: const Radius.circular(4),
        ),
        Paint()
          ..color = isSelected
              ? barColor.withOpacity(0.45)
              : barColor,
      );

      // X label
      final lbl = labels[i].length > 10
          ? labels[i].substring(0, 10)
          : labels[i];
      _text(canvas, lbl,
          Offset(x + barW / 2 - 16, topPad + chartH + 6),
          const TextStyle(
              fontSize: 7.5, color: AppColors.textSecondary));
    }

    // ── Tooltip ──
    if (selectedIndex != null && selectedIndex! < data.length) {
      final i   = selectedIndex!;
      final x   = leftPad + gap * i + gap / 2;
      final barH = chartH * (data[i] / maxVal);
      final y   = topPad + chartH - barH;
      _drawTooltip(canvas, size,
          anchorX: x,
          anchorY: y,
          line1: labels[i],
          line2: 'coins : ${_fmtCoins(data[i])}',
          line2Color: barColor);
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
    double ty = anchorY - h - 12;
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
    // Line 2 split prefix + value
    final parts = line2.split(' : ');
    final prefix = parts[0] + ' : ';
    final val    = parts.length > 1 ? parts[1] : '';
    _text(canvas, prefix, Offset(tx + pad, ty + 30),
        const TextStyle(fontSize: 12, color: AppColors.textSecondary));
    final prefixTp = TextPainter(
        text: TextSpan(
            text: prefix,
            style: const TextStyle(fontSize: 12)),
        textDirection: TextDirection.ltr)
      ..layout();
    _text(canvas, val,
        Offset(tx + pad + prefixTp.width, ty + 30),
        TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: line2Color));
  }

  void _text(Canvas canvas, String text, Offset offset,
      TextStyle style) {
    final tp = TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: TextDirection.ltr)
      ..layout();
    tp.paint(canvas, offset);
  }

  String _fmtK(int n) =>
      n >= 1000 ? '${(n / 1000).toStringAsFixed(0)}k' : '$n';

  String _fmtCoins(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i != 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  @override
  bool shouldRepaint(_BarPainter old) =>
      old.selectedIndex != selectedIndex;
}