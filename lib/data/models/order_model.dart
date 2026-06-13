class OrderModel {
  final int? id; // Το id είναι nullable γιατί το δίνει η βάση αυτόματα (auto-increment)
  final int tableNumber;
  final int productId;
  final int quantity;
  final DateTime createdAt;
  final int openedByEmployeeId;
  final String status;
  final int isPaid; // 0 για ψευδές (όχι πληρωμένο), 1 για αληθές

  OrderModel({
    this.id,
    required this.tableNumber,
    required this.productId,
    required this.quantity,
    required this.createdAt,
    required this.openedByEmployeeId,
    required this.status,
    required this.isPaid,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'table_number': tableNumber,
      'product_id': productId,
      'quantity': quantity,
      'created_at': createdAt.toIso8601String(),
      'opened_by_employee_id': openedByEmployeeId,
      'status': status,
      'is_paid': isPaid,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'],
      tableNumber: map['table_number'],
      productId: map['product_id'],
      quantity: map['quantity'],
      createdAt: DateTime.parse(map['created_at']),
      openedByEmployeeId: map['opened_by_employee_id'],
      status: map['status'],
      isPaid: map['is_paid'],
    );
  }
}
