import 'package:flutter/material.dart';
import '../models/shape.dart'; // Import class Shape từ Phase 1

class DrawingPainter extends CustomPainter {
  final List<Shape> shapes;
  final Shape? currentShape;

  DrawingPainter({required this.shapes, this.currentShape});

  @override
  void paint(Canvas canvas, Size size) {
    // Đây là nơi phép màu xảy ra.
    // Hàm này được gọi mỗi khi Flutter cần vẽ lại khung hình (60fps hoặc 120fps).

    // Tạo một cây cọ mặc định để tái sử dụng
    // Lưu ý: Trong Phase 1, hàm draw() của Shape nhận vào Paint.
    // Việc khởi tạo Paint object tốn tài nguyên, nên ta tạo 1 lần ở đây.
    final paint = Paint();

    // Duyệt qua danh sách và vẽ từng hình
    for (final shape in shapes) {
      shape.draw(canvas, paint);
    }

    if (currentShape != null) {
      currentShape!.draw(canvas, paint);
    }
  }

  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) {
    // Hàm này trả lời câu hỏi: "Có cần vẽ lại không?"
    // Trả về true: Flutter sẽ gọi lại hàm paint().
    // Trả về false: Flutter giữ nguyên hình ảnh cũ (tối ưu hiệu năng).

    // Logic: Nếu danh sách hình cũ khác danh sách hình mới -> Vẽ lại.
    return oldDelegate.shapes.length != shapes.length ||
        oldDelegate.currentShape != currentShape;
  }
}
