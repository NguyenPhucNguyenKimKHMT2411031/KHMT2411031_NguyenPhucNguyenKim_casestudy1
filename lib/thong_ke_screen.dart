import 'package:flutter/material.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống kê', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Nút chọn thời gian thống kê
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      child: const Text('Tháng này', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text('Tháng trước', style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text('Năm nay', style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Biểu đồ tròn trực quan thể hiện tổng chi tiêu
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 180,
                    width: 180,
                    child: CircularProgressIndicator(
                      value: 0.7,
                      strokeWidth: 26,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                      backgroundColor: Colors.blue.shade100,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('Tổng chi tiêu', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      SizedBox(height: 4),
                      Text('5.000.000 đ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Danh sách chi tiết các danh mục cấu thành
              const CategoryStatTile(color: Colors.red, title: 'Ăn uống', amount: '2.000.000 đ', percent: '40%'),
              const CategoryStatTile(color: Colors.orange, title: 'Mua sắm', amount: '1.500.000 đ', percent: '30%'),
              const CategoryStatTile(color: Colors.purple, title: 'Đi lại', amount: '700.000 đ', percent: '14%'),
              const CategoryStatTile(color: Colors.blue, title: 'Học tập', amount: '500.000 đ', percent: '10%'),
              const CategoryStatTile(color: Colors.indigo, title: 'Khác', amount: '300.000 đ', percent: '6%'),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryStatTile extends StatelessWidget {
  final Color color;
  final String title;
  final String amount;
  final String percent;

  const CategoryStatTile({
    Key? key,
    required this.color,
    required this.title,
    required this.amount,
    required this.percent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
          const Spacer(),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(width: 16),
          SizedBox(width: 35, child: Text(percent, textAlign: TextAlign.right, style: const TextStyle(color: Colors.grey))),
        ],
      ),
    );
  }
}