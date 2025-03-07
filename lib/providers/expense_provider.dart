import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/expense.dart';
import '../database/db_helper.dart';

class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = [];
  double _dailyLimit = 0;
  double _weeklyLimit = 0;
  double _monthlyLimit = 0;
  double _todayExpenses = 0;

  List<Expense> get expenses => _expenses;
  double get dailyLimit => _dailyLimit;
  double get weeklyLimit => _weeklyLimit;
  double get monthlyLimit => _monthlyLimit;
  double get todayExpenses => _todayExpenses;

  ExpenseProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _dailyLimit = prefs.getDouble('dailyLimit') ?? 0;
    _weeklyLimit = prefs.getDouble('weeklyLimit') ?? 0;
    _monthlyLimit = prefs.getDouble('monthlyLimit') ?? 0;

    String? expensesString = prefs.getString('expenses');
    if (expensesString != null) {
      List<dynamic> jsonList = jsonDecode(expensesString);
      _expenses = jsonList.map((e) => Expense.fromJson(e)).toList();
    }

    await fetchTodayExpenses();

    notifyListeners();
  }

  Future<void> _saveLimit(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }

  Future<void> _saveExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    String expensesString = jsonEncode(_expenses.map((e) => e.toJson()).toList());
    await prefs.setString('expenses', expensesString);
  }

  void addExpense(Expense expense) {
    _expenses.add(expense);
    _saveExpenses();
    fetchTodayExpenses();
    notifyListeners();
  }

  void deleteExpense(int id) {
    _expenses.removeWhere((expense) => expense.id == id);
    _saveExpenses();
    fetchTodayExpenses();
    notifyListeners();
  }

  void setDailyLimit(double limit) {
    _dailyLimit = limit;
    _saveLimit('dailyLimit', limit);
    notifyListeners();
  }

  void setWeeklyLimit(double limit) {
    _weeklyLimit = limit;
    _saveLimit('weeklyLimit', limit);
    notifyListeners();
  }

  void setMonthlyLimit(double limit) {
    _monthlyLimit = limit;
    _saveLimit('monthlyLimit', limit);
    notifyListeners();
  }

  Future<void> fetchDailyLimit() async {
    final dbHelper = DBHelper.instance;
    _dailyLimit = await dbHelper.getDailyLimit();
    notifyListeners();
  }

  Future<void> fetchTodayExpenses() async {
    final dbHelper = DBHelper.instance;
    _todayExpenses = await dbHelper.getTotalExpensesForToday();
    notifyListeners();
  }

  double get progress => _dailyLimit > 0 ? _todayExpenses / _dailyLimit : 0.0;
}