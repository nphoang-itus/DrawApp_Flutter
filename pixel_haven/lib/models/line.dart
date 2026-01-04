import 'dart:ui';
import 'shape.dart';

class LineShape extends Shape {
  LineShape({
    required super.startPoint,
    required super.endPoint,
    required super.strokeColor,
    required super.strokeWidth,
  });

  @override
  ShapeType get type => ShapeType.line;

  @override
  void draw(Canvas canvas, Paint paint) {
    // Cấu hình cọ vẽ (Paint)
    paint.color = strokeColor;
    paint.strokeWidth = strokeWidth;
    paint.style = PaintingStyle.stroke; // Đường thẳng chỉ có viền
    paint.strokeCap = StrokeCap.round; // Bo tròn đầu nét vẽ cho đẹp

    canvas.drawLine(startPoint, endPoint, paint);
  }

  @override
  Map<String, dynamic> toJson() {
    // Tạm thời chưa implement chi tiết
    return {'type': 'line'};
  }
}
