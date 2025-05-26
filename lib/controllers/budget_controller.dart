// controllers/budget_controller.dart
import 'package:get/get.dart';
import '../models/budget.dart';
import '../database/database_helper.dart';

class BudgetController extends GetxController {
  var budgets = <Budget>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadBudgets();
  }

  Future<void> loadBudgets() async {
    try {
      isLoading(true);
      final db = await DatabaseHelper.instance.database;
      final maps = await db.query('budgets');
      budgets.assignAll(maps.map((e) => Budget.fromMap(e)).toList());
    } finally {
      isLoading(false);
    }
  }

  Future<void> addBudget(Budget budget) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('budgets', budget.toMap());
    await loadBudgets();
  }

  Future<void> updateBudget(Budget budget) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'budgets',
      budget.toMap(),
      where: 'id = ?',
      whereArgs: [budget.id],
    );
    await loadBudgets();
  }

  Future<void> deleteBudget(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete(
      'budgets',
      where: 'id = ?',
      whereArgs: [id],
    );
    await loadBudgets();
  }
}