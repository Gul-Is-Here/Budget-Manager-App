// widgets/expense_tile.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/expense.dart';

class ExpenseTile extends StatelessWidget {
  final Expense expense;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ExpenseTile({
    required this.expense,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Get.theme.colorScheme.primary,
          child: Text(
            expense.amount.toStringAsFixed(0),
            style: TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          expense.description,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          '${expense.category} • ${expense.date}',
        ),
        trailing: Text(
          '\$${expense.amount.toStringAsFixed(2)}',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        onTap: onEdit,
        onLongPress: onDelete,
      ),
    );
  }
}