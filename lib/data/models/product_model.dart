class ProductModel {
  // 1. Ιδιότητες του Προϊόντος
  final int id;
  final String name;
  final double price; // Χρησιμοποιούμε double για δεκαδικούς αριθμούς (π.χ. 2.50)
  final String category;

  // 2. Constructor
  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
  });

  // 3. Μετατροπή από Αντικείμενο Dart σε Map (για αποθήκευση στη SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'category': category,
    };
  }

  // 4. Δημιουργία Αντικειμένου Dart από Map (όταν διαβάζουμε από τη βάση)
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as int,
      name: map['name'] as String,
      // Επειδή η SQLite μπορεί να επιστρέψει την τιμή ως int ή double, 
      // κάνουμε μια ασφαλή μετατροπή σε double χρησιμοποιώντας το .toDouble()
      price: (map['price'] as num).toDouble(),
      category: map['category'] as String,
    );
  }
}
