import 'package:flutter/material.dart';
import 'man_hinh_chao_mung.dart'; // Import màn hình chào mừng vừa tạo

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      // Đặt màn hình chào mừng làm điểm xuất phát đầu tiên của ứng dụng
      home: const WelcomeScreen(),
    );
  }
}