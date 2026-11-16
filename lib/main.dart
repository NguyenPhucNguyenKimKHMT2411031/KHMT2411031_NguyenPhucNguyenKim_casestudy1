import 'package:flutter/material.dart';
import 'main_navigation.dart';

void main() async {
  // Khởi tạo binding trước khi chạy các tác vụ bất đồng bộ SQLite
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MainNavigation(),
  ));
}