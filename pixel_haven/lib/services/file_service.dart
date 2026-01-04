import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import '../models/shape.dart';
import 'shape_factory.dart';

class FileService {
  // MAGIC NUMBER: 'P', 'H', 'D', '\\0' (Null terminator)
  static const List<int> magicNumber = [0x50, 0x48, 0x44, 0x00];

  // --- SAVE ---
  Future<String?> saveFile(List<Shape> shapes) async {
    // 1. Xây dựng nội dung file (Builder pattern)
    final builder = BytesBuilder();

    // Header: Magic Number
    builder.add(magicNumber);

    // Header: Version (0x01)
    builder.addByte(0x01);

    // Body: Số lượng hình (4 bytes)
    final countBuffer = ByteData(4);
    countBuffer.setInt32(0, shapes.length, Endian.host);
    builder.add(countBuffer.buffer.asUint8List());

    // Body: Dữ liệu từng hình
    for (final shape in shapes) {
      builder.add(shape.toBytes());
    }

    final bytes = builder.toBytes();

    // Multi Platform: Andoroid, IOS, MacOS, Windows
    // 2. Chọn nơi lưu file
    // String? outputFile;

    // if (Platform.isAndroid || Platform.isIOS) {
    //   // // Trên mobile: truyền bytes trực tiếp
    //   // outputFile = await FilePicker.platform.saveFile(
    //   //   dialogTitle: 'Save PixelHaven Drawing',
    //   //   fileName: 'drawing.phd',
    //   //   type: FileType.any,
    //   //   bytes: bytes, // ← Chỉ dùng trên Android/iOS
    //   // );
    // } else {
    //   // Trên desktop: KHÔNG truyền bytes, chỉ lấy đường dẫn
    //   outputFile = await FilePicker.platform.saveFile(
    //     dialogTitle: 'Save PixelHaven Drawing',
    //     fileName: 'drawing.phd',
    //     type: FileType.custom,
    //     allowedExtensions: ['phd'],
    //   );
    // }

    // if (outputFile == null) {
    //   throw Exception('Save cancelled by user');
    // }

    // // 3. Ghi xuống đĩa (chỉ cần trên desktop)
    // if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
    //   final file = File(outputFile);
    //   await file.writeAsBytes(bytes);
    // }

    if (Platform.isWindows) {
      return _saveOnWindows(bytes);
    } else {
      return _saveOnAndroid(bytes);
    }
  }

  // --- LOAD ---
  Future<List<Shape>> loadFile() async {
    // 1. Chọn file để mở
    FilePickerResult? result;

    if (Platform.isAndroid || Platform.isIOS) {
      // Trên mobile: dùng FileType.any
      result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );
    } else {
      // Trên desktop: dùng custom extension
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['phd'],
        allowMultiple: false,
      );
    }

    if (result == null || result.files.single.path == null) {
      throw Exception('Load cancelled by user');
    }

    final file = File(result.files.single.path!);
    final bytes = await file.readAsBytes();
    final buffer = ByteData.view(bytes.buffer);
    int offset = 0;

    // 2. Validate Header
    // Kiểm tra Magic Number (4 bytes đầu)
    for (int i = 0; i < 4; i++) {
      if (bytes[i] != magicNumber[i]) {
        throw Exception("Invalid file format: Not a PHD file");
      }
    }
    offset += 4;

    // Kiểm tra Version
    final version = bytes[offset]; // Đọc byte thứ 5
    offset += 1;
    if (version != 1) {
      throw Exception("Unsupported version: $version");
    }

    // 3. Đọc số lượng hình
    final count = buffer.getInt32(offset, Endian.host);
    offset += 4;

    // 4. Đọc từng hình
    List<Shape> loadedShapes = [];
    const int shapeSize = 45; // Kích thước cố định đã tính toán

    for (int i = 0; i < count; i++) {
      // Cắt đúng 45 bytes cho hình hiện tại
      // Lưu ý: Cần kiểm tra xem file có đủ dữ liệu không để tránh crash
      if (offset + shapeSize > bytes.length) {
        throw Exception("File corrupted: Unexpected end of file");
      }

      final shapeBytes = bytes.sublist(offset, offset + shapeSize);
      final shape = ShapeFactory.fromBytes(shapeBytes);
      loadedShapes.add(shape);

      offset += shapeSize;
    }

    return loadedShapes;
  }

  // --- CROSS PLATFORM ---
  Future<String?> _saveOnWindows(Uint8List bytes) async {
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Save PixelHaven Drawing',
      fileName: 'drawing.phd',
      type: FileType.custom,
      allowedExtensions: ['phd'],
    );

    if (outputFile != null) {
      final file = File(outputFile);
      await file.writeAsBytes(bytes);
    }

    return outputFile;
  }

  // Logic lưu trên Android (Tự động lưu vào thư mục Documents của App)
  Future<String?> _saveOnAndroid(Uint8List bytes) async {
    // // Lấy thư mục Documents dành riêng cho App => Cách này ko ổn vì nó lưu vào data mở bằng Android Studio
    // // Android không cho phép lưu lung tung nếu không có quyền đặc biệt
    // final directory = await getApplicationDocumentsDirectory();

    // // Tạo tên file dựa trên thời gian thực: drawing_20231025_103000.phd
    // final now = DateTime.now();
    // final timestamp =
    //     "${now.year}${now.month}${now.day}_${now.hour}${now.minute}${now.second}";
    // final fileName = "pixelhaven_$timestamp.phd";

    // final path = '${directory.path}/$fileName';
    // final file = File(path);

    // await file.writeAsBytes(bytes);
    // return path; // Trả về đường dẫn để báo user

    // Trên mobile: truyền bytes trực tiếp
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Save PixelHaven Drawing',
      fileName: 'drawing.phd',
      type: FileType.any,
      bytes: bytes, // ← Chỉ dùng trên Android/iOS
    );

    if (outputFile == null) {
      throw Exception('Save cancelled by user');
    }

    return outputFile;
  }
}
