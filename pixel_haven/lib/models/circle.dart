import 'shape.dart';
import 'dart:ui';
import 'dart:math';

class CircleShape extends Shape {
  CircleShape({
    required super.startPoint,
    required super.endPoint,
    required super.strokeColor,
    required super.strokeWidth,
    required super.fillColor,
  });

  @override
  ShapeType get type => ShapeType.circle;

  @override
  void draw(Canvas canvas, Paint paint) {
    // Logic tương tự Square: Ép về hình vuông bao quanh hình tròn
    final double dx = endPoint.dx - startPoint.dx;
    final double dy = endPoint.dy - startPoint.dy;
    final double diameter = min(dx.abs(), dy.abs());
    final double signX = dx.sign;
    final double signY = dy.sign;

    final rect = Rect.fromLTWH(
      startPoint.dx,
      startPoint.dy,
      diameter * signX,
      diameter * signY,
    );

    if (fillColor.opacity > 0) {
      paint.style = PaintingStyle.fill;
      paint.color = fillColor;
      canvas.drawOval(rect, paint);
    }

    paint.style = PaintingStyle.stroke;
    paint.color = strokeColor;
    paint.strokeWidth = strokeWidth;
    canvas.drawOval(rect, paint);
  }

  @override
  Map<String, dynamic> toJson() => {'type': 'circle'};
}
