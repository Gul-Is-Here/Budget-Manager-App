import 'package:budget_manager_app/models/budget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/budget_controller.dart';
import '../widgets/budget_card.dart';

class BudgetsView extends StatelessWidget {
  final BudgetController budgetController = Get.find();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController limitController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Budgets',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddBudgetDialog(context),
          ),
        ],
      ),
      body: Obx(() {
        if (budgetController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (budgetController.budgets.isEmpty) {
          return const Center(child: Text('No budgets set yet!'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: budgetController.budgets.length,
          itemBuilder: (context, index) {
            final budget = budgetController.budgets[index];
            return BudgetCard(
              totalSpent: 100, // You can calculate actual total from expenses
              budget: budget,
              onEdit: () => _showEditBudgetDialog(context, budget),
              onDelete: () => budgetController.deleteBudget(budget.id!),
            );
          },
        );
      }),
    );
  }

  void _showAddBudgetDialog(BuildContext context) {
    categoryController.clear();
    limitController.clear();

    Get.dialog(
      AlertDialog(
        title: Text('Add New Budget', style: GoogleFonts.poppins()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: 'Category',
                hintText: 'e.g. Food, Transportation',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: limitController,
              decoration: const InputDecoration(
                labelText: 'Monthly Limit',
                prefixText: '\$',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (categoryController.text.isNotEmpty &&
                  limitController.text.isNotEmpty) {
                final now = DateTime.now();
                budgetController.addBudget(
                  Budget(
                    category: categoryController.text.trim(),
                    maxAmount:
                        double.tryParse(limitController.text.trim()) ?? 0,
                    month: now.month,
                    year: now.year,
                  ),
                );
                Get.back();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showEditBudgetDialog(BuildContext context, Budget budget) {
    categoryController.text = budget.category;
    limitController.text = budget.maxAmount.toString();

    Get.dialog(
      AlertDialog(
        title: Text('Edit Budget', style: GoogleFonts.poppins()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: limitController,
              decoration: const InputDecoration(
                labelText: 'Monthly Limit',
                prefixText: '\$',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (categoryController.text.isNotEmpty &&
                  limitController.text.isNotEmpty) {
                budgetController.updateBudget(
                  Budget(
                    id: budget.id,
                    category: categoryController.text.trim(),
                    maxAmount:
                        double.tryParse(limitController.text.trim()) ?? 0,
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
}
