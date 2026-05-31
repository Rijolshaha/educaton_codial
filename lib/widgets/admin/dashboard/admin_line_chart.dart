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
    if (data.isEmpty || labels.isEmpty) {
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
        painter: _LineChartPainter(
          data: data,
          labels: labels,
          color: color,
          filled: filled,
        ),
        child: const SizedBox.expand(),
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
    if (data.isEmpty || size.width <= 0 || size.height <= 0) return;

    const leftPad = 46.0;
    const bottomPad = 28.0;
    const topPad = 10.0;
    final chartW = size.width - leftPad;
    final chartH = size.height - bottomPad - topPad;
    if (chartW <= 0 || chartH <= 0) return;

    final maxVal = data.reduce(max).toDouble();
    final minVal = filled ? 0.0 : (data.reduce(min) * 0.85);
    final rawRange = maxVal - minVal;
    final range = rawRange == 0 ? 1.0 : rawRange;

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

    // Bitta nuqta bo'lsa — markazda chizamiz
    if (data.length == 1) {
      final x = leftPad + chartW / 2;
      final y = topPad + chartH - (chartH * (data[0] - minVal) / range);
      canvas.drawCircle(Offset(x, y), 4.5, Paint()..color = Colors.white);
      canvas.drawCircle(Offset(x, y), 3.0, Paint()..color = color);
      if (labels.isNotEmpty) {
        _textCentered(canvas, labels[0], x, topPad + chartH + 6, size.width,
            const TextStyle(fontSize: 9, color: AppColors.textSecondary));
      }
      return;
    }

    final step = chartW / (data.length - 1);
    final points = List.generate(data.length, (i) {
      final x = leftPad + step * i;
      final y = topPad + chartH - (chartH * (data[i] - minVal) / range);
      return Offset(x, y);
    });

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

    for (final p in points) {
      canvas.drawCircle(p, 4.5, Paint()..color = Colors.white);
      canvas.drawCircle(p, 3.0, Paint()..color = color);
    }

    final labelStep = labels.length > 8 ? 2 : 1;
    for (var i = 0; i < labels.length && i < points.length; i++) {
      if (i % labelStep == 0) {
        _textCentered(
          canvas,
          labels[i],
          points[i].dx,
          topPad + chartH + 6,
          size.width,
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

  @override
  bool shouldRepaint(_LineChartPainter old) =>
      old.data != data ||
      old.labels != labels ||
      old.color != color ||
      old.filled != filled;
}
