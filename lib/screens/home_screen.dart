import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../widgets/expense_list.dart';
import '../models/expense.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ExpenseProvider>(context, listen: false);
      provider.loadExpenses();
      provider.loadDailyLimit();
    });
    Provider.of<ExpenseProvider>(context, listen: false).loadExpenses();
    Provider.of<ExpenseProvider>(context, listen: false).loadDailyLimit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daily Expenses")),
      body: Consumer<ExpenseProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Daily Limit: ₹${provider.dailyLimit.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: provider.spendingProgress,
                      backgroundColor: Colors.grey[300],
                      color:
                          (provider.spendingProgress < 0.75)
                              ? Colors.green
                              : Colors.red,
                      minHeight: 10,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Spent Today: ₹${provider.totalExpenses.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              Expanded(child: ExpenseList()),
              FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () => _showAddExpenseDialog(context),
                elevation: 4.0,
                
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAddExpenseDialog(BuildContext context) {
    TextEditingController amountController = TextEditingController();
    TextEditingController noteController = TextEditingController();
    String selectedCategory = "Food";

    showDialog(
      context: context,
      builder: (context) {
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
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items:
                    ["Food", "Transport", "Shopping", "Other"]
                        .map(
                          (cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)),
                        )
                        .toList(),
                onChanged: (value) => selectedCategory = value!,
              ),
              TextField(
                controller: noteController,
                decoration: InputDecoration(labelText: "Note"),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text("Add"),
              onPressed: () {
                double amount = double.tryParse(amountController.text) ?? 0;
                if (amount > 0) {
                  Provider.of<ExpenseProvider>(
                    context,
                    listen: false,
                  ).addExpense(
                    Expense(
                      amount: amount,
                      category: selectedCategory,
                      note: noteController.text,
                      date: DateTime.now(),
                    ),
                  );
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
