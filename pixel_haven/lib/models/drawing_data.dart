import 'shape.dart';

class DrawingData {
  // Danh sách chứa tất cả các hình đã vẽ
  final List<Shape> _shapes = [];

  // Getter dạng unmodifiable để bảo vệ dữ liệu gốc
  List<Shape> get shapes => List.unmodifiable(_shapes);

  void addShape(Shape shape) {
    _shapes.add(shape);
  }

  void clear() {
    _shapes.clear();
  }

  // Todo: Sau này sẽ thêm các hàm như removeLast() để Undo
}
