class EmployeeModel {
  // 1. Ιδιότητες (Πεδία) του Εργαζόμενου
  final int id;
  final String name;

  // 2. Constructor: Η συνάρτηση που δημιουργεί το αντικείμενο στην Dart
  EmployeeModel({
    required this.id,
    required this.name,
  });

  // 3. Μετατροπή από Αντικείμενο Dart σε Map (για αποθήκευση στη SQLite)
  // Το Map είναι μια δομή "κλειδί-τιμή" (Key-Value), π.χ. {'id': 101, 'name': 'Γιώργος'}
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  // 4. Δημιουργία Αντικειμένου Dart από Map (όταν διαβάζουμε από τη SQLite)
  // Ο constructor "factory" μας επιτρέπει να επιστρέψουμε ένα έτοιμο αντικείμενο
  factory EmployeeModel.fromMap(Map<String, dynamic> map) {
    return EmployeeModel(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }
}
