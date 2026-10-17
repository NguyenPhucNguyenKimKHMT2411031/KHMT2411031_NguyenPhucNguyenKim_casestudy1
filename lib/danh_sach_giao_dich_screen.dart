import 'package:flutter/material.dart';
import 'filter_screen.dart';
// Đảm bảo bạn đã có file filter_screen.dart trong thư mục lib

class TransactionListScreen extends StatelessWidget {
  // Đã sửa lại constructor để tránh lỗi const/super cũ
  TransactionListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giao dịch', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onPressed: () {
              // Chuyển hướng sang màn hình Lọc dữ liệu
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FilterScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text('Tất cả', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('Thu nhập', style: TextStyle(color: Colors.black)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('Chi tiêu', style: TextStyle(color: Colors.black)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: const [
                TransactionTile(icon: Icons.restaurant, iconBgColor: Colors.orange, title: 'Ăn uống', date: '12/04/2025', amount: '-100.000 đ', isExpense: true),
                TransactionTile(icon: Icons.shopping_bag, iconBgColor: Colors.pink, title: 'Mua sắm', date: '11/04/2025', amount: '-500.000 đ', isExpense: true),
                TransactionTile(icon: Icons.account_balance_wallet, iconBgColor: Colors.green, title: 'Lương', date: '10/04/2025', amount: '+10.000.000 đ', isExpense: false),
                TransactionTile(icon: Icons.directions_car, iconBgColor: Colors.purple, title: 'Đi lại', date: '09/04/2025', amount: '-200.000 đ', isExpense: true),
                TransactionTile(icon: Icons.school, iconBgColor: Colors.blue, title: 'Học tập', date: '07/04/2025', amount: '-300.000 đ', isExpense: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionTile extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final String title;
  final String date;
  final String amount;
  final bool isExpense;

  const TransactionTile({
    Key? key,
    required this.icon,
    required this.iconBgColor,
    required this.title,
    required this.date,
    required this.amount,
    required this.isExpense,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconBgColor.withOpacity(0.15),
          child: Icon(icon, color: iconBgColor),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        trailing: Text(
          amount,
          style: TextStyle(
            color: isExpense ? Colors.red : Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}