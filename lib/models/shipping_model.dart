import 'package:litpic/models/address_model.dart';

class ShippingModel {
  final String name;
  final AddressModel address;

  ShippingModel({required this.name, required this.address});

  factory ShippingModel.fromMap({required Map map}) {
    return ShippingModel(
      name: map['name'],
      address: AddressModel.fromMap(
        map: map['address'],
      ),
    );
  }
}
