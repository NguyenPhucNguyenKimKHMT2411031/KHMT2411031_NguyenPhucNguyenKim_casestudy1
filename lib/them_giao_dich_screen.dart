import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      home: const AddTransactionScreen(),
    );
  }
}

// ==========================================
// 1. MÀN HÌNH THÊM GIAO DỊCH (Add Screen)
// ==========================================
class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  bool isExpense = true; // true: Chi tiêu, false: Thu nhập
  final List<String> categories = ['Ăn uống', 'Mua sắm', 'Di chuyển', 'Giải trí', 'Hóa đơn'];
  String selectedCategory = 'Ăn uống';

  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController(text: '12/04/2025');
  final TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {},
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
              // Segmented Switch (Chi tiêu / Thu nhập)
              _buildTypeSelector(),
              const SizedBox(height: 24),

              // Dropdown Danh mục
              _buildCategoryDropdown(),
              const SizedBox(height: 16),

              // Ô Số tiền
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

              // Ô Ngày giao dịch
              _buildDatePicker(context),
              const SizedBox(height: 16),

              // Ô Ghi chú
              TextField(
                controller: noteController,
                decoration: InputDecoration(
                  labelText: 'Ghi chú',
                  hintText: 'Nhập chi tiết giao dịch...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),

              const Spacer(),

              // Nút Lưu (Thêm giao dịch)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    // Sau khi thêm xong, chuyển sang Màn hình Sửa để xem/test thử
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditTransactionScreen(
                          initialCategory: 'Ăn uống',
                          initialAmount: '100.000',
                          initialDate: '12/04/2025',
                          initialNote: 'Ăn trưa',
                          isExpenseInit: true,
                        ),
                      ),
                    );
                  },
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
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedCategory,
      decoration: InputDecoration(
        labelText: 'Danh mục',
        prefixIcon: const Icon(Icons.restaurant_menu, color: Colors.redAccent),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      items: categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
      onChanged: (val) => setState(() => selectedCategory = val!),
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

// ==========================================
// 2. MÀN HÌNH SỬA GIAO DỊCH (Edit Screen)
// ==========================================
class EditTransactionScreen extends StatefulWidget {
  final String initialCategory;
  final String initialAmount;
  final String initialDate;
  final String initialNote;
  final bool isExpenseInit;

  const EditTransactionScreen({
    super.key,
    required this.initialCategory,
    required this.initialAmount,
    required this.initialDate,
    required this.initialNote,
    required this.isExpenseInit,
  });

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  late bool isExpense;
  final List<String> categories = ['Ăn uống', 'Mua sắm', 'Di chuyển', 'Giải trí', 'Hóa đơn'];
  late String selectedCategory;

  late TextEditingController amountController;
  late TextEditingController dateController;
  late TextEditingController noteController;

  @override
  void initState() {
    super.initState();
    // Nhận dữ liệu cũ để hiển thị lên form sửa
    isExpense = widget.isExpenseInit;
    selectedCategory = widget.initialCategory;
    amountController = TextEditingController(text: widget.initialAmount);
    dateController = TextEditingController(text: widget.initialDate);
    noteController = TextEditingController(text: widget.initialNote);
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
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            children: [
              // Segmented Switch
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

              // Dropdown Danh mục
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

              // Nút Cập nhật (Sửa giao dịch)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cập nhật giao dịch thành công!')),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Lưu', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}