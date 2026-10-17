import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  bool isAll = true;
  bool isIncome = false;
  bool isExpense = false;
  String selectedTime = 'Hôm nay';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Bộ lọc', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lọc theo loại giao dịch
            const Text('Loại giao dịch', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            CheckboxListTile(
              title: const Text('Tất cả'),
              value: isAll,
              onChanged: (val) => setState(() => isAll = val!),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              title: const Text('Thu nhập'),
              value: isIncome,
              onChanged: (val) => setState(() => isIncome = val!),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              title: const Text('Chi tiêu'),
              value: isExpense,
              onChanged: (val) => setState(() => isExpense = val!),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const SizedBox(height: 12),

            // Lọc theo danh mục
            const Text('Danh mục', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: 'Tất cả danh mục',
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              items: const [
                DropdownMenuItem(value: 'Tất cả danh mục', child: Text('Tất cả danh mục')),
                DropdownMenuItem(value: 'Ăn uống', child: Text('Ăn uống')),
                DropdownMenuItem(value: 'Mua sắm', child: Text('Mua sắm')),
              ],
              onChanged: (val) {},
            ),
            const SizedBox(height: 16),

            // Lọc theo khoảng thời gian
            const Text('Khoảng thời gian', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            RadioListTile<String>(title: const Text('Hôm nay'), value: 'Hôm nay', groupValue: selectedTime, onChanged: (val) => setState(() => selectedTime = val!), contentPadding: EdgeInsets.zero),
            RadioListTile<String>(title: const Text('7 ngày qua'), value: '7 ngày qua', groupValue: selectedTime, onChanged: (val) => setState(() => selectedTime = val!), contentPadding: EdgeInsets.zero),
            RadioListTile<String>(title: const Text('Tháng này'), value: 'Tháng này', groupValue: selectedTime, onChanged: (val) => setState(() => selectedTime = val!), contentPadding: EdgeInsets.zero),
            RadioListTile<String>(title: const Text('Tùy chỉnh'), value: 'Tùy chỉnh', groupValue: selectedTime, onChanged: (val) => setState(() => selectedTime = val!), contentPadding: EdgeInsets.zero),
            const Spacer(),

            // Nút áp dụng
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
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