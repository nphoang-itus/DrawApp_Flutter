import 'dart:typed_data';
import 'dart:ui';
import 'package:pixel_haven/models/circle.dart';
import 'package:pixel_haven/models/ellipse.dart';
import 'package:pixel_haven/models/line.dart';
import 'package:pixel_haven/models/point.dart';
import 'package:pixel_haven/models/rectangle.dart';
import 'package:pixel_haven/models/square.dart';

import '../models/shape.dart';

class ShapeFactory {
  // Hàm này nhận vào đúng 45 bytes dữ liệu của 1 hình và trả về Object Shape
  static Shape fromBytes(Uint8List bytes) {
    final buffer = ByteData.view(bytes.buffer);

    // 1. Đọc Type
    final typeIndex = buffer.getUint8(0);
    final type = ShapeType.values[typeIndex];

    // 2. Đọc Start Point
    final startX = buffer.getFloat64(1, Endian.host);
    final startY = buffer.getFloat64(9, Endian.host);
    final startPoint = Offset(startX, startY);

    // 3. Đọc End Point
    final endX = buffer.getFloat64(17, Endian.host);
    final endY = buffer.getFloat64(25, Endian.host);
    final endPoint = Offset(endX, endY);

    // 4. Đọc Color
    final colorValue = buffer.getInt32(33, Endian.host);
    final color = Color(colorValue);

    // 5. Đọc Stroke Width
    final strokeWidth = buffer.getFloat64(37, Endian.host);

    // Factory Pattern: Switch case để tạo đúng instance
    switch (type) {
      case ShapeType.line:
        return LineShape(
          startPoint: startPoint,
          endPoint: endPoint,
          strokeColor: color,
          strokeWidth: strokeWidth,
        );
      case ShapeType.rectangle:
        return RectangleShape(
          startPoint: startPoint,
          endPoint: endPoint,
          strokeColor: color,
          strokeWidth: strokeWidth,
          fillColor: const Color(0x00000000),
        ); // Tạm thời chưa lưu fill
      case ShapeType.square:
        return SquareShape(
          startPoint: startPoint,
          endPoint: endPoint,
          strokeColor: color,
          strokeWidth: strokeWidth,
          fillColor: const Color(0x00000000),
        );
      case ShapeType.circle:
        return CircleShape(
          startPoint: startPoint,
          endPoint: endPoint,
          strokeColor: color,
          strokeWidth: strokeWidth,
          fillColor: const Color(0x00000000),
        );
      case ShapeType.ellipse:
        return EllipseShape(
          startPoint: startPoint,
          endPoint: endPoint,
          strokeColor: color,
          strokeWidth: strokeWidth,
          fillColor: const Color(0x00000000),
        );
      case ShapeType.point:
        return PointShape(
          startPoint: startPoint,
          strokeColor: color,
          strokeWidth: strokeWidth,
        );
      default:
        throw Exception("Unknown shape type index: $typeIndex");
    }
  }
}
