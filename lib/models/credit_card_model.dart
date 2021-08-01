class CreditCardModel {
  String id;
  String brand;
  String country;
  int expMonth;
  int expYear;
  String last4;

  CreditCardModel({
    required this.id,
    required this.brand,
    required this.country,
    required this.expMonth,
    required this.expYear,
    required this.last4,
  });
}
