import 'package:flutter/material.dart';
import 'models/transaction.dart';
import 'repositories/transaction_repository.dart';
import 'filter_screen.dart';
import 'sua_giao_dich_screen.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({Key? key}) : super(key: key);

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  final TransactionRepository _repository = TransactionRepository();
  List<Transaction> _allTransactions = [];
  bool _isLoading = true;

  // Biến lưu trạng thái lọc: 'all', 'income', 'expense'
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final transactions = await _repository.getTransactions();
      if (mounted) {
        setState(() {
          _allTransactions = transactions;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _navigateToEdit(Transaction transaction) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SuaGiaoDichScreen(transaction: transaction),
      ),
    );
    if (result == true) {
      _loadData(); // Tải lại danh sách sau khi sửa hoặc xóa
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Ăn uống': return Icons.restaurant;
      case 'Mua sắm': return Icons.shopping_bag;
      case 'Di chuyển': return Icons.directions_car;
      case 'Giải trí': return Icons.sports_esports;
      case 'Hóa đơn': return Icons.receipt;
      case 'Thu nhập': return Icons.work;
      default: return Icons.category;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Ăn uống': return Colors.pink;
      case 'Mua sắm': return Colors.cyan;
      case 'Di chuyển': return Colors.deepPurple;
      case 'Giải trí': return Colors.orange;
      case 'Hóa đơn': return Colors.redAccent;
      case 'Thu nhập': return Colors.green;
      default: return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Lọc danh sách dựa trên nút được chọn
    List<Transaction> filteredList = _allTransactions;
    if (_selectedFilter == 'income') {
      filteredList = _allTransactions.where((t) => t.type == 'income').toList();
    } else if (_selectedFilter == 'expense') {
      filteredList = _allTransactions.where((t) => t.type == 'expense').toList();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Giao dịch', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
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
          // 1. Thanh tìm kiếm
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm giao dịch...',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 2. Các nút bộ lọc nhanh có gắn sự kiện chuyển đổi trạng thái
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: _selectedFilter == 'all'
                      ? ElevatedButton(
                    onPressed: () => setState(() => _selectedFilter = 'all'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Tất cả', style: TextStyle(color: Colors.white)),
                  )
                      : OutlinedButton(
                    onPressed: () => setState(() => _selectedFilter = 'all'),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Tất cả', style: TextStyle(color: Colors.black54)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _selectedFilter == 'income'
                      ? ElevatedButton(
                    onPressed: () => setState(() => _selectedFilter = 'income'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Thu nhập', style: TextStyle(color: Colors.white)),
                  )
                      : OutlinedButton(
                    onPressed: () => setState(() => _selectedFilter = 'income'),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Thu nhập', style: TextStyle(color: Colors.black54)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _selectedFilter == 'expense'
                      ? ElevatedButton(
                    onPressed: () => setState(() => _selectedFilter = 'expense'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Chi tiêu', style: TextStyle(color: Colors.white)),
                  )
                      : OutlinedButton(
                    onPressed: () => setState(() => _selectedFilter = 'expense'),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Chi tiêu', style: TextStyle(color: Colors.black54)),
                  ),
                ),
              ],
            ),
          ),

          // 3. Danh sách giao dịch hiển thị theo bộ lọc
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredList.isEmpty
                ? const Center(
              child: Text(
                'Không có giao dịch nào phù hợp.',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final item = filteredList[index];
                final isIncome = item.type == 'income';
                final categoryColor = _getCategoryColor(item.category);

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  elevation: 0,
                  color: Colors.grey[50],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    onTap: () => _navigateToEdit(item),
                    leading: CircleAvatar(
                      backgroundColor: categoryColor.withOpacity(0.15),
                      child: Icon(_getCategoryIcon(item.category), color: categoryColor),
                    ),
                    title: Text(
                      item.title.isNotEmpty ? item.title : item.category,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    subtitle: Text(
                      '${item.category} • ${item.date}',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${isIncome ? '+' : '-'}${item.amount.toStringAsFixed(0)} đ',
                          style: TextStyle(
                            color: isIncome ? Colors.green[700] : Colors.red[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}