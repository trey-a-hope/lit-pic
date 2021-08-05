class PriceModel {
  final String id;
  final DateTime created;
  final double unitAmount;
  final String product;

  PriceModel({
    required this.id,
    required this.unitAmount,
    required this.created,
    required this.product,
  });

  factory PriceModel.fromMap({required Map map}) {
    return PriceModel(
      product: map['product'],
      created: DateTime.fromMillisecondsSinceEpoch(map['created'] * 1000),
      id: map['id'],
      unitAmount: (map['unit_amount'] / 100) as double,
    );
  }
}
