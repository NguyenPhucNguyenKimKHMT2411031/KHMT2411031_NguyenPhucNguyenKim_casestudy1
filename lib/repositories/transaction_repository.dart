import '../database/database_helper.dart';
import '../models/transaction.dart';

class TransactionRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Transaction>> getTransactions() async {
    final List<Map<String, dynamic>> maps = await _dbHelper.getTransactions();
    return List.generate(maps.length, (i) {
      return Transaction.fromMap(maps[i]);
    });
  }

  Future<int> insertTransaction(Transaction transaction) async {
    return await _dbHelper.insertTransaction(transaction.toMap());
  }

  Future<int> updateTransaction(Transaction transaction) async {
    return await _dbHelper.updateTransaction(transaction.id!, transaction.toMap());
  }

  Future<int> deleteTransaction(int id) async {
    return await _dbHelper.deleteTransaction(id);
  }
}