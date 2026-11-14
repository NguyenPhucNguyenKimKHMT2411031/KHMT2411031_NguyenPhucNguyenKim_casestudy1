import 'package:flutter/material.dart';
import 'models/transaction.dart';
import 'repositories/transaction_repository.dart';
import 'them_giao_dich_screen.dart';
import 'sua_giao_dich_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TransactionRepository _repository = TransactionRepository();

  int _selectedIndex = 0;
  List<Transaction> _transactions = [];
  bool _isLoading = true;

  double _totalIncome = 0;
  double _totalExpense = 0;
  double _balance = 0;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  // Tải danh sách giao dịch từ Repository và tính toán số dư
  Future<void> _loadTransactions() async {
    setState(() => _isLoading = true);

    try {
      // Đọc danh sách Transaction từ Repository
      final loadedList = await _repository.getTransactions();

      // Tính tổng thu, tổng chi dựa trên thuộc tính 'type'
      double income = loadedList
          .where((t) => t.type == 'income')
          .fold(0, (sum, t) => sum + t.amount);

      double expense = loadedList
          .where((t) => t.type == 'expense')
          .fold(0, (sum, t) => sum + t.amount);

      if (mounted) {
        setState(() {
          _transactions = loadedList;
          _totalIncome = income;
          _totalExpense = expense;
          _balance = income - expense;
        });
      }
    } catch (e) {
      debugPrint("Lỗi tải dữ liệu SQLite: $e");
    } finally {
      // Luôn luôn tắt vòng xoay tải dữ liệu kể cả khi xảy ra lỗi
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Điều hướng màn hình và reload dữ liệu nếu có thay đổi
  Future<void> _navigateTo(Widget screen) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
    if (result == true) {
      _loadTransactions();
    }
  }

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
        centerTitle: true,
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _loadTransactions,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateTo(const AddTransactionScreen()),
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
                  Text(
                    '${_balance.toStringAsFixed(0)} đ',
                    style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                  ),
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
                    children: [
                      const Text('TỔNG THU NHẬP', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(
                        '${_totalIncome.toStringAsFixed(0)} đ',
                        style: const TextStyle(fontSize: 13, color: Colors.green, fontWeight: FontWeight.bold),
                      ),
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
                    children: [
                      const Text('TỔNG CHI TIÊU', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(
                        '${_totalExpense.toStringAsFixed(0)} đ',
                        style: const TextStyle(fontSize: 13, color: Colors.red, fontWeight: FontWeight.bold),
                      ),
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
    if (_transactions.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 32),
        alignment: Alignment.center,
        child: const Text(
          'Chưa có giao dịch nào!\nBấm nút (+) để thêm giao dịch mới.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _transactions.length,
      itemBuilder: (context, index) {
        final item = _transactions[index];
        final isIncome = item.type == 'income';

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            onTap: () => _navigateTo(SuaGiaoDichScreen(transaction: item)),
            leading: CircleAvatar(
              backgroundColor: isIncome ? Colors.green.shade100 : Colors.red.shade100,
              child: Icon(
                isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                color: isIncome ? Colors.green : Colors.red,
              ),
            ),
            title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: Text('${item.category}   ${item.date}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            trailing: Text(
              '${isIncome ? '+' : '-'}${item.amount.toStringAsFixed(0)} đ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isIncome ? Colors.green : Colors.red,
              ),
            ),
          ),
        );
      },
    );
  }
}