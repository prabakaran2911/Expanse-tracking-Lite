import 'package:expanse/provider/expense_provider.dart';
import 'package:expanse/screens/Add_Edit_screen.dart';
import 'package:expanse/widget/expanse_list.dart';
import 'package:expanse/widget/expanse_summery.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<ExpenseProvider>(context, listen: false).fetchExpenses());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 207, 224, 238),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 207, 224, 238),
        title: Text(
          'Expense Tracker',
          style: TextStyle(
              fontFamily: 'RussoOne',
              color: const Color.fromARGB(255, 49, 87, 117)),
        ),
      ),
      body: Column(
        children: [
          StylishExpenseChart(),
          Expanded(child: ExpenseList()),
          Container(
            margin: EdgeInsets.only(bottom: 10, right: 10),
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEditExpenseScreen(),
                  ),
                );
              },
              child: Text(
                'Add More',
                style:
                    TextStyle(fontFamily: 'Lexend-Bold', color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
