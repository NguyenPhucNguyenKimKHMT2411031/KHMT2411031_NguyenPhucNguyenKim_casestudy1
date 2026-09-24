import 'package:flutter/material.dart';
import 'sua_giao_dich_screen.dart';
import 'them_giao_dich_screen.dart';

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
      ),
      // Đổi qua lại giữa SuaGiaoDichScreen() và ThemGiaoDichScreen() để xem màn hình tương ứng
      home: const SuaGiaoDichScreen(),
    );
  }
}