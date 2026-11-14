import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'danh_sach_giao_dich_screen.dart';
import 'thong_ke_screen.dart';
import 'man_hinh_ca_nhan_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 1; // Đặt là 1 để mặc định mở vào tab "Giao dịch"

  // Danh sách 4 màn hình tương ứng với 4 nút ở dưới
  final List<Widget> _screens = [
    const DashboardScreen(),         // 0. Trang chủ
    TransactionListScreen(),         // 1. Giao dịch
    const StatisticsScreen(),        // 2. Thống kê (hoặc Cải đặt)
    const ProfileScreen(),           // 3. Cá nhân
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Chuyển màn hình khi bấm vào các nút bên dưới
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Giao dịch'),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart_outline), label: 'Thống kê'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Cá nhân'),
        ],
      ),
    );
  }
}