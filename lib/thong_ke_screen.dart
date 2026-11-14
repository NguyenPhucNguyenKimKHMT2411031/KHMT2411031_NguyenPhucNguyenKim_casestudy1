import 'dart:math';
import 'package:flutter/material.dart';
import 'models/transaction.dart';
import 'repositories/transaction_repository.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final TransactionRepository _repository = TransactionRepository();
  List<Transaction> _allTransactions = [];
  bool _isLoading = true;
  String _selectedPeriod = 'Tất cả';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  String _formatCurrency(double amount) {
    String str = amount.toStringAsFixed(0);
    return str.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
    );
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final list = await _repository.getTransactions();
      if (mounted) {
        setState(() {
          _allTransactions = list;
        });
      }
    } catch (e) {
      debugPrint("Lỗi tải thống kê: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Lọc các khoản chi tiêu theo khoảng thời gian đang chọn
  List<Transaction> get _filteredExpenses {
    final now = DateTime.now();
    return _allTransactions.where((item) {
      if (item.type != 'expense') return false;
      if (_selectedPeriod == 'Tất cả') return true;

      // Parse chuỗi ngày dd/MM/yyyy
      final parts = item.date.split('/');
      if (parts.length != 3) return true;
      final month = int.tryParse(parts[1]) ?? now.month;
      final year = int.tryParse(parts[2]) ?? now.year;

      if (_selectedPeriod == 'Tháng này') {
        return month == now.month && year == now.year;
      } else if (_selectedPeriod == 'Tháng trước') {
        final prevMonth = now.month == 1 ? 12 : now.month - 1;
        final prevYear = now.month == 1 ? now.year - 1 : now.year;
        return month == prevMonth && year == prevYear;
      }
      return true;
    }).toList();
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'ăn uống':
        return Colors.red;
      case 'mua sắm':
        return Colors.orange;
      case 'di chuyển':
      case 'đi lại':
        return Colors.purple;
      case 'hóa đơn':
      case 'học tập':
        return Colors.blue;
      case 'giải trí':
        return Colors.teal;
      default:
        return Colors.indigo;
    }
  }

  @override
  Widget build(BuildContext context) {
    final expenses = _filteredExpenses;
    final double totalExpense = expenses.fold(0, (sum, t) => sum + t.amount);

    // Gom nhóm tổng tiền theo từng danh mục
    final Map<String, double> categoryTotals = {};
    for (var item in expenses) {
      categoryTotals[item.category] = (categoryTotals[item.category] ?? 0) + item.amount;
    }

    // Sắp xếp danh mục từ chi nhiều nhất đến ít nhất
    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Thống kê', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 3 nút chọn khoảng thời gian thống kê
              Row(
                children: [
                  _buildPeriodButton('Tất cả'),
                  const SizedBox(width: 8),
                  _buildPeriodButton('Tháng này'),
                  const SizedBox(width: 8),
                  _buildPeriodButton('Tháng trước'),
                ],
              ),
              const SizedBox(height: 30),

              // Biểu đồ vòng tròn đa sắc theo tỷ lệ từng danh mục
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 190,
                    width: 190,
                    child: CustomPaint(
                      painter: _DonutChartPainter(
                        categories: sortedCategories,
                        total: totalExpense,
                        colorMapper: _getCategoryColor,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Tổng chi tiêu', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text(
                        '${_formatCurrency(totalExpense)} đ',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Danh sách chi tiết các danh mục cấu thành
              if (sortedCategories.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'Chưa có dữ liệu chi tiêu trong khoảng thời gian này.',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              else
                ...sortedCategories.map((entry) {
                  final percent = totalExpense > 0 ? (entry.value / totalExpense * 100) : 0;
                  return CategoryStatTile(
                    color: _getCategoryColor(entry.key),
                    title: entry.key,
                    amount: '${_formatCurrency(entry.value)} đ',
                    percent: '${percent.toStringAsFixed(0)}%',
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodButton(String label) {
    final isSelected = _selectedPeriod == label;
    return Expanded(
      child: isSelected
          ? ElevatedButton(
        onPressed: () => setState(() => _selectedPeriod = label),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
      )
          : OutlinedButton(
        onPressed: () => setState(() => _selectedPeriod = label),
        child: Text(label, style: const TextStyle(color: Colors.black, fontSize: 13)),
      ),
    );
  }
}

// Vẽ biểu đồ Donut chart từ dữ liệu thực tế
class _DonutChartPainter extends CustomPainter {
  final List<MapEntry<String, double>> categories;
  final double total;
  final Color Function(String) colorMapper;

  _DonutChartPainter({
    required this.categories,
    required this.total,
    required this.colorMapper,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 14;
    const strokeWidth = 26.0;

    final bgPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    if (total <= 0 || categories.isEmpty) {
      canvas.drawCircle(center, radius, bgPaint);
      return;
    }

    double startAngle = -pi / 2;
    for (var entry in categories) {
      final sweepAngle = (entry.value / total) * 2 * pi;
      final paint = Paint()
        ..color = colorMapper(entry.key)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class CategoryStatTile extends StatelessWidget {
  final Color color;
  final String title;
  final String amount;
  final String percent;

  const CategoryStatTile({
    super.key,
    required this.color,
    required this.title,
    required this.amount,
    required this.percent,
  });

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
          SizedBox(
            width: 40,
            child: Text(percent, textAlign: TextAlign.right, style: const TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}