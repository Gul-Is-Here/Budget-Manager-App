// widgets/pie_chart.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';
import '../models/budget.dart';
import '../models/expense.dart';

class PieChartWidget extends StatelessWidget {
  final List<Budget> budgets;
  final List<Expense> expenses;

  const PieChartWidget({
    required this.budgets,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context) {
    if (budgets.isEmpty || expenses.isEmpty) {
      return Center(child: Text('Not enough data to display chart'));
    }

    // Calculate spending per category
    final Map<String, double> categorySpending = {};
    for (var budget in budgets) {
      final categoryExpenses = expenses
          .where((expense) => expense.category == budget.category)
          .toList();
      final totalSpent = categoryExpenses
          .fold(0.0, (sum, expense) => sum + expense.amount);
      categorySpending[budget.category] = totalSpent;
    }

    // Prepare data for pie chart
    final dataMap = categorySpending.map((key, value) => 
        MapEntry(key, value > 0 ? value : 0.1)); // 0.1 to show small slice

    return Container(
      height: 200,
      child: PieChart(
        dataMap: dataMap,
        chartType: ChartType.ring,
        colorList: [
          Get.theme.colorScheme.primary,
          Get.theme.colorScheme.secondary,
          Color(0xFFFD79A8), // Pink
          Color(0xFF00B894), // Green
          Color(0xFFFDCB6E), // Yellow
        ],
        chartValuesOptions: ChartValuesOptions(
          showChartValuesInPercentage: true,
          decimalPlaces: 0,
        ),
        legendOptions: LegendOptions(
          showLegends: true,
          legendPosition: LegendPosition.right,
          legendTextStyle: GoogleFonts.poppins(fontSize: 12),
        ),
      ),
    );
  }
}