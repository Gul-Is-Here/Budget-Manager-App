// views/expenses_view.dart
import 'package:budget_manager_app/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/expense_controller.dart';
import '../controllers/budget_controller.dart';
import '../widgets/expense_tile.dart';

class ExpensesView extends StatelessWidget {
  final ExpenseController expenseController = Get.put(ExpenseController());
  final BudgetController budgetController = Get.put(BudgetController());

  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String selectedCategory = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Expenses',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddExpenseDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) {
                expenseController.searchQuery.value = value;
                expenseController.filterExpenses();
              },
              decoration: InputDecoration(
                labelText: 'Search expenses',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Obx(
            () => DropdownButton<String>(
              value: expenseController.selectedCategory.value,
              onChanged: (String? newValue) {
                expenseController.selectedCategory.value = newValue!;
                expenseController.filterExpenses();
              },
              items: ['All']
                  .followedBy(
                    budgetController.budgets
                        .map((budget) => budget.category)
                        .toList(),
                  )
                  .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  })
                  .toList(),
            ),
          ),
          Expanded(
            child: Obx(
              () => expenseController.isLoading.value
                  ? Center(child: CircularProgressIndicator())
                  : expenseController.filteredExpenses.isEmpty
                  ? Center(child: Text('No expenses found'))
                  : ListView.builder(
                      itemCount: expenseController.filteredExpenses.length,
                      itemBuilder: (context, index) {
                        final expense =
                            expenseController.filteredExpenses[index];
                        return ExpenseTile(
                          expense: expense,
                          onEdit: () =>
                              _showEditExpenseDialog(context, expense),
                          onDelete: () =>
                              expenseController.deleteExpense(expense.id!),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddExpenseDialog(BuildContext context) {
    amountController.clear();
    descriptionController.clear();
    dateController.text = DateTime.now().toString().split(' ')[0];
    selectedCategory = budgetController.budgets.isNotEmpty
        ? budgetController.budgets[0].category
        : '';

    Get.dialog(
      AlertDialog(
        title: Text('Add New Expense', style: GoogleFonts.poppins()),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 16),
              Obx(
                () => DropdownButtonFormField<String>(
                  value:
                      selectedCategory.isEmpty &&
                          budgetController.budgets.isNotEmpty
                      ? budgetController.budgets[0].category
                      : selectedCategory,
                  onChanged: (String? newValue) {
                    selectedCategory = newValue!;
                  },
                  items: budgetController.budgets
                      .map((budget) => budget.category)
                      .toList()
                      .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      })
                      .toList(),
                  decoration: InputDecoration(labelText: 'Category'),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: dateController,
                decoration: InputDecoration(
                  labelText: 'Date',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        dateController.text = date.toString().split(' ')[0];
                      }
                    },
                  ),
                ),
                readOnly: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (amountController.text.isNotEmpty &&
                  descriptionController.text.isNotEmpty &&
                  selectedCategory.isNotEmpty) {
                expenseController.addExpense(
                  Expense(
                    amount: double.parse(amountController.text),
                    category: selectedCategory,
                    description: descriptionController.text,
                    date: dateController.text,
                  ),
                );
                Get.back();
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showEditExpenseDialog(BuildContext context, Expense expense) {
    amountController.text = expense.amount.toString();
    descriptionController.text = expense.description;
    dateController.text = expense.date;
    selectedCategory = expense.category;

    Get.dialog(
      AlertDialog(
        title: Text('Edit Expense', style: GoogleFonts.poppins()),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 16),
              Obx(
                () => DropdownButtonFormField<String>(
                  value: selectedCategory,
                  onChanged: (String? newValue) {
                    selectedCategory = newValue!;
                  },
                  items: budgetController.budgets
                      .map((budget) => budget.category)
                      .toList()
                      .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      })
                      .toList(),
                  decoration: InputDecoration(labelText: 'Category'),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: dateController,
                decoration: InputDecoration(
                  labelText: 'Date',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.parse(dateController.text),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        dateController.text = date.toString().split(' ')[0];
                      }
                    },
                  ),
                ),
                readOnly: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (amountController.text.isNotEmpty &&
                  descriptionController.text.isNotEmpty &&
                  selectedCategory.isNotEmpty) {
                expenseController.updateExpense(
                  Expense(
                    id: expense.id,
                    amount: double.parse(amountController.text),
                    category: selectedCategory,
                    description: descriptionController.text,
                    date: dateController.text,
                  ),
                );
                Get.back();
              }
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }
}
