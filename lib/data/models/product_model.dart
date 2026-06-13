class ProductModel {
  final int id;
  final String name;
  final double price;
  final String category;

  ProductModel({
    required this.id, 
    required this.name, 
    required this.price, 
    required this.category
  });

  // Μετατρέπει το αντικείμενο σε Map για τη βάση
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'category': category,
    };
  }

  // Δημιουργεί αντικείμενο από Map της βάσης
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      category: map['category'],
    );
  }
}
