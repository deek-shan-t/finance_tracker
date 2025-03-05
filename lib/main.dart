import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finance_app/providers/expense_provider.dart';
import 'package:finance_app/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ExpenseProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Expense Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          hintColor: Colors.amber,
          textTheme: TextTheme(
            bodyLarge: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            bodyMedium: TextStyle(fontSize: 16.0),
          ),
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.blue,
            textTheme: ButtonTextTheme.primary,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            elevation: 4.0,
            sizeConstraints: BoxConstraints.tightFor(
              width: 70.0,
              height: 70.0,
            ),
          ),
        ),
        home: HomeScreen(),
      ),
    );
  }
}