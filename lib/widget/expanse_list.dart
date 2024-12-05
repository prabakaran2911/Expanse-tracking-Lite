import 'package:expanse/provider/expense_provider.dart';
import 'package:expanse/screens/Add_Edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, child) {
        return ListView.builder(
          itemCount: provider.expenses.length,
          itemBuilder: (context, index) {
            final expense = provider.expenses[index];
            return Dismissible(
              key: Key(expense.id!),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 20),
                child: Icon(Icons.delete, color: Colors.white),
              ),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                provider.deleteExpense(expense.id!);
              },
              child: Container(
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    gradient: LinearGradient(
                      colors: [
                        const Color.fromARGB(255, 115, 159, 195),
                        const Color.fromARGB(255, 181, 204, 223),
                      ],
                    )),
                child: ListTile(
                  title: Text(
                    expense.title,
                    style: TextStyle(fontFamily: 'Lexend-Bold'),
                  ),
                  subtitle: Text(
                    '${expense.category} - ${expense.date.toString().split(' ')[0]}',
                  ),
                  trailing: Text('\$${expense.amount.toStringAsFixed(2)}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddEditExpenseScreen(
                          expense: expense,
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
