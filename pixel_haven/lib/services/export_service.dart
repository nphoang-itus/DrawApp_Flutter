import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:gal/gal.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class ExportService {
  // Hàm này nhận vào mảng bytes của ảnh (PNG/JPEG)
  Future<void> exportImage(Uint8List imageBytes) async {
    if (Platform.isWindows) {
      await _saveOnWindows(imageBytes);
    } else if (Platform.isAndroid) {
      await _saveOnAndroid(imageBytes);
    }
  }

  // Windows: Mở hộp thoại "Save As..."
  Future<void> _saveOnWindows(Uint8List bytes) async {
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Export Image',
      fileName: 'pixelhaven_art.png',
      type: FileType.image,
      allowedExtensions: ['png', 'jpg'],
    );

    if (outputFile != null) {
      final file = File(outputFile);
      await file.writeAsBytes(bytes);
    }
  }

  // Android: Lưu vào Thư viện ảnh (Gallery)
  Future<void> _saveOnAndroid(Uint8List bytes) async {
    // 1. Kiểm tra quyền (Android 13+)
    if (Platform.isAndroid) {
      // Android 13+ sử dụng quyền mới
      if (await Permission.photos.isDenied) {
        final status = await Permission.photos.request();
        if (!status.isGranted) {
          throw Exception('Permission denied');
        }
      }
    }

    // 2. Tạo file tạm trong thư mục cache
    final tempDir = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final tempFile = File('${tempDir.path}/pixelhaven_$timestamp.png');

    // 3. Ghi bytes vào file tạm
    await tempFile.writeAsBytes(bytes);

    // 4. Lưu vào Gallery bằng gal
    await Gal.putImage(tempFile.path);

    // 5. Xóa file tạm (optional)
    await tempFile.delete();
  }
}
