import 'package:litpic/constants.dart';

class SessionModel {
  final String? id;
  final List<Map>? lineItems;
  final String? url;
  final String successUrl;
  final String cancelUrl;
  final String customer;
  final String? paymentStatus;

  SessionModel({
    this.id,
    this.lineItems,
    this.url,
    this.successUrl = STRIPE_SUCCESS_URL,
    this.cancelUrl = STRIPE_CANCEL_URL,
    required this.customer,
    this.paymentStatus,
  });

  factory SessionModel.fromMap({required Map map}) {
    return SessionModel(
      id: map['id'],
      lineItems: null,
      url: map['url'],
      customer: map['customer'],
      paymentStatus: map['payment_status'],
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};

    if (id != null) {
      map['id'] = id;
    }

    // if (lineItems != null) {
    //   map['line_items'] = lineItems;
    // }

    //TODO: Add these line items once they hit proceed to checkout...

    map['line_items'] = [
      {
        'name': 'Image 1',
        'description': 'Colored 3D-Printed Lithophane.',
        // 'price': 'price_1JKcEpGQvSy9RLmzKGyqcqy1',
        'amount': 999,
        'currency': 'usd',
        'quantity': 2,
        'images': [
          'https://firebasestorage.googleapis.com:443/v0/b/litpic-f293c.appspot.com/o/Users%2F5ztYxwc2L9ZbM8UCDRnVmGC1J6N2%2FOrders%2Fc186d850-f6dc-11eb-927e-4197b2747993?alt=media&token=3c996d4f-c118-4d73-b4b5-dde9235596a4',
        ],
      },
      {
        'name': 'Image 2',
        'description': 'Colored 3D-Printed Lithophane.',
        // 'price': 'price_1JKcEpGQvSy9RLmzKGyqcqy1',
        'amount': 999,
        'currency': 'usd',
        'quantity': 3,
        'images': [
          'https://firebasestorage.googleapis.com:443/v0/b/litpic-f293c.appspot.com/o/Users%2F5ztYxwc2L9ZbM8UCDRnVmGC1J6N2%2FOrders%2F8e314580-f8a8-11eb-aa59-3184c6cbcbe9?alt=media&token=504db277-d057-4cba-9048-ab3a5a84e8a5',
        ],
      },
    ];

    if (url != null) {
      map['url'] = url;
    }

    map['success_url'] = successUrl;
    map['cancel_url'] = cancelUrl;
    map['customer'] = customer;

    return map;
  }
}
