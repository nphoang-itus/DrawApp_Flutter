import 'shape.dart';
import 'dart:ui';

class PointShape extends Shape {
  PointShape({
    required super.startPoint,
    required super.strokeColor,
    required super.strokeWidth,
  }) : super(
         endPoint: startPoint, // Điểm đầu = điểm cuối
       );

  @override
  ShapeType get type => ShapeType.point;

  @override
  void draw(Canvas canvas, Paint paint) {
    paint.color = strokeColor;
    paint.strokeWidth = strokeWidth;
    paint.strokeCap = StrokeCap.round;
    // Vẽ 1 điểm tại startPoint
    canvas.drawPoints(PointMode.points, [startPoint], paint);
  }

  @override
  Map<String, dynamic> toJson() => {'type': 'point'};
}
