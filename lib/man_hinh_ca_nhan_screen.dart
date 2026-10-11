import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cá nhân', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Ảnh đại diện và tên người dùng
            const CircleAvatar(
              radius: 36,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text('Nguyễn Văn A', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text('nguyenvana@example.com', style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 20),
            const Divider(),
            // Danh sách các mục quản lý tài khoản
            ProfileMenuItem(icon: Icons.person_outline, title: 'Thông tin cá nhân', onTap: () {}),
            ProfileMenuItem(icon: Icons.tune, title: 'Cài đặt ngân sách', onTap: () {}),
            ProfileMenuItem(icon: Icons.category_outlined, title: 'Danh mục chi tiêu', onTap: () {}),
            ProfileMenuItem(icon: Icons.cloud_upload_outlined, title: 'Sao lưu dữ liệu', onTap: () {}),
            ProfileMenuItem(icon: Icons.lock_outline, title: 'Đổi mật khẩu', onTap: () {}),
            ProfileMenuItem(icon: Icons.logout, title: 'Đăng xuất', textColor: Colors.red, iconColor: Colors.red, onTap: () {}),
          ],
        ),
      ),
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color textColor;
  final Color iconColor;

  const ProfileMenuItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.textColor = Colors.black,
    this.iconColor = Colors.black54,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}