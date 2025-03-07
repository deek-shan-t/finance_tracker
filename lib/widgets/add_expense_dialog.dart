import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../models/expense.dart';

class AddExpenseDialog extends StatefulWidget {
  @override
  _AddExpenseDialogState createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  TextEditingController amountController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  String selectedCategory = "Food";
  List<String> categories = ["Food", "Transport", "Entertainment", "Other"];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Expense"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Amount"),
          ),
          TextField(
            controller: noteController,
            decoration: InputDecoration(labelText: "Note"),
          ),
          DropdownButton<String>(
            value: selectedCategory,
            onChanged: (String? newValue) {
              setState(() {
                selectedCategory = newValue!;
              });
            },
            items: categories.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            final amount = double.tryParse(amountController.text);
            if (amount != null) {
              final expense = Expense(
                amount: amount,
                note: noteController.text,
                category: selectedCategory,
                date: DateTime.now(),
              );
              Provider.of<ExpenseProvider>(context, listen: false).addExpense(expense);
              Navigator.of(context).pop();
            }
          },
          child: Text("Add"),
        ),
      ],
    );
  }
}