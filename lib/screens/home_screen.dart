import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:finance_app/providers/expense_provider.dart';
import 'package:finance_app/screens/set_limit_screen.dart';
import 'package:finance_app/screens/stats_screen.dart';
import 'package:finance_app/screens/profile_screen.dart';
import 'package:finance_app/widgets/expense_list.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:finance_app/widgets/home_screen_content.dart';

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
      Container(), // Placeholder for Add button
      StatsScreen(),
      ProfileScreen(),
    ];
  }

  void _showAddExpenseDialog(BuildContext context) {
    TextEditingController amountController = TextEditingController();
    TextEditingController noteController = TextEditingController();
    String selectedCategory = "Food";
    // Implement the dialog to add expenses
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildScreens()[_currentIndex],
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 2) {
            Future.microtask(() => _showAddExpenseDialog(context));
          }
        },
        items: [
          FlashyTabBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.add),
            title: Text('Add'),
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.bar_chart),
            title: Text('Stats'),
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
          ),
        ],
      ),
    );
  }
}