import 'dart:ui';
import 'shape.dart';
import 'dart:math'; // Cần cho hàm min/max

class SquareShape extends Shape {
  SquareShape({
    required super.startPoint,
    required super.endPoint,
    required super.strokeColor,
    required super.strokeWidth,
    required super.fillColor,
  });

  @override
  ShapeType get type => ShapeType.square;

  @override
  void draw(Canvas canvas, Paint paint) {
    // Tính toán hình vuông dựa trên điểm bắt đầu và vị trí hiện tại
    final double dx = endPoint.dx - startPoint.dx;
    final double dy = endPoint.dy - startPoint.dy;

    // Lấy cạnh ngắn hơn (hoặc dài hơn tùy trải nghiệm UX bạn muốn)
    // Ở đây tôi chọn cạnh ngắn hơn để hình vuông luôn nằm trong vùng kéo chuột
    final double side = min(dx.abs(), dy.abs());

    // Xác định hướng kéo để vẽ hình vuông đúng hướng
    final double signX = dx.sign; // 1.0 hoặc -1.0
    final double signY = dy.sign;

    final rect = Rect.fromLTWH(
      startPoint.dx,
      startPoint.dy,
      side * signX,
      side * signY,
    );

    // Vẽ Fill
    if (fillColor.opacity > 0) {
      paint.style = PaintingStyle.fill;
      paint.color = fillColor;
      canvas.drawRect(rect, paint);
    }

    // Vẽ Stroke
    paint.style = PaintingStyle.stroke;
    paint.color = strokeColor;
    paint.strokeWidth = strokeWidth;
    canvas.drawRect(rect, paint);
  }

  @override
  Map<String, dynamic> toJson() => {'type': 'square'};
}
