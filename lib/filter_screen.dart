import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  final String initialType;
  final String initialCategory;
  final String initialTime;

  const FilterScreen({
    super.key,
    this.initialType = 'all',
    this.initialCategory = 'Tất cả danh mục',
    this.initialTime = 'Tất cả thời gian',
  });

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late String _selectedType;
  late String _selectedCategory;
  late String _selectedTime;

  final List<String> _categories = [
    'Tất cả danh mục',
    'Ăn uống',
    'Mua sắm',
    'Đi lại',
    'Học tập',
    'Hóa đơn',
    'Thu nhập',
  ];

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType;
    _selectedCategory = _categories.contains(widget.initialCategory)
        ? widget.initialCategory
        : 'Tất cả danh mục';
    _selectedTime = widget.initialTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Bộ lọc', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedType = 'all';
                _selectedCategory = 'Tất cả danh mục';
                _selectedTime = 'Tất cả thời gian';
              });
            },
            child: const Text('Đặt lại', style: TextStyle(color: Colors.red)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Lọc theo loại giao dịch (dùng Radio để tránh chọn trùng mâu thuẫn)
            const Text('Loại giao dịch', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            RadioListTile<String>(
              title: const Text('Tất cả'),
              value: 'all',
              groupValue: _selectedType,
              onChanged: (val) => setState(() => _selectedType = val!),
              contentPadding: EdgeInsets.zero,
            ),
            RadioListTile<String>(
              title: const Text('Thu nhập'),
              value: 'income',
              groupValue: _selectedType,
              onChanged: (val) => setState(() => _selectedType = val!),
              contentPadding: EdgeInsets.zero,
            ),
            RadioListTile<String>(
              title: const Text('Chi tiêu'),
              value: 'expense',
              groupValue: _selectedType,
              onChanged: (val) => setState(() => _selectedType = val!),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 12),

            // 2. Lọc theo danh mục
            const Text('Danh mục', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              items: _categories
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedCategory = val);
              },
            ),
            const SizedBox(height: 16),

            // 3. Lọc theo khoảng thời gian
            const Text('Khoảng thời gian', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            RadioListTile<String>(
              title: const Text('Tất cả thời gian'),
              value: 'Tất cả thời gian',
              groupValue: _selectedTime,
              onChanged: (val) => setState(() => _selectedTime = val!),
              contentPadding: EdgeInsets.zero,
            ),
            RadioListTile<String>(
              title: const Text('Hôm nay'),
              value: 'Hôm nay',
              groupValue: _selectedTime,
              onChanged: (val) => setState(() => _selectedTime = val!),
              contentPadding: EdgeInsets.zero,
            ),
            RadioListTile<String>(
              title: const Text('7 ngày qua'),
              value: '7 ngày qua',
              groupValue: _selectedTime,
              onChanged: (val) => setState(() => _selectedTime = val!),
              contentPadding: EdgeInsets.zero,
            ),
            RadioListTile<String>(
              title: const Text('Tháng này'),
              value: 'Tháng này',
              groupValue: _selectedTime,
              onChanged: (val) => setState(() => _selectedTime = val!),
              contentPadding: EdgeInsets.zero,
            ),
            const Spacer(),

            // Nút áp dụng: Trả dữ liệu bộ lọc về màn hình trước
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'type': _selectedType,
                    'category': _selectedCategory,
                    'time': _selectedTime,
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Áp dụng', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}