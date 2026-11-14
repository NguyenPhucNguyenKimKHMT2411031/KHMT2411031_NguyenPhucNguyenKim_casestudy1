import 'package:flutter/material.dart';
import 'models/transaction.dart';
import 'repositories/transaction_repository.dart';
import 'sua_giao_dich_screen.dart';
import 'filter_screen.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({super.key});

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  final TransactionRepository _repository = TransactionRepository();
  List<Transaction> _allTransactions = [];
  bool _isLoading = true;

  // Trạng thái bộ lọc tab: 'all', 'income', 'expense'
  String _selectedFilter = 'all';
  // Trạng thái tìm kiếm
  bool _isSearching = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  // Hàm định dạng số tiền có dấu chấm ngăn cách hàng nghìn
  String _formatCurrency(double amount) {
    String str = amount.toStringAsFixed(0);
    return str.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
    );
  }

  Future<void> _loadTransactions() async {
    setState(() => _isLoading = true);
    try {
      final list = await _repository.getTransactions();
      if (mounted) {
        setState(() {
          _allTransactions = list;
        });
      }
    } catch (e) {
      debugPrint("Lỗi tải danh sách: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Lọc danh sách theo Tab (Tất cả / Thu / Chi) và từ khóa tìm kiếm
  List<Transaction> get _filteredTransactions {
    return _allTransactions.where((item) {
      final matchesTab = _selectedFilter == 'all' || item.type == _selectedFilter;
      final matchesSearch = item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.category.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesTab && matchesSearch;
    }).toList();
  }

  // Chọn icon và màu sắc tương ứng theo danh mục
  IconData _getCategoryIcon(String category, bool isExpense) {
    switch (category.toLowerCase()) {
      case 'ăn uống':
        return Icons.restaurant;
      case 'mua sắm':
        return Icons.shopping_bag;
      case 'đi lại':
        return Icons.directions_car;
      case 'học tập':
      case 'hóa đơn':
        return Icons.school;
      case 'thu nhập':
      case 'lương':
        return Icons.account_balance_wallet;
      default:
        return isExpense ? Icons.arrow_upward : Icons.arrow_downward;
    }
  }

  Color _getCategoryColor(String category, bool isExpense) {
    switch (category.toLowerCase()) {
      case 'ăn uống':
        return Colors.orange;
      case 'mua sắm':
        return Colors.pink;
      case 'đi lại':
        return Colors.purple;
      case 'học tập':
      case 'hóa đơn':
        return Colors.blue;
      default:
        return isExpense ? Colors.red : Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayList = _filteredTransactions;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: _isSearching
            ? TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Tìm tên hoặc danh mục...',
            border: InputBorder.none,
          ),
          onChanged: (value) => setState(() => _searchQuery = value),
        )
            : const Text(
          'Giao dịch',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search, color: Colors.black),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) _searchQuery = '';
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onPressed: () {
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
          // 3 nút chuyển đổi bộ lọc: Tất cả / Thu nhập / Chi tiêu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                _buildFilterButton('Tất cả', 'all'),
                const SizedBox(width: 8),
                _buildFilterButton('Thu nhập', 'income'),
                const SizedBox(width: 8),
                _buildFilterButton('Chi tiêu', 'expense'),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : displayList.isEmpty
                ? const Center(
              child: Text(
                'Không có giao dịch nào phù hợp.',
                style: TextStyle(color: Colors.grey),
              ),
            )
                : RefreshIndicator(
              onRefresh: _loadTransactions,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: displayList.length,
                itemBuilder: (context, index) {
                  final item = displayList[index];
                  final isExpense = item.type == 'expense';
                  final iconColor = _getCategoryColor(item.category, isExpense);

                  return GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SuaGiaoDichScreen(transaction: item),
                        ),
                      );
                      if (result == true) _loadTransactions();
                    },
                    child: TransactionTile(
                      icon: _getCategoryIcon(item.category, isExpense),
                      iconBgColor: iconColor,
                      title: item.title,
                      subtitle: '${item.category} • ${item.date}',
                      amount: '${isExpense ? '-' : '+'}${_formatCurrency(item.amount)} đ',
                      isExpense: isExpense,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label, String filterValue) {
    final isSelected = _selectedFilter == filterValue;
    return Expanded(
      child: isSelected
          ? ElevatedButton(
        onPressed: () => setState(() => _selectedFilter = filterValue),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        child: Text(label, style: const TextStyle(color: Colors.white)),
      )
          : OutlinedButton(
        onPressed: () => setState(() => _selectedFilter = filterValue),
        child: Text(label, style: const TextStyle(color: Colors.black)),
      ),
    );
  }
}

class TransactionTile extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final String amount;
  final bool isExpense;

  const TransactionTile({
    super.key,
    required this.icon,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isExpense,
  });

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
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
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