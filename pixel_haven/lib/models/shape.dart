import 'dart:ui'; // Cần thư viện này để dùng Canvas, Paint, Color, Offset

// Enum để định danh loại hình (Rất quan trọng cho Phase 4 - Lưu file)
enum ShapeType { point, line, rectangle, square, circle, ellipse }

abstract class Shape {
  // 1. Dữ liệu hình học (Geometry)
  // Mọi hình vẽ cơ bản (kéo-thả) đều có thể định nghĩa bằng 2 điểm:
  // Điểm bắt đầu (khi nhấn chuột) và điểm kết thúc (khi thả chuột).
  Offset startPoint;
  Offset endPoint;

  // 2. Dữ liệu giao diện (Appearance)
  Color strokeColor;
  double strokeWidth;
  Color
  fillColor; // Một số hình (Line) có thể không dùng, nhưng để ở đây cho tiện quản lý chung.

  Shape({
    required this.startPoint,
    required this.endPoint,
    required this.strokeColor,
    required this.strokeWidth,
    this.fillColor = const Color(0x00000000), // Mặc định trong suốt
  });

  // 3. Hành vi (Behavior)
  // Abstract method: Các class con BẮT BUỘC phải tự định nghĩa cách vẽ của mình.
  void draw(Canvas canvas, Paint paint);

  // Phương thức này sẽ dùng ở Phase 4, nhưng ta khai báo trước để giữ đúng contract.
  // Trả về Map để dễ debug trước, sau này đổi sang binary sau.
  Map<String, dynamic> toJson();

  // Getter để lấy loại hình (hữu ích khi lưu file)
  ShapeType get type;
}
