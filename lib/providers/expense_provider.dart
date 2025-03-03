import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/expense.dart';
import 'package:flutter/foundation.dart';

class ExpenseProvider extends ChangeNotifier {
  List<Expense> _expenses = [];
  double _dailyLimit = 200.0;

  List<Expense> get expenses => _expenses;
  double get dailyLimit => _dailyLimit;
  double get totalExpenses =>
      _expenses.fold(0, (sum, item) => sum + item.amount);
  double get spendingProgress =>
      (_dailyLimit > 0) ? (totalExpenses / _dailyLimit).clamp(0.0, 1.0) : 0.0;

  Future<void> loadExpenses() async {
    _expenses = await DBHelper.instance.getExpensesForToday();
    notifyListeners();
  }

  Future<void> addExpense(Expense expense) async {
    await DBHelper.instance.insertExpense(expense);
    await loadExpenses();
  }

  Future<void> deleteExpense(int id) async {
    await DBHelper.instance.deleteExpense(id);
    await loadExpenses();
  }

  Future<void> setDailyLimit(double limit) async {
    await DBHelper.instance.setDailyLimit(limit);
    _dailyLimit = limit;
    notifyListeners();
  }

  Future<void> loadDailyLimit() async {
    double limit = await DBHelper.instance.getDailyLimit();
    if (limit == 0) {
      print("Daily Limit is 0, setting default to 200");
      await setDailyLimit(200); // sets default if missing
    }
    _dailyLimit = limit;
    notifyListeners();
  }
}
