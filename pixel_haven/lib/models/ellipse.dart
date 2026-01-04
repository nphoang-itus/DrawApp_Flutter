import 'dart:ui';
import 'shape.dart';

class EllipseShape extends Shape {
  EllipseShape({
    required super.startPoint,
    required super.endPoint,
    required super.strokeColor,
    required super.strokeWidth,
    required super.fillColor,
  });

  @override
  ShapeType get type => ShapeType.ellipse;

  @override
  void draw(Canvas canvas, Paint paint) {
    final rect = Rect.fromPoints(startPoint, endPoint);

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
  Map<String, dynamic> toJson() => {'type': 'ellipse'};
}
