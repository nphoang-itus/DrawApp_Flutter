import 'package:flutter/material.dart';
import 'package:pixel_haven/screens/drawing_screen.dart';
// Chúng ta sẽ import màn hình chính sau khi tạo nó
// import 'screens/drawing_screen.dart';

void main() {
  runApp(const PixelHavenApp());
}

class PixelHavenApp extends StatelessWidget {
  const PixelHavenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PixelHaven',
      debugShowCheckedModeBanner: false, // Tắt chữ DEBUG đỏ ở góc phải
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Tạm thời để Scaffold rỗng, ta sẽ thay bằng DrawingScreen sau
      home: const DrawingScreen(),
    );
  }
}
