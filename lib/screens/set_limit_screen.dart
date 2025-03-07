import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budget_app/providers/expense_provider.dart';

class SetLimitScreen extends StatefulWidget {
  @override
  _SetLimitScreenState createState() => _SetLimitScreenState();
}

class _SetLimitScreenState extends State<SetLimitScreen> {
  final TextEditingController _dailyLimitController = TextEditingController();
  final TextEditingController _weeklyLimitController = TextEditingController();
  final TextEditingController _monthlyLimitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final expenseProvider = Provider.of<ExpenseProvider>(
        context,
        listen: false,
      );
      _dailyLimitController.text = expenseProvider.dailyLimit.toString();
      _weeklyLimitController.text = expenseProvider.weeklyLimit.toString();
      _monthlyLimitController.text = expenseProvider.monthlyLimit.toString();
    });
  }

  @override
  void dispose() {
    _dailyLimitController.dispose();
    _weeklyLimitController.dispose();
    _monthlyLimitController.dispose();
    super.dispose();
  }

  void _setLimits() {
    final expenseProvider = Provider.of<ExpenseProvider>(
      context,
      listen: false,
    );
    final double dailyLimit = double.tryParse(_dailyLimitController.text) ?? 0;
    final double weeklyLimit =
        double.tryParse(_weeklyLimitController.text) ?? 0;
    final double monthlyLimit =
        double.tryParse(_monthlyLimitController.text) ?? 0;

    expenseProvider.setDailyLimit(dailyLimit);
    expenseProvider.setWeeklyLimit(weeklyLimit);
    expenseProvider.setMonthlyLimit(monthlyLimit);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Limits set successfully!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Set Limits')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _dailyLimitController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Daily Limit'),
            ),
            TextField(
              controller: _weeklyLimitController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Weekly Limit'),
            ),
            TextField(
              controller: _monthlyLimitController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Monthly Limit'),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _setLimits, child: Text('Set Limits')),
          ],
        ),
      ),
    );
  }
}
