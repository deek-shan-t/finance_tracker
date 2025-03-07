import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/expense.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;
  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'expenses.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE expenses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            amount REAL,
            category TEXT,
            note TEXT,
            date TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE settings (
            id INTEGER PRIMARY KEY,
            dailyLimit REAL
          )
        ''');
        await db.insert('settings', {
          'id': 1,
          'dailyLimit': 200,
        }); // Default daily limit
      },
    );
  }

   Future<int> insertExpense(Expense expense) async {
    final db = await database;
    return await db.insert('expenses', expense.toJson());
  }

  Future<List<Expense>> getExpensesForToday() async {
    final db = await database;
    String today = DateTime.now().toIso8601String().substring(0, 10);
    final result = await db.query(
      'expenses',
      where: "date LIKE ?",
      whereArgs: ['$today%'],
    );
    return result.map((map) => Expense.fromJson(map)).toList();
  }

  Future<int> deleteExpense(int id) async {
    final db = await database;
    return await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  Future<double> getTotalExpensesForToday() async {
    final db = await database;
    String today = DateTime.now().toIso8601String().substring(0, 10);
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM expenses WHERE date LIKE ?',
      ['$today%'],
    );
    return (result.first['total'] as double?) ?? 0.0;
  }

  Future<double> getDailyLimit() async {
    final db = await database;
    final result = await db.query('settings', columns: ['dailyLimit']);
    return (result.first['dailyLimit'] as double?) ?? 0.0;
  }

  Future<void> setDailyLimit(double limit) async {
    final db = await database;
    await db.update(
      'settings',
      {'dailyLimit': limit},
      where: 'id = ?',
      whereArgs: [1],
    );
  }
}

