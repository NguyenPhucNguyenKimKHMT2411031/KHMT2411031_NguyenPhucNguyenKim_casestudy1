class Transaction {
  final int? id;
  final String title;
  final double amount;
  final String date;
  final String category;

  Transaction({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date,
      'category': category,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      title: map['title'],
      amount: map['amount'] is int ? (map['amount'] as int).toDouble() : map['amount'],
      date: map['date'],
      category: map['category'],
    );
  }
}