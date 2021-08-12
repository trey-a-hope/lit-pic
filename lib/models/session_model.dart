import 'package:litpic/constants.dart';
import 'package:litpic/models/display_item_model.dart';
import 'package:litpic/models/payment_intent_model.dart';

class SessionModel {
  final String? id;
  final List<Map>? lineItems;
  final String? url;
  final String successUrl;
  final String cancelUrl;
  final String customer;
  final String? paymentStatus;
  final List<DisplayItemModel>? displayItems;
  final String? paymentIntentID;
  final PaymentIntentModel? paymentIntent;

  SessionModel({
    this.id,
    this.lineItems,
    this.url,
    this.successUrl = STRIPE_SUCCESS_URL,
    this.cancelUrl = STRIPE_CANCEL_URL,
    required this.customer,
    this.paymentStatus,
    this.displayItems,
    this.paymentIntentID,
    this.paymentIntent,
  });

  factory SessionModel.fromMap({required Map map}) {
    return SessionModel(
      id: map['id'],
      lineItems: null,
      url: map['url'],
      customer: map['customer'],
      paymentStatus: map['payment_status'],
      displayItems: (map['display_items'] as List)
          .map((e) => DisplayItemModel.fromMap(map: e))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};

    if (id != null) {
      map['id'] = id;
    }

    if (lineItems != null) {
      map['line_items'] = lineItems;
    }

    if (url != null) {
      map['url'] = url;
    }

    map['success_url'] = successUrl;
    map['cancel_url'] = cancelUrl;
    map['customer'] = customer;

    return map;
  }
}
