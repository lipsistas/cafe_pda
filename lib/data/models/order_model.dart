class OrderModel {
  final int? id; // Το ID είναι nullable (?) γιατί όταν φτιάχνουμε μια νέα παραγγελία, η SQLite δεν της έχει δώσει ακόμα ID
  final int tableNumber;
  final int productId;
  final int quantity;
  final DateTime createdAt; // Ημερομηνία και ώρα παραγγελίας
  final int openedByEmployeeId;
  final String status; // 'Εκκρεμεί', 'Έτοιμη', 'Σερβιρίστηκε'
  final int isPaid; // 0 για ανοιχτή, 1 for πληρωμένη (η SQLite δεν έχει Boolean, χρησιμοποιεί 0 και 1)
  final int? closedByEmployeeId; // Nullable (?) γιατί συμπληρώνεται μόνο όταν πληρωθεί

  // Constructor
  OrderModel({
    this.id,
    required this.tableNumber,
    required this.productId,
    required this.quantity,
    required this.createdAt,
    required this.openedByEmployeeId,
    required this.status,
    required this.isPaid,
    this.closedByEmployeeId,
  });

  // Μετατροπή από Αντικείμενο Dart σε Map (για αποθήκευση στη SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'table_number': tableNumber,
      'product_id': productId,
      'quantity': quantity,
      // Η SQLite δεν αποθηκεύει DateTime. Μετατρέπουμε την ημερομηνία σε κείμενο (ISO8601 String)
      // π.χ. "2026-06-07T17:15:00.000"
      'created_at': createdAt.toIso8601String(),
      'opened_by_employee_id': openedByEmployeeId,
      'status': status,
      'is_paid': isPaid,
      'closed_by_employee_id': closedByEmployeeId,
    };
  }

  // Δημιουργία Αντικειμένου Dart από Map (όταν διαβάζουμε από τη βάση)
  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] as int?,
      tableNumber: map['table_number'] as int,
      productId: map['product_id'] as int,
      quantity: map['quantity'] as int,
      // Παίρνουμε το κείμενο από τη βάση και το ξανακάνουμε αντικείμενο DateTime στην Dart
      createdAt: DateTime.parse(map['created_at'] as String),
      openedByEmployeeId: map['opened_by_employee_id'] as int,
      status: map['status'] as String,
      isPaid: map['is_paid'] as int,
      closedByEmployeeId: map['closed_by_employee_id'] as int?,
    );
  }
}
