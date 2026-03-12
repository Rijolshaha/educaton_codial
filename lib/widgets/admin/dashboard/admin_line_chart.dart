import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';

class AdminLineChart extends StatelessWidget {
  final List<int> data;
  final List<String> labels;
  final Color color;
  final bool filled;
  final double height;

  const AdminLineChart({
    super.key,
    required this.data,
    required this.labels,
    required this.color,
    this.filled = false,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: _LineChartPainter(
          data: data,
          labels: labels,
          color: color,
          filled: filled,
        ),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<int> data;
  final List<String> labels;
  final Color color;
  final bool filled;

  _LineChartPainter({
    required this.data,
    required this.labels,
    required this.color,
    required this.filled,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const leftPad   = 46.0;
    const bottomPad = 28.0;
    const topPad    = 10.0;
    final chartW = size.width - leftPad;
    final chartH = size.height - bottomPad - topPad;

    final maxVal = data.reduce(max).toDouble();
    final minVal = (data.reduce(min) * 0.85).toDouble();
    final range  = maxVal - minVal;

    // Grid
    final gridPaint = Paint()
      ..color = const Color(0xFFF3F4F6)
      ..strokeWidth = 1;

    for (var i = 0; i <= 4; i++) {
      final y = topPad + chartH - (chartH * i / 4);
      canvas.drawLine(Offset(leftPad, y), Offset(size.width, y), gridPaint);
      final val = (minVal + range * i / 4).round();
      _text(canvas, '$val', Offset(0, y - 6),
          const TextStyle(fontSize: 9, color: AppColors.textSecondary));
    }

    // Points
    final step = chartW / (data.length - 1);
    final points = List.generate(data.length, (i) {
      final x = leftPad + step * i;
      final y = topPad + chartH - (chartH * (data[i] - minVal) / range);
      return Offset(x, y);
    });

    // Fill area
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
            colors: [color.withOpacity(0.25), color.withOpacity(0.0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(Rect.fromLTWH(leftPad, topPad, chartW, chartH))
          ..style = PaintingStyle.fill,
      );
    }

    // Line
    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
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

    // Dots
    for (final p in points) {
      canvas.drawCircle(p, 4.5, Paint()..color = Colors.white);
      canvas.drawCircle(p, 3.0, Paint()..color = color);
    }

    // X labels (every 2nd)
    for (var i = 0; i < labels.length; i++) {
      if (i % 2 == 0) {
        _text(
          canvas,
          labels[i],
          Offset(points[i].dx - 8, topPad + chartH + 6),
          const TextStyle(fontSize: 9, color: AppColors.textSecondary),
        );
      }
    }
  }

  void _text(Canvas canvas, String text, Offset offset, TextStyle style) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(_LineChartPainter old) => false;
}