class DisplayItemModel {
  final double amount;
  final String currency;
  final int quantity;
  final String type;
  final CustomModel custom;

  DisplayItemModel({
    required this.amount,
    required this.currency,
    required this.quantity,
    required this.type,
    required this.custom,
  });

  factory DisplayItemModel.fromMap({required Map map}) {
    return DisplayItemModel(
      amount: (map['amount'] / 100) as double,
      currency: map['currency'],
      quantity: map['quantity'],
      type: map['type'],
      custom: CustomModel.fromMap(
        map: map['custom'],
      ),
    );
  }
}

class CustomModel {
  final String description;
  final String name;
  final List<dynamic> images;

  CustomModel({
    required this.description,
    required this.name,
    required this.images,
  });

  factory CustomModel.fromMap({required Map map}) {
    return CustomModel(
      description: map['description'],
      name: map['name'],
      images: map['images'] as List<dynamic>,
    );
  }
}
