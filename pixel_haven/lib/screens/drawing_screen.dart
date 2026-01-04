import 'dart:typed_data';
import 'dart:ui' as ui; // Cần cái này để xử lý ảnh
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pixel_haven/models/circle.dart';
import 'package:pixel_haven/models/ellipse.dart';
import 'package:pixel_haven/models/line.dart';
import 'package:pixel_haven/models/point.dart';
import 'package:pixel_haven/models/rectangle.dart';
import 'package:pixel_haven/models/square.dart';
import 'package:pixel_haven/services/export_service.dart';
import 'package:pixel_haven/services/file_service.dart';
import '../models/shape.dart';
import '../widgets/drawing_canvas.dart';

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({super.key});

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  // --- STATE DỮ LIỆU ---
  final List<Shape> shapes = []; // Danh sách đã chốt
  Shape? currentShape; // Hình đang vẽ (Preview)
  final FileService _fileService = FileService();
  final GlobalKey _canvasKey = GlobalKey(); // Key để chụp ảnh
  final ExportService _exportService = ExportService(); // Service xuất ảnh

  // --- STATE CÔNG CỤ ---
  ShapeType selectedTool = ShapeType.line; // Mặc định vẽ đường thẳng
  Color selectedColor = Colors.black;
  double selectedStrokeWidth = 3.0;

  // --- FACTORY METHOD (Helper) ---
  // Tạo hình mới dựa trên tool đang chọn
  Shape _createShape(Offset start, Offset end) {
    switch (selectedTool) {
      case ShapeType.line:
        return LineShape(
          startPoint: start,
          endPoint: end,
          strokeColor: selectedColor,
          strokeWidth: selectedStrokeWidth,
        );
      case ShapeType.rectangle:
        return RectangleShape(
          startPoint: start,
          endPoint: end,
          strokeColor: selectedColor,
          strokeWidth: selectedStrokeWidth,
          fillColor: Colors.transparent, // Tạm thời chưa xử lý fill
        );
      case ShapeType.square:
        return SquareShape(
          startPoint: start,
          endPoint: end,
          strokeColor: selectedColor,
          strokeWidth: selectedStrokeWidth,
          fillColor: Colors.transparent,
        );
      case ShapeType.circle:
        return CircleShape(
          startPoint: start,
          endPoint: end,
          strokeColor: selectedColor,
          strokeWidth: selectedStrokeWidth,
          fillColor: Colors.transparent,
        );
      case ShapeType.ellipse:
        return EllipseShape(
          startPoint: start,
          endPoint: end,
          strokeColor: selectedColor,
          strokeWidth: selectedStrokeWidth,
          fillColor: Colors.transparent,
        );
      case ShapeType.point:
        return PointShape(
          startPoint: start,
          strokeColor: selectedColor,
          strokeWidth: selectedStrokeWidth,
        );
    }
  }

  // --- GESTURE HANDLERS ---

  void _onPanStart(DragStartDetails details) {
    // 1. Người dùng bắt đầu chạm tay
    // Lấy toạ độ cục bộ (tính từ góc trên trái của Widget con)
    final startPoint = details.localPosition;

    setState(() {
      // Khởi tạo hình tạm thời. Điểm đầu = điểm cuối.
      currentShape = _createShape(startPoint, startPoint);
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (currentShape == null) return;

    setState(() {
      // Tạo lại object mới với endPoint mới
      currentShape = _createShape(
        currentShape!.startPoint,
        details.localPosition,
      );
    });
  }

  void _onPanEnd(DragEndDetails details) {
    // 3. Người dùng thả tay
    if (currentShape == null) return;

    setState(() {
      // "Commit": Chuyển hình tạm vào danh sách chính
      shapes.add(currentShape!);
      // Reset hình tạm
      currentShape = null;
    });
  }

  // --- UI BUILDER ---

  @override
  Widget build(BuildContext context) {
    // Lấy kích thước gốc của màn hình
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('PixelHaven'),
        backgroundColor: Colors.blueGrey.shade50,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _handleSave,
            tooltip: 'Save .phd',
          ),
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: _handleExport,
            tooltip: 'Export to PNG',
          ),
          IconButton(
            icon: const Icon(Icons.folder_open),
            onPressed: _handleLoad,
            tooltip: 'Open .phd',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => setState(() => shapes.clear()),
            tooltip: 'Clear All',
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. TOOLBAR (Thanh công cụ đơn giản)
          Container(
            height: 60,
            color: Colors.grey.shade200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildToolButton(Icons.edit, ShapeType.point),
                _buildToolButton(Icons.show_chart, ShapeType.line), // Icon line
                _buildToolButton(Icons.crop_square, ShapeType.rectangle),
                _buildToolButton(
                  Icons.check_box_outline_blank,
                  ShapeType.square,
                ),
                _buildToolButton(Icons.circle_outlined, ShapeType.circle),
                _buildToolButton(Icons.egg_outlined, ShapeType.ellipse),
              ],
            ),
          ),

          // 2. CANVAS AREA
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,

              // Đăng ký các sự kiện chạm
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,

              child: RepaintBoundary(
                key: _canvasKey,
                child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: double.infinity,
                  // Sử dụng ClipRect để nét vẽ không bị tràn ra ngoài vùng chứa
                  child: ClipRect(
                    child: DrawingCanvas(
                      shapes: shapes,
                      currentShape: currentShape, // Truyền preview xuống
                      width: size.width,
                      height: size.height,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget helper để tạo nút chọn tool
  Widget _buildToolButton(IconData icon, ShapeType type) {
    final isSelected = selectedTool == type;
    return IconButton(
      icon: Icon(icon),
      color: isSelected ? Colors.blue : Colors.black,
      style: IconButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue.withOpacity(0.1) : null,
      ),
      onPressed: () {
        setState(() {
          selectedTool = type;
        });
      },
    );
  }

  // --- FILE SERVICE ---
  // Hàm xử lý Save
  Future<void> _handleSave() async {
    try {
      // Gọi hàm save và nhận lại đường dẫn
      final path = await _fileService.saveFile(shapes);

      if (mounted && path != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Saved to: $path'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  // Hàm xử lý Load
  Future<void> _handleLoad() async {
    try {
      final loadedShapes = await _fileService.loadFile();
      if (loadedShapes.isNotEmpty) {
        setState(() {
          shapes.clear();
          shapes.addAll(loadedShapes);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading: $e')));
      }
    }
  }

  // Hàm xử lý xuất ảnh PNG
  Future<void> _handleExport() async {
    try {
      // 1. Tìm RenderObject của cái Boundary đang gắn Key
      final boundary =
          _canvasKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;

      if (boundary == null) return;

      // 2. Chuyển thành Image
      // pixelRatio: 3.0 giúp ảnh nét hơn (gấp 3 lần độ phân giải màn hình)
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);

      // 3. Chuyển thành Bytes (PNG)
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) return;

      final Uint8List pngBytes = byteData.buffer.asUint8List();

      // 4. Gọi Service để lưu
      await _exportService.exportImage(pngBytes);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image exported successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Export failed: $e')));
      }
    }
  }
}
