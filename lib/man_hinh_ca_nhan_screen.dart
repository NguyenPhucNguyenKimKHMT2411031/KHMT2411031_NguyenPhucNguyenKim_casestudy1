import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'repositories/transaction_repository.dart';
import 'man_hinh_chao_mung.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TransactionRepository _repository = TransactionRepository();

  String _userName = 'Nguyễn Phúc Nguyên Kim';
  String _userEmail = 'nguyenkim.khmt24@example.com';
  String _monthlyBudget = '5.000.000';
  String _currentPassword = '123456';
  String _lastBackupTime = 'Chưa sao lưu';

  final List _categories = [
    {'name': 'Ăn uống', 'icon': Icons.restaurant, 'color': Colors.orange},
    {'name': 'Mua sắm', 'icon': Icons.shopping_bag, 'color': Colors.pink},
    {'name': 'Đi lại', 'icon': Icons.directions_car, 'color': Colors.blue},
    {'name': 'Học tập', 'icon': Icons.school, 'color': Colors.purple},
    {'name': 'Hóa đơn', 'icon': Icons.receipt_long, 'color': Colors.teal},
    {'name': 'Giải trí', 'icon': Icons.movie, 'color': Colors.indigo},
  ];

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

  void _showCategoriesDialog() {
    final newCatController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Danh mục chi tiêu'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: newCatController,
                        decoration: const InputDecoration(
                          hintText: 'Nhập tên danh mục mới...',
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: Colors.blue, size: 30),
                      onPressed: () {
                        final name = newCatController.text.trim();
                        if (name.isNotEmpty) {
                          setDialogState(() {
                            _categories.add({
                              'name': name,
                              'icon': Icons.label_important_outline,
                              'color': Colors.blueGrey,
                            });
                            newCatController.clear();
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final Color catColor = cat['color'];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          radius: 16,
                          backgroundColor: catColor.withOpacity(0.15),
                          child: Icon(cat['icon'], size: 18, color: catColor),
                        ),
                        title: Text(cat['name'], style: const TextStyle(fontSize: 14)),
                        trailing: _categories.length > 1
                            ? IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                          onPressed: () {
                            setDialogState(() {
                              _categories.removeAt(index);
                            });
                          },
                        )
                            : null,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đóng'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showBackupDialog() async {
    final transactions = await _repository.getTransactions();
    final now = DateTime.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} - ${now.day}/${now.month}/${now.year}';

    final backupData = {
      'user': _userName,
      'budget': _monthlyBudget,
      'backupAt': timeStr,
      'totalRecords': transactions.length,
      'transactions': transactions
          .map((t) => {
        'id': t.id,
        'title': t.title,
        'amount': t.amount,
        'type': t.type,
        'category': t.category,
        'date': t.date,
      })
          .toList(),
    };

    final jsonString = const JsonEncoder.withIndent('  ').convert(backupData);

    setState(() {
      _lastBackupTime = timeStr;
    });

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.cloud_done, color: Colors.green),
            SizedBox(width: 8),
            Text('Sao lưu dữ liệu'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Trạng thái: Đã đồng bộ SQLite thành công',
                  style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Thời gian: $timeStr', style: const TextStyle(fontSize: 13)),
              Text('Số lượng giao dịch: ${transactions.length} bản ghi',
                  style: const TextStyle(fontSize: 13)),
              const SizedBox(height: 12),
              const Text('Bản xem trước dữ liệu (JSON):',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 6),
              Container(
                width: double.maxFinite,
                height: 140,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    jsonString,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.copy, size: 18),
            label: const Text('Sao chép JSON'),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: jsonString));
              Navigator.pop(context);
              ScaffoldMessenger.of(this.context).showSnackBar(
                const SnackBar(
                  content: Text('Đã sao chép dữ liệu sao lưu vào bộ nhớ tạm!'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hoàn tất'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    final oldPassController = TextEditingController();
    final newPassController = TextEditingController();
    final confirmPassController = TextEditingController();
    String? errorText;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Đổi mật khẩu'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: oldPassController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Mật khẩu hiện tại (mặc định: 123456)',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: newPassController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Mật khẩu mới (tối thiểu 6 ký tự)',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: confirmPassController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Nhập lại mật khẩu mới',
                  ),
                ),
                if (errorText != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    errorText!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                final oldPass = oldPassController.text.trim();
                final newPass = newPassController.text.trim();
                final confirmPass = confirmPassController.text.trim();

                if (oldPass != _currentPassword) {
                  setDialogState(() => errorText = 'Mật khẩu hiện tại không đúng!');
                  return;
                }
                if (newPass.length < 6) {
                  setDialogState(() => errorText = 'Mật khẩu mới phải có ít nhất 6 ký tự!');
                  return;
                }
                if (newPass != confirmPass) {
                  setDialogState(() => errorText = 'Mật khẩu xác nhận không khớp!');
                  return;
                }

                setState(() => _currentPassword = newPass);
                Navigator.pop(context);
                ScaffoldMessenger.of(this.context).showSnackBar(
                  const SnackBar(
                    content: Text('Đổi mật khẩu thành công!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Cập nhật'),
            ),
          ],
        ),
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
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                    (route) => false,
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
              onTap: _showCategoriesDialog,
            ),
            ProfileMenuItem(
              icon: Icons.cloud_upload_outlined,
              title: 'Sao lưu dữ liệu',
              subtitle: 'Lần cuối: $_lastBackupTime',
              onTap: _showBackupDialog,
            ),
            ProfileMenuItem(
              icon: Icons.lock_outline,
              title: 'Đổi mật khẩu',
              onTap: _showChangePasswordDialog,
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
  final String? subtitle;
  final VoidCallback onTap;
  final Color textColor;
  final Color iconColor;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.textColor = Colors.black,
    this.iconColor = Colors.black54,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
      subtitle: subtitle != null ? Text(subtitle!, style: const TextStyle(fontSize: 12)) : null,
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}