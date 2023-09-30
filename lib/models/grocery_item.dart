class GroceryStoreItem {
  int? id;
  String? name;
  double? price;
  int? quantity;

  GroceryStoreItem({this.id, this.name, this.price, this.quantity});

  factory GroceryStoreItem.fromJson(Map<String, dynamic> json) {
    return GroceryStoreItem(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }
}
