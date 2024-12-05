import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expanse/model/expense.dart';
import 'package:flutter/foundation.dart';

class ExpenseProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  Future<void> fetchExpenses() async {
    try {
      final snapshot = await _firestore.collection('expenses').get();
      _expenses = snapshot.docs
          .map((doc) => Expense.fromMap(doc.data(), doc.id))
          .toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching expenses: $e');
    }
  }

  Future<void> addExpense(Expense expense) async {
    try {
      final docRef =
          await _firestore.collection('expenses').add(expense.toMap());
      expense.id = docRef.id;
      _expenses.add(expense);
      notifyListeners();
    } catch (e) {
      print('Error adding expense: $e');
    }
  }

  Future<void> updateExpense(Expense expense) async {
    try {
      await _firestore
          .collection('expenses')
          .doc(expense.id)
          .update(expense.toMap());
      final index = _expenses.indexWhere((e) => e.id == expense.id);
      _expenses[index] = expense;
      notifyListeners();
    } catch (e) {
      print('Error updating expense: $e');
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      await _firestore.collection('expenses').doc(id).delete();
      _expenses.removeWhere((expense) => expense.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting expense: $e');
    }
  }
}
