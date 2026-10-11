import 'dart:math';
import 'package:flutter/material.dart';
import 'models/transaction.dart';
import 'repositories/transaction_repository.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final TransactionRepository _repository = TransactionRepository();

  bool _isLoading = true;
  List<Transaction> _allExpenseTransactions = [];
  List<Transaction> _filteredTransactions = [];

  double _totalExpense = 0;
  Map<String, double> _categoryExpenses = {};

  int _selectedFilterIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadStatisticsData();
  }

  Future<void> _loadStatisticsData() async {
    setState(() => _isLoading = true);

    try {
      final allTransactions = await _repository.getTransactions();
      _allExpenseTransactions = allTransactions.where((t) => t.type == 'expense').toList();
      _applyTimeFilter(_selectedFilterIndex);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Lỗi tải thống kê: $e");
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _applyTimeFilter(int index) {
    setState(() {
      _selectedFilterIndex = index;
      final now = DateTime.now();

      _filteredTransactions = _allExpenseTransactions.where((t) {
        try {
          List<String> parts = t.date.split('/');
          if (parts.length == 3) {
            int day = int.parse(parts[0]);
            int month = int.parse(parts[1]);
            int year = int.parse(parts[2]);
            DateTime tDate = DateTime(year, month, day);

            if (index == 0) {
              return tDate.year == now.year && tDate.month == now.month;
            } else if (index == 1) {
              int targetMonth = now.month == 1 ? 12 : now.month - 1;
              int targetYear = now.month == 1 ? now.year - 1 : now.year;
              return tDate.year == targetYear && tDate.month == targetMonth;
            } else if (index == 2) {
              return tDate.year == now.year;
            }
          }
        } catch (_) {}
        return true;
      }).toList();

      double total = 0;
      Map<String, double> categoryMap = {};

      for (var item in _filteredTransactions) {
        total += item.amount;
        categoryMap[item.category] = (categoryMap[item.category] ?? 0) + item.amount;
      }

      _totalExpense = total;
      _categoryExpenses = categoryMap;
    });
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Ăn uống':
        return const Color(0xFFEF5350);
      case 'Hóa đơn':
        return const Color(0xFF42A5F5);
      case 'Mua sắm':
        return const Color(0xFFFFB74D);
      case 'Di chuyển':
        return const Color(0xFFAB47BC);
      case 'Học tập':
        return const Color(0xFF26A69A);
      default:
        return const Color(0xFF7E57C2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Thống kê', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildFilterButton('Tháng này', 0)),
                const SizedBox(width: 8),
                Expanded(child: _buildFilterButton('Tháng trước', 1)),
                const SizedBox(width: 8),
                Expanded(child: _buildFilterButton('Năm nay', 2)),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              height: 200,
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: CustomPaint(
                      painter: DonutChartPainter(
                        categoryExpenses: _categoryExpenses,
                        totalExpense: _totalExpense,
                        getColor: _getCategoryColor,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Tổng chi tiêu', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(
                        '${_totalExpense.toStringAsFixed(0)} đ',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _categoryExpenses.isEmpty
                ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0),
              child: Text('Không có dữ liệu chi tiêu trong khoảng thời gian này', style: TextStyle(color: Colors.grey)),
            )
                : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _categoryExpenses.keys.length,
              itemBuilder: (context, index) {
                String category = _categoryExpenses.keys.elementAt(index);
                double amount = _categoryExpenses[category]!;
                double percentage = _totalExpense > 0 ? (amount / _totalExpense) * 100 : 0;
                Color color = _getCategoryColor(category);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    children: [
                      Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(category, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                      ),
                      Text(
                        '${amount.toStringAsFixed(0)} đ',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 45,
                        child: Text(
                          '${percentage.toStringAsFixed(0)}%',
                          textAlign: TextAlign.end,
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String title, int index) {
    bool isSelected = _selectedFilterIndex == index;
    return OutlinedButton(
      onPressed: () => _applyTimeFilter(index),
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.white,
        side: BorderSide(color: isSelected ? Colors.blue : Colors.grey.shade300),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(
        title,
        style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontSize: 13),
      ),
    );
  }
}

class DonutChartPainter extends CustomPainter {
  final Map<String, double> categoryExpenses;
  final double totalExpense;
  final Color Function(String) getColor;

  DonutChartPainter({
    required this.categoryExpenses,
    required this.totalExpense,
    required this.getColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;

    if (totalExpense == 0 || categoryExpenses.isEmpty) {
      final defaultPaint = Paint()
        ..color = Colors.grey.shade300
        ..style = PaintingStyle.stroke
        ..strokeWidth = 22.0;
      canvas.drawCircle(center, radius, defaultPaint);
      return;
    }

    double startAngle = -pi / 2;

    categoryExpenses.forEach((category, amount) {
      final sweepAngle = (amount / totalExpense) * 2 * pi;
      final paint = Paint()
        ..color = getColor(category)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 22.0
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}