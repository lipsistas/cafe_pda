import 'package:flutter/material.dart';
import '../../data/database/database_helper.dart';

class TableSelectionScreen extends StatefulWidget {
  const TableSelectionScreen({super.key});

  @override
  State<TableSelectionScreen> createState() => _TableSelectionScreenState();
}

class _TableSelectionScreenState extends State<TableSelectionScreen> {
  // Μια λίστα που θα κρατάει τους αριθμούς των τραπεζιών που έχουν ανοιχτό λογαριασμό
  List<int> occupiedTables = [];

  @override
  void initState() {
    super.initState();
    _checkOccupiedTables(); // Μόλις ανοίξει η οθόνη, ελέγχουμε τη βάση
  }

  // Συνάρτηση που ελέγχει ποια τραπέζια είναι κατειλημμένα
  Future<void> _checkOccupiedTables() async {
    final dbHelper = DatabaseHelper.instance;
    List<int> busyList = [];

    // Θα ελέγξουμε για παράδειγμα 20 τραπέζια
    for (int i = 1; i <= 20; i++) {
      final openOrders = await dbHelper.fetchOpenOrdersByTable(i);
      if (openOrders.isNotEmpty) {
        busyList.add(i); // Αν βρει ανοιχτή παραγγελία, προσθέτει το τραπέζι στη λίστα
      }
    }

    // Ενημερώνουμε το UI με το setState
    setState(() {
      occupiedTables = busyList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Η πάνω μπάρα της οθόνης
      appBar: AppBar(
        title: const Text('Επιλογή Τραπεζιού'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        actions: [
          // Κουμπί ανανέωσης (Refresh) στην μπάρα
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _checkOccupiedTables,
          ),
        ],
      ),
      // Το κυρίως σώμα της οθόνης
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          // Ορίζουμε τη δομή του πλέγματος (Grid)
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // 4 τραπέζια ανά σειρά, ιδανικό για PDA/Κινητό
            crossAxisSpacing: 12.0, // Κενό ανάμεσα στις στήλες
            mainAxisSpacing: 12.0,  // Κενό ανάμεσα στις σειρές
          ),
          itemCount: 20, // Συνολικός αριθμός τραπεζιών
          itemBuilder: (context, index) {
            final tableNumber = index + 1;
            // Έλεγχος αν το τραπέζι είναι κατειλημμένο
            final isOccupied = occupiedTables.contains(tableNumber);

            return InkWell(
              onTap: () {
                // Εδώ στο μέλλον θα ανοίγουμε την οθόνη της παραγγελίας
                print('Πατήθηκε το Τραπέζι $tableNumber');
              },
              child: Container(
                decoration: BoxDecoration(
                  // Αν είναι γεμάτο κόκκινο, αν είναι άδειο πράσινο
                  color: isOccupied ? Colors.red[400] : Colors.green[400],
                  borderRadius: BorderRadius.circular(12.0), // Στρογγυλεμένες γωνίες
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  'T $tableNumber',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
