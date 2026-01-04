import 'package:flutter/material.dart';
import '../models/shape.dart';
import 'drawing_painter.dart';

class DrawingCanvas extends StatelessWidget {
  final List<Shape> shapes;
  final Shape? currentShape;
  final double width;
  final double height;

  const DrawingCanvas({
    super.key,
    required this.shapes,
    this.currentShape,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    // CustomPaint là widget cầu nối giữa Widget Tree và Render Object
    return CustomPaint(
      painter: DrawingPainter(shapes: shapes, currentShape: currentShape),
      // Size.infinite cho phép canvas mở rộng tối đa
      // Hoặc dùng SizedBox để giới hạn vùng vẽ
      size: Size(width, height),
    );
  }
}
