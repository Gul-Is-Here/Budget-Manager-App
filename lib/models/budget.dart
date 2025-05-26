// models/budget.dart
class Budget {
  final int? id;
  final String category;
  final double maxAmount; // Changed from 'limit' to 'maxAmount'
  final int month;
  final int year;

  Budget({
    this.id,
    required this.category,
    required this.maxAmount,
    required this.month,
    required this.year,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'max_amount': maxAmount, // Matches the column name
      'month': month,
      'year': year,
    };
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      id: map['id'],
      category: map['category'],
      maxAmount: map['max_amount'],
      month: map['month'],
      year: map['year'],
    );
  }
}
