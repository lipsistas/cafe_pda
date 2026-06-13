import 'package:flutter/material.dart';
import 'data/database/database_helper.dart';
import 'presentation/screens/login_screen.dart';

void main() async {
  // 1. Απαραίτητο για επικοινωνία με τη βάση
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Αρχικοποιούμε τη βάση
  final dbHelper = DatabaseHelper.instance;
  await dbHelper.database;

  // 3. Ελέγχουμε αν υπάρχει κάποιος εργαζόμενος
  final List<Map<String, dynamic>> employeeList = await dbHelper.fetchAllEmployees();
  
  if (employeeList.isEmpty) {
    // Αν είναι άδεια, προσθέτουμε τον Admin
    await dbHelper.insertEmployee({'id': 1, 'name': 'Admin'});
    print("--- [DEBUG] Προστέθηκε ο Admin με ID: 1 ---");
  } else {
    // Αν υπάρχουν ήδη, τους εμφανίζουμε στο console για επιβεβαίωση
    print("--- [DEBUG] Υπάρχουν ήδη εργαζόμενοι: $employeeList ---");
  }

  // 4. Ξεκινάμε την εφαρμογή
  runApp(const CafePDAApp());
}

class CafePDAApp extends StatelessWidget {
  const CafePDAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cafe PDA',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
