// controllers/expense_controller.dart
import 'package:get/get.dart';
import '../models/expense.dart';
import '../database/database_helper.dart';

class ExpenseController extends GetxController {
  var expenses = <Expense>[].obs;
  var filteredExpenses = <Expense>[].obs;
  var isLoading = true.obs;
  var searchQuery = ''.obs;
  var selectedCategory = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    loadExpenses();
  }

  Future<void> loadExpenses() async {
    try {
      isLoading(true);
      final db = await DatabaseHelper.instance.database;
      final maps = await db.query('expenses', orderBy: 'date DESC');
      expenses.assignAll(maps.map((e) => Expense.fromMap(e)).toList());
      filterExpenses();
    } finally {
      isLoading(false);
    }
  }

  void filterExpenses() {
    filteredExpenses.value = expenses.where((expense) {
      final matchesSearch = expense.description
          .toLowerCase()
          .contains(searchQuery.value.toLowerCase());
      final matchesCategory = selectedCategory.value == 'All' ||
          expense.category == selectedCategory.value;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  Future<void> addExpense(Expense expense) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('expenses', expense.toMap());
    await loadExpenses();
  }

  Future<void> updateExpense(Expense expense) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
    await loadExpenses();
  }

  Future<void> deleteExpense(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
    await loadExpenses();
  }
}