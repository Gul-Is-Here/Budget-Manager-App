// views/reports_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/expense_controller.dart';
import '../controllers/budget_controller.dart';
import '../widgets/pie_chart.dart';

class ReportsView extends StatelessWidget {
  final ExpenseController expenseController = Get.find();
  final BudgetController budgetController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reports',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Spending Overview',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // ✅ Reactive Pie Chart with Obx and .toList()
            Obx(() {
              final budgets = budgetController.budgets.toList();
              final expenses = expenseController.expenses.toList();
              return PieChartWidget(budgets: budgets, expenses: expenses);
            }),

            const SizedBox(height: 24),
            Text(
              'Recent Expenses',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // ✅ Reactive recent expenses list
            Obx(() {
              final recentExpenses = expenseController.expenses;
              if (recentExpenses.isEmpty) {
                return const Center(child: Text('No expenses recorded yet!'));
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recentExpenses.length > 5
                    ? 5
                    : recentExpenses.length,
                itemBuilder: (context, index) {
                  final expense = recentExpenses[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        expense.amount.toStringAsFixed(0),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(expense.description),
                    subtitle: Text(expense.category),
                    trailing: Text(
                      '\$${expense.amount.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
