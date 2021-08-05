class ProductModel {
  final String id;
  final String name;
  final String description;
  final DateTime created;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.created,
  });

  factory ProductModel.fromMap({required Map map}) {
    return ProductModel(
      description: map['description'],
      created: DateTime.fromMillisecondsSinceEpoch(map['created'] * 1000),
      id: map['id'],
      name: map['name'],
    );
  }
}
