import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Cá nhân',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // 1. Avatar và Thông tin tài khoản
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2B72FB),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 45,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Nguyễn Văn A',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'nguyenvana@example.com',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Divider(thickness: 1, color: Color(0xFFF0F0F0)),

            // 2. Danh sách các mục có gắn sự kiện bấm chuyển trang
            _buildMenuItem(
              icon: Icons.person_outline_rounded,
              title: 'Thông tin cá nhân',
              onTap: () {
                _navigateTo(context, const PersonalInfoScreen());
              },
            ),
            _buildMenuItem(
              icon: Icons.tune_rounded,
              title: 'Cài đặt ngân sách',
              onTap: () {
                _navigateTo(context, const BudgetSettingScreen());
              },
            ),
            _buildMenuItem(
              icon: Icons.category_outlined,
              title: 'Danh mục chi tiêu',
              onTap: () {
                _navigateTo(context, const CategoryManagementScreen());
              },
            ),
            _buildMenuItem(
              icon: Icons.cloud_upload_outlined,
              title: 'Sao lưu dữ liệu',
              onTap: () {
                _navigateTo(context, const BackupScreen());
              },
            ),
            _buildMenuItem(
              icon: Icons.lock_outline_rounded,
              title: 'Đổi mật khẩu',
              onTap: () {
                _navigateTo(context, const ChangePasswordScreen());
              },
            ),
            _buildMenuItem(
              icon: Icons.logout_rounded,
              title: 'Đăng xuất',
              textColor: Colors.red,
              iconColor: Colors.red,
              onTap: () {
                // Hiển thị hộp thoại xác nhận đăng xuất
                _showLogoutDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Hàm chuyển trang tiện ích
  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  // Hộp thoại xác nhận đăng xuất
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất khỏi tài khoản không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Thêm logic quay về màn hình Welcome ở đây nếu muốn
            },
            child: const Text('Đăng xuất', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color textColor = Colors.black87,
    Color iconColor = Colors.black54,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor, size: 22),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: Colors.grey,
        size: 20,
      ),
      onTap: onTap,
    );
  }
}

// ==========================================
// CÁC MÀN HÌNH CON TƯƠNG ỨNG KHI BẤM VÀO
// ==========================================

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thông tin cá nhân')),
      body: const Center(child: Text('Nội dung Thông tin cá nhân')),
    );
  }
}

class BudgetSettingScreen extends StatelessWidget {
  const BudgetSettingScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cài đặt ngân sách')),
      body: const Center(child: Text('Nội dung Cài đặt ngân sách')),
    );
  }
}

class CategoryManagementScreen extends StatelessWidget {
  const CategoryManagementScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Danh mục chi tiêu')),
      body: const Center(child: Text('Nội dung Danh mục chi tiêu')),
    );
  }
}

class BackupScreen extends StatelessWidget {
  const BackupScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sao lưu dữ liệu')),
      body: const Center(child: Text('Nội dung Sao lưu dữ liệu')),
    );
  }
}

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đổi mật khẩu')),
      body: const Center(child: Text('Nội dung Đổi mật khẩu')),
    );
  }
}