import 'dart:ui';
import 'shape.dart';

class RectangleShape extends Shape {
  RectangleShape({
    required super.startPoint,
    required super.endPoint,
    required super.strokeColor,
    required super.strokeWidth,
    required super.fillColor,
  });

  @override
  ShapeType get type => ShapeType.rectangle;

  @override
  void draw(Canvas canvas, Paint paint) {
    // Tạo hình chữ nhật từ 2 điểm
    final rect = Rect.fromPoints(startPoint, endPoint);

    // 1. Vẽ nền (Fill) trước
    if (fillColor.opacity > 0) {
      paint.style = PaintingStyle.fill;
      paint.color = fillColor;
      canvas.drawRect(rect, paint);
    }

    // 2. Vẽ viền (Stroke) sau đè lên
    paint.style = PaintingStyle.stroke;
    paint.color = strokeColor;
    paint.strokeWidth = strokeWidth;
    canvas.drawRect(rect, paint);
  }

  @override
  Map<String, dynamic> toJson() => {'type': 'rectangle'};
}
