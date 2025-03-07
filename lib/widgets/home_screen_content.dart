import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budget_app/providers/expense_provider.dart';
import 'package:budget_app/widgets/expense_list.dart';

class HomeScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, expenseProvider, child) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: LinearProgressIndicator(
                value: expenseProvider.progress,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
            Text(
              'Daily Limit: \$${expenseProvider.dailyLimit.toStringAsFixed(2)}',
            ),
            Text(
              'Today\'s Expenses: \$${expenseProvider.todayExpenses.toStringAsFixed(2)}',
            ),
            Expanded(child: ExpenseList()),
          ],
        );
      },
    );
  }
}
