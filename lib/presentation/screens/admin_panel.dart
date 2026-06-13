import 'package:flutter/material.dart';
import '../../data/database/database_helper.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  List<Map<String, dynamic>> _employees = [];

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    final data = await DatabaseHelper.instance.fetchAllEmployees();
    setState(() => _employees = data);
  }

  void _showAddEmployeeDialog() {
    final nameController = TextEditingController();
    final idController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Προσθήκη Εργαζόμενου"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: idController, decoration: const InputDecoration(labelText: "ID")),
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Όνομα")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Άκυρο")),
          ElevatedButton(
            onPressed: () async {
              await DatabaseHelper.instance.insertEmployee({
                'id': int.parse(idController.text),
                'name': nameController.text,
                'role': 'user' // Προεπιλογή: απλός χρήστης
              });
              _loadEmployees();
              Navigator.pop(context);
            },
            child: const Text("Προσθήκη"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Πάνελ Διαχειριστή")),
      body: ListView.builder(
        itemCount: _employees.length,
        itemBuilder: (context, index) {
          final emp = _employees[index];
          return ListTile(
            title: Text(emp['name']),
            subtitle: Text("ID: ${emp['id']} | Ρόλος: ${emp['role']}"),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteEmployee(emp['id']), // Κλήση της διαγραφής
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEmployeeDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
  Future<void> _deleteEmployee(int id) async {
    // Προαιρετικά: Μπορείς να βάλεις ένα επιβεβαιωτικό παράθυρο εδώ
    await DatabaseHelper.instance.deleteEmployee(id);
    _loadEmployees(); // Φρεσκάρισμα της λίστας μετά τη διαγραφή
  }
}
