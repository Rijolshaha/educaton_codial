import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../models/owner_model.dart';

class OwnerDavomatChart extends StatefulWidget {
  final OwnerModel owner;

  const OwnerDavomatChart({super.key, required this.owner});

  @override
  State<OwnerDavomatChart> createState() =>
      _OwnerDavomatChartState();
}

class _OwnerDavomatChartState extends State<OwnerDavomatChart> {
  int? _selectedIndex;

  void _handleTap(Offset local, Size size) {
    final data   = widget.owner.davomatData;
    final labels = widget.owner.davomatLabels;
    if (data.length < 2) return;

    const leftPad   = 52.0;
    const bottomPad = 28.0;
    const topPad    = 10.0;
    final chartW = size.width - leftPad;
    final chartH = size.height - bottomPad - topPad;
    final maxVal = data.reduce(max).toDouble();
    final minVal = 0.0;
    final range  = maxVal - minVal;
    final step   = chartW / (data.length - 1);

    for (var i = 0; i < data.length; i++) {
      final x = leftPad + step * i;
      final y = topPad + chartH -
          (chartH * (data[i] - minVal) / range);
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          Row(children: [
            const Icon(Icons.how_to_reg_outlined,
                size: 20, color: Color(0xFF059669)),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Kunlik Davomat (Oxirgi 14 kun)',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary),
              ),
            ),
          ]),
          const SizedBox(height: 4),
          const Text(
            "O'quvchilarning darsga qatnashish dinamikasi",
            style: TextStyle(
                fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 14),

          // ── Stats ──
          Row(children: [
            _Stat(
              value: '${widget.owner.ortachaDavomat}%',
              label: "O'rtacha davomat",
              color: const Color(0xFF059669),
            ),
            const SizedBox(width: 24),
            _Stat(
              value: '${widget.owner.bugunQatnashdi}',
              label: 'Bugun qatnashdi',
              color: AppColors.primary,
            ),
          ]),
          const SizedBox(height: 12),

          // ── Chart with Y-axis label ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Rotated Y-axis label
              RotatedBox(
                quarterTurns: 3,
                child: const Text(
                  "O'quvchilar soni",
                  style: TextStyle(
                      fontSize: 9,
                      color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: GestureDetector(
                  onTapDown: (d) {
                    final chartBox = _chartKey.currentContext
                        ?.findRenderObject() as RenderBox?;
                    if (chartBox == null) return;
                    final local =
                    chartBox.globalToLocal(d.globalPosition);
                    _handleTap(local, chartBox.size);
                  },
                  child: SizedBox(
                    key: _chartKey,
                    height: 200,
                    child: CustomPaint(
                      painter: _DavomatPainter(
                        data: widget.owner.davomatData,
                        labels: widget.owner.davomatLabels,
                        selectedIndex: _selectedIndex,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // ── Legend ──
          Row(children: [
            _LegendDot(
                color: const Color(0xFF059669),
                label: 'Qatnashganlar'),
            const SizedBox(width: 16),
            _LegendDot(
                color: Colors.grey.shade400,
                label: "Jami o'quvchilar",
                hollow: true),
          ]),
        ],
      ),
    );
  }

  final GlobalKey _chartKey = GlobalKey();
}


// ─── Painter ──────────────────────────────────────────────────────────────────

class _DavomatPainter extends CustomPainter {
  final List<int> data;
  final List<String> labels;
  final int? selectedIndex;
  static const _green = Color(0xFF059669);

  _DavomatPainter({
    required this.data,
    required this.labels,
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
    const minVal = 0.0;
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
      final val = (maxVal * i / 4).round();
      if (val > 0) {
        _text(canvas, '$val', Offset(0, y - 6),
            const TextStyle(
                fontSize: 9, color: AppColors.textSecondary));
      }
    }

    // ── Points ──
    final points = List.generate(data.length, (i) {
      final x = leftPad + step * i;
      final y = topPad + chartH -
          (chartH * (data[i] - minVal) / range);
      return Offset(x, y);
    });

    // ── Vertical selected line ──
    if (selectedIndex != null) {
      canvas.drawLine(
        Offset(points[selectedIndex!].dx, topPad),
        Offset(points[selectedIndex!].dx, topPad + chartH),
        Paint()
          ..color = _green.withOpacity(0.25)
          ..strokeWidth = 1.5,
      );
    }

    // ── Fill area ──
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
            _green.withOpacity(0.22),
            _green.withOpacity(0.0)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(
            Rect.fromLTWH(leftPad, topPad, chartW, chartH))
        ..style = PaintingStyle.fill,
    );

    // ── Line ──
    final linePath = Path()
      ..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(
      linePath,
      Paint()
        ..color = _green
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // ── Dots ──
    for (var i = 0; i < points.length; i++) {
      final p = points[i];
      final isSel = selectedIndex == i;
      canvas.drawCircle(p, isSel ? 6.0 : 4.5,
          Paint()..color = Colors.white);
      canvas.drawCircle(p, isSel ? 4.5 : 3.0,
          Paint()..color = _green);
    }

    // ── X labels ──
    for (var i = 0; i < labels.length; i++) {
      if (i % 2 == 0) {
        _text(
          canvas,
          labels[i],
          Offset(points[i].dx - 10, topPad + chartH + 6),
          const TextStyle(
              fontSize: 8, color: AppColors.textSecondary),
        );
      }
    }

    // ── Tooltip ──
    if (selectedIndex != null) {
      final i = selectedIndex!;
      _drawTooltip(canvas, size,
          anchorX: points[i].dx,
          anchorY: points[i].dy,
          line1: labels[i],
          value: '${data[i]}');
    }
  }

  void _drawTooltip(Canvas canvas, Size size,
      {required double anchorX,
        required double anchorY,
        required String line1,
        required String value}) {
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
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(tx, ty, w, h),
          const Radius.circular(r)),
      Paint()..color = Colors.white,
    );

    _text(canvas, line1, Offset(tx + pad, ty + 9),
        const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary));

    const prefix = 'Qatnashdi : ';
    _text(canvas, prefix, Offset(tx + pad, ty + 30),
        const TextStyle(
            fontSize: 12, color: AppColors.textSecondary));
    final prefixW = _measureText(prefix, 12);
    _text(canvas, value,
        Offset(tx + pad + prefixW, ty + 30),
        const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: _green));
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
  bool shouldRepaint(_DavomatPainter old) =>
      old.selectedIndex != selectedIndex;
}

// ─── Helper widgets ───────────────────────────────────────────────────────────

class _Stat extends StatelessWidget {
  final String value, label;
  final Color color;
  const _Stat(
      {required this.value,
        required this.label,
        required this.color});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(value,
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: color)),
      Text(label,
          style: const TextStyle(
              fontSize: 12, color: AppColors.textSecondary)),
    ],
  );
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  final bool hollow;
  const _LegendDot(
      {required this.color, required this.label, this.hollow = false});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 10, height: 10,
        decoration: BoxDecoration(
          color: hollow ? Colors.transparent : color,
          shape: BoxShape.circle,
          border: hollow
              ? Border.all(color: color, width: 1.5)
              : null,
        ),
      ),
      const SizedBox(width: 6),
      Text(label,
          style: const TextStyle(
              fontSize: 12, color: AppColors.textSecondary)),
    ],
  );
}