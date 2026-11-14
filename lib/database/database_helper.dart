import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    // Đảm bảo thống nhất tên file database trên toàn bộ app
    final path = join(databasePath, 'expense.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Khởi tạo bảng dữ liệu mới
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        category TEXT NOT NULL,
        type TEXT NOT NULL
      )
    ''');
  }

  // Nâng cấp bảng cho các máy đã chạy version 1
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute("ALTER TABLE transactions ADD COLUMN type TEXT NOT NULL DEFAULT 'expense'");
    }
  }

  // 1. Thêm khoản chi/thu mới
  Future<int> insertTransaction(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('transactions', data);
  }

  // 2. Lấy danh sách giao dịch (mới nhất xếp trên)
  Future<List<Map<String, dynamic>>> getTransactions() async {
    final db = await database;
    return await db.query('transactions', orderBy: 'id DESC');
  }

  // 3. Cập nhật giao dịch
  Future<int> updateTransaction(int id, Map<String, dynamic> data) async {
    final db = await database;
    return await db.update(
      'transactions',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 4. Xóa giao dịch
  Future<int> deleteTransaction(int id) async {
    final db = await database;
    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 5. Hàm xóa toàn bộ cơ sở dữ liệu (Dùng khi debug/reset app)
  Future<void> clearDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'expense.db');
    await deleteDatabase(path);
    _database = null;
  }
}