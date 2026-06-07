import 'package:flutter/material.dart';
import 'data/database/database_helper.dart';
import 'data/models/employee_model.dart';
import 'data/models/product_model.dart';
import 'data/models/order_model.dart';
import 'presentation/screens/table_selection_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('--- ΕΚΚΙΝΗΣΗ TEST DRIVE ΒΑΣΗΣ ΔΕΔΟΜΕΝΩΝ ---');

  final dbHelper = DatabaseHelper.instance;

  // 1. ΔΟΚΙΜΗ: ΕΙΣΑΓΩΓΗ ΕΡΓΑΖΟΜΕΝΟΥ
  final newEmployee = EmployeeModel(id: 101, name: 'Λουκάς');
  await dbHelper.insertEmployee(newEmployee.toMap());
  print('✅ Ο εργαζόμενος αποθηκεύτηκε επιτυχώς!');

  // 2. ΔΟΚΙΜΗ: ΕΙΣΑΓΩΓΗ ΠΡΟΪΟΝΤΟΣ
  final newProduct = ProductModel(id: 1, name: 'Φρέδο Εσπρέσο', price: 2.50, category: 'Καφέδες');
  await dbHelper.insertProduct(newProduct.toMap());
  print('✅ Το προϊόν αποθηκεύτηκε επιτυχώς!');

  // 3. ΔΟΚΙΜΗ: ΚΑΤΑΧΩΡΗΣΗ ΠΑΡΑΓΓΕΛΙΑΣ
  final newOrder = OrderModel(
    tableNumber: 5,
    productId: 1,
    quantity: 2,
    createdAt: DateTime.now(),
    openedByEmployeeId: 101,
    status: 'Εκκρεμεί',
    isPaid: 0,
  );
  await dbHelper.insertOrder(newOrder.toMap());
  print('✅ Η παραγγελία για το Τραπέζι 5 καταχωρήθηκε!');

  // 4. ΔΟΚΙΜΗ: ΑΝΑΚΤΗΣΗ ΚΑΙ ΕΛΕΓΧΟΣ ΔΕΔΟΜΕΝΩΝ
  print('\n--- ΕΛΕΓΧΟΣ ΔΕΔΟΜΕΝΩΝ ΣΤΗ ΒΑΣΗ ---');
  
  final employees = await dbHelper.fetchAllEmployees();
  print('Εργαζόμενοι στη βάση: $employees');

  final products = await dbHelper.fetchAllProducts();
  print('Προϊόντα στη βάση: $products');

  final openOrders = await dbHelper.fetchOpenOrdersByTable(5);
  print('Ανοιχτές παραγγελίες Τραπεζιού 5: $openOrders');

  print('-----------------------------------------');

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TableSelectionScreen(),
  ));
}
