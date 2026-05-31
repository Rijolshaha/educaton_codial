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
    if (data.isEmpty) {
      return SizedBox(
        height: height,
        child: const Center(
          child: Text(
            "Ma'lumot yo'q",
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: height,
      child: CustomPaint(
        painter: _BarChartPainter(data: data),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<BarChartItem> data;
  _BarChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty || size.width <= 0 || size.height <= 0) return;

    const leftPad = 52.0;
    const bottomPad = 36.0;
    const topPad = 10.0;
    final chartW = size.width - leftPad;
    final chartH = size.height - bottomPad - topPad;
    if (chartW <= 0 || chartH <= 0) return;

    final rawMax = data.map((d) => d.value).reduce(max).toDouble();
    final maxVal = rawMax == 0 ? 1.0 : rawMax;
    final barW = (chartW / data.length) * 0.55;
    final gap = chartW / data.length;

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

    final barPaint = Paint()
      ..color = AppColors.blue1
      ..style = PaintingStyle.fill;

    for (var i = 0; i < data.length; i++) {
      final x = leftPad + gap * i + gap / 2 - barW / 2;
      final barH = chartH * (data[i].value / maxVal);
      final y = topPad + chartH - barH;
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(x, y, barW, barH),
          topLeft: const Radius.circular(4),
          topRight: const Radius.circular(4),
        ),
        barPaint,
      );
      final lbl = data[i].label.length > 9
          ? data[i].label.substring(0, 9)
          : data[i].label;
      _textCentered(canvas, lbl, x + barW / 2, topPad + chartH + 6, size.width,
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

  void _textCentered(Canvas canvas, String text, double centerX, double y,
      double maxWidth, TextStyle style) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    var dx = centerX - tp.width / 2;
    if (dx < 0) dx = 0;
    if (dx + tp.width > maxWidth) dx = maxWidth - tp.width;
    tp.paint(canvas, Offset(dx, y));
  }

  String _fmtK(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${n ~/ 1000}k';
    return '$n';
  }

  @override
  bool shouldRepaint(_BarChartPainter old) => old.data != data;
}
