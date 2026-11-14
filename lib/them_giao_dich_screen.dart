import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/transaction.dart';
import 'repositories/transaction_repository.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final TransactionRepository _repository = TransactionRepository();

  bool isExpense = true;
  final List<String> categories = ['Ăn uống', 'Mua sắm', 'Di chuyển', 'Giải trí', 'Hóa đơn', 'Thu nhập'];
  String selectedCategory = 'Ăn uống';

  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController(
    text: "${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year}",
  );
  final TextEditingController noteController = TextEditingController();

  @override
  void dispose() {
    amountController.dispose();
    dateController.dispose();
    noteController.dispose();
    super.dispose();
  }

  Future<void> _saveTransaction() async {
    final titleText = noteController.text.trim();
    final amountText = amountController.text.trim();

    if (titleText.isEmpty || amountText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin số tiền và ghi chú!')),
      );
      return;
    }

    final double? parsedAmount = double.tryParse(amountText.replaceAll('.', '').replaceAll(',', ''));
    if (parsedAmount == null || parsedAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Số tiền nhập vào không hợp lệ!')),
      );
      return;
    }

    final newTransaction = Transaction(
      title: titleText,
      amount: parsedAmount,
      date: dateController.text,
      category: isExpense ? selectedCategory : 'Thu nhập',
      type: isExpense ? 'expense' : 'income',
    );

    try {
      await _repository.insertTransaction(newTransaction);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã thêm giao dịch thành công!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi thêm giao dịch: $e'),
            backgroundColor: Colors.red,
          ),
        );
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
          'Thêm giao dịch',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildTypeSelector(),
                      const SizedBox(height: 24),
                      _buildCategoryDropdown(),
                      const SizedBox(height: 16),
                      TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          _ThousandsSeparatorInputFormatter(),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Số tiền',
                          suffixText: 'đ',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDatePicker(context),
                      const SizedBox(height: 16),
                      TextField(
                        controller: noteController,
                        decoration: InputDecoration(
                          labelText: 'Ghi chú',
                          hintText: 'Nhập chi tiết giao dịch (VD: Ăn trưa)...',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _saveTransaction,
                  child: const Text('Lưu', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Container(
      height: 45,
      decoration: BoxDecoration(color: const Color(0xFFEFEFEF), borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isExpense = true;
                  selectedCategory = 'Ăn uống';
                });
              },
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
              onTap: () {
                setState(() {
                  isExpense = false;
                  selectedCategory = 'Thu nhập';
                });
              },
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
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: isExpense ? selectedCategory : 'Thu nhập',
      decoration: InputDecoration(
        labelText: 'Danh mục',
        prefixIcon: const Icon(Icons.category_outlined, color: Colors.redAccent),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      items: (isExpense ? categories.where((cat) => cat != 'Thu nhập').toList() : ['Thu nhập'])
          .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
          .toList(),
      onChanged: isExpense ? (val) => setState(() => selectedCategory = val!) : null,
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return TextField(
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
    );
  }
}

// Bộ định dạng tự động chèn dấu chấm khi gõ số tiền
class _ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;
    final digitsOnly = newValue.text.replaceAll('.', '');
    final formatted = digitsOnly.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
    );
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}