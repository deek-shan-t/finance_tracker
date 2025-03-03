import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../models/expense.dart';

class ExpenseList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, child) {
        final expenses = provider.expenses;

        if (expenses.isEmpty) {
          return Center(child: Text("No expenses for today."));
        }

        return ListView.builder(
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            Expense expense = expenses[index];

            return ListTile(
              title: Text("₹${expense.amount.toStringAsFixed(2)} - ${expense.category}"),
              subtitle: Text(expense.note),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => provider.deleteExpense(expense.id!),
              ),
            );
          },
        );
      },
    );
  }
}
