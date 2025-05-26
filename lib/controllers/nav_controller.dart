// controllers/nav_controller.dart
import 'package:get/get.dart';
import '../views/home_view.dart';
import '../views/budgets_view.dart';
import '../views/expenses_view.dart';
import '../views/reports_view.dart';
import '../views/settings_view.dart';

class NavController extends GetxController {
  var currentIndex = 0.obs;
  
  final pages = [
    HomeView(),
    BudgetsView(),
    ExpensesView(),
    ReportsView(),
    SettingsView(),
  ];

  void changePage(int index) {
    currentIndex.value = index;
  }
}