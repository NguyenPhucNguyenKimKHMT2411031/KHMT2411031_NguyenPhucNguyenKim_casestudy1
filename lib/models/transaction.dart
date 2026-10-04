class Transaction {
  final int? id;
  final String title;
  final double amount;
  final String date;
  final String category;
  final String type; // Thêm thuộc tính này ('income' hoặc 'expense')

  Transaction({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.type, // Thêm vào constructor
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'amount': amount,
      'date': date,
      'category': category,
      'type': type, // Thêm vào toMap
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as int?,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      date: map['date'] as String,
      category: map['category'] as String,
      type: map['type'] as String, // Thêm vào fromMap
    );
  }
}