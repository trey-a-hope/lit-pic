import 'package:flutter/material.dart';

const String GCF_ENDPOINT =
    'https://us-central1-litpic-f293c.cloudfunctions.net/';

const String timeFormat = 'MMM d, yyyy @ h:mm a';

// const String SKU_UD = 'sku_GATEGxr1FwZMJQ';
const String PRODUCT_ID = 'prod_JyZNMebQ8eAizv';
const String PRICE_ID = 'price_1JKcEpGQvSy9RLmzKGyqcqy1';
const String ADMIN_DOC_ID = 'mBdXABiOqyWdnDu7iiZACTV4bGH2';

const String STRIPE_SUCCESS_URL =
    'https://litpic-f293c.web.app/payment-success';
const String STRIPE_CANCEL_URL = 'https://litpic-f293c.web.app/payment-cancel';

//These are set in main().
late String version;
late String buildNumber;
late double screenWidth;
late double screenHeight;

class TabIconData {
  Icon unselectedIcon;
  Icon selectedIcon;
  bool isSelected;
  int index;
  AnimationController animationController;

  TabIconData({
    this.index = 0,
    required this.unselectedIcon,
    required this.selectedIcon,
    this.isSelected = false,
    required this.animationController,
  });
}

final List<String> months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

final List<String> unitedStates = [
  'AK',
  'AL',
  'AR',
  'AS',
  'AZ',
  'CA',
  'CO',
  'CT',
  'DC',
  'DE',
  'FL',
  'GA',
  'GU',
  'HI',
  'IA',
  'ID',
  'IL',
  'IN',
  'KS',
  'KY',
  'LA',
  'MA',
  'MD',
  'ME',
  'MI',
  'MN',
  'MO',
  'MS',
  'MT',
  'NC',
  'ND',
  'NE',
  'NH',
  'NJ',
  'NM',
  'NV',
  'NY',
  'OH',
  'OK',
  'OR',
  'PA',
  'PR',
  'RI',
  'SC',
  'SD',
  'TN',
  'TX',
  'UT',
  'VA',
  'VI',
  'VT',
  'WA',
  'WI',
  'WV',
  'WY'
];

class ColorName {
  final String name;
  final Color color;

  ColorName({required this.name, required this.color});
}
