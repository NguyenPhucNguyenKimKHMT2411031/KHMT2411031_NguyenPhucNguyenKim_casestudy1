import 'package:flutter/material.dart';
import 'models/transaction.dart';
import 'repositories/transaction_repository.dart';

class SuaGiaoDichScreen extends StatefulWidget {
  final Transaction transaction;

  const SuaGiaoDichScreen({super.key, required this.transaction});

  @override
  State<SuaGiaoDichScreen> createState() => _SuaGiaoDichScreenState();
}

class _SuaGiaoDichScreenState extends State<SuaGiaoDichScreen> {
  final TransactionRepository _repository = TransactionRepository();

  late bool isExpense;
  final List<String> categories = ['Ăn uống', 'Mua sắm', 'Di chuyển', 'Giải trí', 'Hóa đơn', 'Thu nhập'];
  late String selectedCategory;

  late TextEditingController amountController;
  late TextEditingController dateController;
  late TextEditingController noteController;

  @override
  void initState() {
    super.initState();
    // Ưu tiên kiểm tra thuộc tính type
    isExpense = widget.transaction.type == 'expense' ||
        (widget.transaction.type.isEmpty && widget.transaction.category != 'Thu nhập');

    selectedCategory = categories.contains(widget.transaction.category)
        ? widget.transaction.category
        : categories.first;

    amountController = TextEditingController(text: widget.transaction.amount.toStringAsFixed(0));
    dateController = TextEditingController(text: widget.transaction.date);
    noteController = TextEditingController(text: widget.transaction.title);
  }

  @override
  void dispose() {
    amountController.dispose();
    dateController.dispose();
    noteController.dispose();
    super.dispose();
  }

  // 1. Cập nhật giao dịch có try-catch bắt lỗi
  Future<void> _updateTransaction() async {
    final titleText = noteController.text.trim();
    final amountText = amountController.text.trim();

    if (titleText.isEmpty || amountText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin!')),
      );
      return;
    }

    final double? parsedAmount = double.tryParse(amountText.replaceAll('.', '').replaceAll(',', ''));
    if (parsedAmount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Số tiền nhập vào không hợp lệ!')),
      );
      return;
    }

    final updatedTransaction = Transaction(
      id: widget.transaction.id,
      title: titleText,
      amount: parsedAmount,
      date: dateController.text,
      category: isExpense ? selectedCategory : 'Thu nhập',
      type: isExpense ? 'expense' : 'income',
    );

    try {
      if (widget.transaction.id != null) {
        await _repository.updateTransaction(updatedTransaction);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cập nhật giao dịch thành công!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true); // Trả về true để làm mới Dashboard
        }
      }
    } catch (e) {
      debugPrint("Lỗi cập nhật giao dịch: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi cập nhật: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // 2. Xóa giao dịch có try-catch bắt lỗi
  Future<void> _deleteTransaction() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa giao dịch này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true && widget.transaction.id != null) {
      try {
        await _repository.deleteTransaction(widget.transaction.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đã xóa giao dịch!'),
              backgroundColor: Colors.orange,
            ),
          );
          Navigator.pop(context, true); // Trả về true để làm mới Dashboard
        }
      } catch (e) {
        debugPrint("Lỗi xóa giao dịch: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi khi xóa: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Sửa giao dịch',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: _deleteTransaction,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            children: [
              // Segmented Control Chi tiêu / Thu nhập
              Container(
                height: 45,
                decoration: BoxDecoration(color: const Color(0xFFEFEFEF), borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isExpense = true),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isExpense ? const Color(0xFFFF4D4D) : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text('Chi tiêu', style: TextStyle(color: isExpense ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isExpense = false),
                        child: Container(
                          decoration: BoxDecoration(
                            color: !isExpense ? const Color(0xFF2ECC71) : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text('Thu nhập', style: TextStyle(color: !isExpense ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Danh mục
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Danh mục',
                  prefixIcon: const Icon(Icons.restaurant_menu, color: Colors.redAccent),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                items: categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                onChanged: (val) => setState(() => selectedCategory = val!),
              ),
              const SizedBox(height: 16),

              // Số tiền
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Số tiền',
                  suffixText: 'đ',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),

              // Ngày giao dịch
              TextField(
                controller: dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Ngày giao dịch',
                  suffixIcon: const Icon(Icons.calendar_today_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      dateController.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              // Ghi chú
              TextField(
                controller: noteController,
                decoration: InputDecoration(
                  labelText: 'Ghi chú',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),

              const Spacer(),

              // Nút Lưu cập nhật
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _updateTransaction,
                  child: const Text('Lưu thay đổi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}