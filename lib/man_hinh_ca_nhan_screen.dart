import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = 'Nguyễn Phúc Nguyên Kim';
  String _userEmail = 'nguyenkim.khmt24@example.com';
  String _monthlyBudget = '5.000.000';

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _userName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cập nhật thông tin'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Họ và tên'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                setState(() => _userName = nameController.text.trim());
              }
              Navigator.pop(context);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  void _showBudgetDialog() {
    final budgetController = TextEditingController(text: _monthlyBudget.replaceAll('.', ''));
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cài đặt ngân sách tháng'),
        content: TextField(
          controller: budgetController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Hạn mức chi tiêu (VNĐ)'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () {
              final raw = budgetController.text.trim();
              if (raw.isNotEmpty) {
                final formatted = raw.replaceAllMapped(
                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                      (Match m) => '${m[1]}.',
                );
                setState(() => _monthlyBudget = formatted);
              }
              Navigator.pop(context);
            },
            child: const Text('Áp dụng'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất khỏi ứng dụng?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã đăng xuất phiên làm việc!')),
              );
            },
            child: const Text('Đăng xuất', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Cá nhân', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 36,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(_userName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(_userEmail, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 8),
            Chip(
              backgroundColor: Colors.blue.shade50,
              label: Text(
                'Ngân sách tháng: $_monthlyBudget đ',
                style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600, fontSize: 12),
              ),
            ),
            const SizedBox(height: 12),
            const Divider(),
            ProfileMenuItem(
              icon: Icons.person_outline,
              title: 'Thông tin cá nhân',
              onTap: _showEditProfileDialog,
            ),
            ProfileMenuItem(
              icon: Icons.tune,
              title: 'Cài đặt ngân sách',
              onTap: _showBudgetDialog,
            ),
            ProfileMenuItem(
              icon: Icons.category_outlined,
              title: 'Danh mục chi tiêu',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Danh mục mặc định: Ăn uống, Mua sắm, Đi lại, Học tập, Hóa đơn')),
                );
              },
            ),
            ProfileMenuItem(
              icon: Icons.cloud_upload_outlined,
              title: 'Sao lưu dữ liệu',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã sao lưu cơ sở dữ liệu SQLite cục bộ thành công!')),
                );
              },
            ),
            ProfileMenuItem(
              icon: Icons.lock_outline,
              title: 'Đổi mật khẩu',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tính năng đang phát triển ở phiên bản sau')),
                );
              },
            ),
            ProfileMenuItem(
              icon: Icons.logout,
              title: 'Đăng xuất',
              textColor: Colors.red,
              iconColor: Colors.red,
              onTap: _showLogoutDialog,
            ),
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
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.textColor = Colors.black,
    this.iconColor = Colors.black54,
  });

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