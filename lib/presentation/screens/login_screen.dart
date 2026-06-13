import 'package:flutter/material.dart';
import '../../data/database/database_helper.dart';
import 'home_screen.dart';
import 'admin_panel.dart'; // Βεβαιώσου ότι υπάρχει αυτό το αρχείο

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idController = TextEditingController();

  Future<void> _login() async {
    final id = int.tryParse(_idController.text);
    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Παρακαλώ εισάγετε έναν έγκυρο αριθμό ID")),
      );
      return;
    }

    // Αναζήτηση του εργαζόμενου στη βάση
    final employee = await DatabaseHelper.instance.getEmployeeById(id);

    if (!mounted) return;

    if (employee != null) {
      final role = employee['role']; // Παίρνουμε τον ρόλο από τη βάση

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Επιτυχής σύνδεση!"), backgroundColor: Colors.green),
      );

      // Πλοήγηση ανάλογα με τον ρόλο
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => role == 'admin' 
              ? const AdminPanel() 
              : HomeScreen(employeeName: employee['name']),
        ),
      );
    } else {
      // Αν δεν βρέθηκε ο χρήστης
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Δεν βρέθηκε εργαζόμενος"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Είσοδος στο Cafe PDA")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _idController,
              decoration: const InputDecoration(labelText: "ID Εργαζόμενου"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text("Είσοδος"),
            ),
          ],
        ),
      ),
    );
  }
}
