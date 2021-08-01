class SkuModel {
  final DateTime created;
  final String id;
  final String product;
  final double price;
  final DateTime updated;

  SkuModel(
      {required this.created,
      required this.id,
      required this.product,
      required this.price,
      required this.updated});

  factory SkuModel.fromMap({required Map map}) {
    return SkuModel(
      created: DateTime.fromMillisecondsSinceEpoch(map['created'] * 1000),
      id: map['id'],
      product: map['product'],
      price: map['price'] / 100,
      updated: DateTime.fromMillisecondsSinceEpoch(map['updated'] * 1000),
    );
  }
}
