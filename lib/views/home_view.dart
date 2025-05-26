import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/budget_controller.dart';
import '../controllers/expense_controller.dart';
import '../models/budget.dart';
import '../widgets/budget_card.dart';
import '../widgets/pie_chart.dart';

class HomeView extends StatelessWidget {
  final BudgetController budgetController = Get.put(BudgetController());
  final ExpenseController expenseController = Get.put(ExpenseController());

  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _limitController = TextEditingController();

  void _showEditBudgetDialog(BuildContext context, Budget budget) {
    _categoryController.text = budget.category;
    _limitController.text = budget.maxAmount.toString();

    Get.dialog(
      AlertDialog(
        title: Text('Edit Budget', style: GoogleFonts.poppins()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _limitController,
              decoration: InputDecoration(
                labelText: 'Monthly Limit',
                prefixText: '\$',
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (_categoryController.text.isNotEmpty &&
                  _limitController.text.isNotEmpty) {
                budgetController.updateBudget(
                  Budget(
                    id: budget.id,
                    category: _categoryController.text,
                    maxAmount: double.parse(_limitController.text),
                    month: budget.month,
                    year: budget.year,
                  ),
                );
                Get.back();
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(int id) {
    Get.defaultDialog(
      title: 'Delete Budget',
      middleText: 'Are you sure you want to delete this budget?',
      textCancel: 'Cancel',
      textConfirm: 'Delete',
      confirmTextColor: Colors.white,
      onConfirm: () {
        budgetController.deleteBudget(id);
        Get.back();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Budget Manager',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          if (budgetController.isLoading.value ||
              expenseController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Monthly Overview',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              PieChartWidget(
                budgets: budgetController.budgets,
                expenses: expenseController.expenses,
              ),

              const SizedBox(height: 24),
              Text(
                'Your Budgets',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              budgetController.budgets.isEmpty
                  ? const Center(child: Text('No budgets set yet!'))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: budgetController.budgets.length,
                      itemBuilder: (context, index) {
                        final budget = budgetController.budgets[index];
                        final categoryExpenses = expenseController.expenses
                            .where((e) => e.category == budget.category)
                            .toList();
                        final totalSpent = categoryExpenses.fold(
                          0.0,
                          (sum, e) => sum + e.amount,
                        );
                        return BudgetCard(
                          budget: budget,
                          totalSpent: totalSpent,
                          onEdit: () => _showEditBudgetDialog(context, budget),
                          onDelete: () => _confirmDelete(budget.id!),
                        );
                      },
                    ),
            ],
          );
        }),
      ),
    );
  }
}
