import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../models/admin_model.dart';

class AdminBarChart extends StatelessWidget {
  final List<BarChartItem> data;
  final double height;

  const AdminBarChart({
    super.key,
    required this.data,
    this.height = 220,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(painter: _BarChartPainter(data: data)),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<BarChartItem> data;
  _BarChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    const leftPad  = 52.0;
    const bottomPad = 36.0;
    const topPad    = 10.0;
    final chartW = size.width - leftPad;
    final chartH = size.height - bottomPad - topPad;

    final maxVal = data.map((d) => d.value).reduce(max).toDouble();
    final barW   = (chartW / data.length) * 0.55;
    final gap    = chartW / data.length;

    // Grid lines + Y labels
    final gridPaint = Paint()
      ..color = const Color(0xFFF3F4F6)
      ..strokeWidth = 1;

    for (var i = 0; i <= 4; i++) {
      final y = topPad + chartH - (chartH * i / 4);
      canvas.drawLine(Offset(leftPad, y), Offset(size.width, y), gridPaint);
      final val = (maxVal * i / 4).round();
      _text(canvas, _fmtK(val), Offset(0, y - 6),
          const TextStyle(fontSize: 9, color: AppColors.textSecondary));
    }

    // Bars
    final barPaint = Paint()
      ..color = AppColors.blue1
      ..style = PaintingStyle.fill;

    for (var i = 0; i < data.length; i++) {
      final x    = leftPad + gap * i + gap / 2 - barW / 2;
      final barH = chartH * (data[i].value / maxVal);
      final y    = topPad + chartH - barH;
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(x, y, barW, barH),
          topLeft:  const Radius.circular(4),
          topRight: const Radius.circular(4),
        ),
        barPaint,
      );
      // X label
      final lbl = data[i].label.length > 8
          ? data[i].label.substring(0, 8)
          : data[i].label;
      _text(canvas, lbl, Offset(x + barW / 2 - 16, topPad + chartH + 6),
          const TextStyle(fontSize: 8, color: AppColors.textSecondary));
    }
  }

  void _text(Canvas canvas, String text, Offset offset, TextStyle style) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, offset);
  }

  String _fmtK(int n) => n >= 1000 ? '${n ~/ 1000}k' : '$n';

  @override
  bool shouldRepaint(_BarChartPainter old) => old.data != data;
}