import 'package:get_it/get_it.dart';

import 'package:litpic/services/auth_service.dart';
import 'package:litpic/services/db_service.dart';
import 'package:litpic/services/fcm_service.dart';
import 'package:litpic/services/formatter_service.dart';
import 'package:litpic/services/image_service.dart';
import 'package:litpic/services/modal_service.dart';
import 'package:litpic/services/storage_service.dart';
import 'package:litpic/services/stripe_card_service.dart';
import 'package:litpic/services/stripe_coupon_service.dart';
import 'package:litpic/services/stripe_customer_service.dart';
import 'package:litpic/services/stripe_order_service.dart';
import 'package:litpic/services/stripe_sku_service.dart';
import 'package:litpic/services/stripe_token_service.dart';
import 'package:litpic/services/validater_service.dart';
import 'services/fcm_service.dart';
import 'services/validater_service.dart';

GetIt locator = GetIt.I;

void setUpLocater() {
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => DBService());
  locator.registerLazySingleton(() => FCMService());
  locator.registerLazySingleton(() => FormatterService());
  locator.registerLazySingleton(() => ImageService());
  locator.registerLazySingleton(() => ModalService());
  locator.registerLazySingleton(() => StorageService());
  locator.registerLazySingleton(() => StripeCardService());
  locator.registerLazySingleton(() => StripeCustomerService());
  locator.registerLazySingleton(() => StripeCouponService());
  locator.registerLazySingleton(() => StripeOrderService());
  locator.registerLazySingleton(() => StripeSkuService());
  locator.registerLazySingleton(() => StripeTokenService());
  locator.registerLazySingleton(() => ValidatorService());
}
