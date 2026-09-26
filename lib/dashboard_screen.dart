import 'package:flutter/material.dart';


// THÊM ĐOẠN NÀY VÀO ĐẦU FILE
void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DashboardScreen(),
  ));
}





// Bên dưới là code class DashboardScreen...
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text(
          'Quản lý thu chi',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.black),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  child: const Text(
                    '3',
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildBalanceCard(),
            const SizedBox(height: 16),
            _buildSummaryCards(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Giao dịch gần đây', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                TextButton(onPressed: () {}, child: const Text('Xem tất cả', style: TextStyle(color: Colors.blue))),
              ],
            ),
            const SizedBox(height: 8),
            _buildTransactionList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.article_outlined), label: 'Giao dịch'),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart_outline), label: 'Thống kê'),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2B72FB), Color(0xFF0B46CD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Text('SỐ DƯ HIỆN TẠI', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                      SizedBox(width: 6),
                      Icon(Icons.visibility_outlined, color: Colors.white70, size: 16),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('5.000.000 đ', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                ],
              ),
              const Icon(Icons.account_balance_wallet, color: Colors.white, size: 56),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.white38, shape: BoxShape.circle)),
              const SizedBox(width: 4),
              Container(width: 16, height: 6, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(3))),
              const SizedBox(width: 4),
              Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.white38, shape: BoxShape.circle)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFEEF9F1), borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                CircleAvatar(backgroundColor: Colors.green.shade100, child: const Icon(Icons.arrow_downward, color: Colors.green)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('TỔNG THU NHẬP', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('8.000.000 đ', style: TextStyle(fontSize: 13, color: Colors.green, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFFDEEEE), borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                CircleAvatar(backgroundColor: Colors.red.shade100, child: const Icon(Icons.arrow_upward, color: Colors.red)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('TỔNG CHI TIÊU', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('3.000.000 đ', style: TextStyle(fontSize: 13, color: Colors.red, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionList() {
    final transactions = [
      {'title': 'Ăn trưa', 'category': 'Ăn uống', 'date': '03/09/2024', 'amount': '-50.000 đ', 'isIncome': false, 'icon': Icons.restaurant, 'color': Colors.orange},
      {'title': 'Xăng xe', 'category': 'Di chuyển', 'date': '03/09/2024', 'amount': '-100.000 đ', 'isIncome': false, 'icon': Icons.directions_car, 'color': Colors.blue},
      {'title': 'Lương tháng 9', 'category': 'Thu nhập', 'date': '01/09/2024', 'amount': '+8.000.000 đ', 'isIncome': true, 'icon': Icons.savings, 'color': Colors.green},
      {'title': 'Mua sắm', 'category': 'Mua sắm', 'date': '31/08/2024', 'amount': '-300.000 đ', 'isIncome': false, 'icon': Icons.shopping_cart, 'color': Colors.purple},
      {'title': 'Học phí', 'category': 'Giáo dục', 'date': '30/08/2024', 'amount': '-500.000 đ', 'isIncome': false, 'icon': Icons.school, 'color': Colors.teal},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final item = transactions[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: (item['color'] as Color).withOpacity(0.2),
              child: Icon(item['icon'] as IconData, color: item['color'] as Color),
            ),
            title: Text(item['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: Text('${item['category']}   ${item['date']}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            trailing: Text(
              item['amount'] as String,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: (item['isIncome'] as bool) ? Colors.green : Colors.red),
            ),
          ),
        );
      },
    );
  }
}