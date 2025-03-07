import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:budget_app/providers/expense_provider.dart';
import 'package:budget_app/screens/set_limit_screen.dart';
import 'package:budget_app/screens/stats_screen.dart';
import 'package:budget_app/screens/profile_screen.dart';
import 'package:budget_app/widgets/home_screen_content.dart';
import 'package:budget_app/widgets/bottom_navigation_bar.dart';
import 'package:budget_app/widgets/add_expense_dialog.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  List<Widget> _buildScreens() {
    return [
      HomeScreenContent(),
      SetLimitScreen(),
      StatsScreen(),
      ProfileScreen(),
    ];
  }

  void _showAddExpenseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddExpenseDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Finance App')),
      body: _buildScreens()[_currentIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddExpenseDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
