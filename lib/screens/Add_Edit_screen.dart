import 'package:expanse/model/expense.dart';
import 'package:expanse/provider/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddEditExpenseScreen extends StatefulWidget {
  final Expense? expense;

  AddEditExpenseScreen({this.expense});

  @override
  _AddEditExpenseScreenState createState() => _AddEditExpenseScreenState();
}

class _AddEditExpenseScreenState extends State<AddEditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late String _selectedCategory;
  late DateTime _selectedDate;

  final List<String> _categories = ['Food', 'Travel', 'Shopping', 'Others'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.expense?.title ?? '');
    _amountController =
        TextEditingController(text: widget.expense?.amount.toString() ?? '');
    _selectedCategory = widget.expense?.category ?? _categories[0];
    _selectedDate = widget.expense?.date ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 207, 224, 238),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 207, 224, 238),
        title: Text(
          widget.expense == null ? 'Add Expense' : 'Edit Expense',
          style: TextStyle(
              fontFamily: 'RussoOne',
              color: const Color.fromARGB(255, 49, 87, 117)),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                child: TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: TextStyle(fontFamily: 'Lexend-Bold'),
                      border: OutlineInputBorder()),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(
                      labelText: 'Amount',
                      labelStyle: TextStyle(fontFamily: 'Lexend-Bold'),
                      border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter an amount';
                    }
                    if (double.tryParse(value!) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 20),
                child: DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: _categories
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                  decoration: InputDecoration(
                      labelText: 'Category',
                      labelStyle: TextStyle(fontFamily: 'Lexend-Bold'),
                      border: OutlineInputBorder()),
                ),
              ),
              Card(
                color: const Color.fromARGB(255, 154, 201, 239),
                elevation: 0,
                child: ListTile(
                  title:
                      Text('Date', style: TextStyle(fontFamily: 'Lexend-Bold')),
                  subtitle: Text(_selectedDate.toString().split(' ')[0]),
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                ),
              ),
              Container(
                height: 50,
                width: 150,
                margin: EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  onPressed: _saveExpense,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 107, 179, 239),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10) // Set to zero for rectangular corners
                        ),
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'Lexend-Bold',
                        color: const Color.fromARGB(255, 49, 87, 117)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveExpense() {
    if (_formKey.currentState?.validate() ?? false) {
      final expense = Expense(
        id: widget.expense?.id,
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        category: _selectedCategory,
        date: _selectedDate,
      );

      final provider = Provider.of<ExpenseProvider>(context, listen: false);
      if (widget.expense == null) {
        provider.addExpense(expense);
      } else {
        provider.updateExpense(expense);
      }

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
