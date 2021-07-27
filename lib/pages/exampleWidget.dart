// import 'package:flutter/material.dart';
// import 'package:litpic/common/good_button.dart';
// import 'package:litpic/litpic_theme.dart';

// class ExampleWidget extends StatefulWidget {
//   ExampleWidget({Key key}) : super(key: key);

//   @override
//   ExampleWidgetState createState() => ExampleWidgetState();
// }

// class ExampleWidgetState extends State<ExampleWidget>
//     with SingleTickerProviderStateMixin {
//   final TextStyle orderTextStyle =
//       TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 20);
//   final SizedBox verticalPadding = SizedBox(
//     height: 20,
//   );
//   final TextStyle textBold = TextStyle(fontWeight: FontWeight.bold);
//   final String img1Url =
//       'https://firebasestorage.googleapis.com/v0/b/litpic-f293c.appspot.com/o/Users%2F6XKNQczVxE0MsAmybrSU%2FOrders%2F9e417550-156d-11ea-996d-0d106d6e604e?alt=media&token=c3bc6173-1922-46ab-81e0-043b0f93c658';
//   final String img2Url =
//       'https://firebasestorage.googleapis.com/v0/b/litpic-f293c.appspot.com/o/Users%2F6XKNQczVxE0MsAmybrSU%2FOrders%2F92e19a80-124a-11ea-bf75-cd730b84d2a1?alt=media&token=b335bcc3-1761-49ef-9fea-c7e2745a46a9';

//   @override
//   void initState() {
//     super.initState();
//   }

//   Widget buildCartView(
//       {@required String imgUrl,
//       @required String name,
//       @required String price}) {
//     return SizedBox(
//       height: 170,
//       child: Stack(
//         children: <Widget>[
//           Container(
//             child: Row(
//               children: <Widget>[
//                 SizedBox(
//                   width: 48,
//                 ),
//                 Expanded(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade300,
//                       borderRadius: BorderRadius.all(Radius.circular(16.0)),
//                     ),
//                     child: Row(
//                       children: <Widget>[
//                         SizedBox(
//                           width: 72,
//                         ),
//                         Expanded(
//                           child: Container(
//                             child: Column(
//                               children: <Widget>[
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 16),
//                                   child: Row(
//                                     children: <Widget>[
//                                       Text(
//                                         name,
//                                         textAlign: TextAlign.left,
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.w600,
//                                           fontSize: 16,
//                                           letterSpacing: 0.27,
//                                           color: LitPicTheme.darkerText,
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(
//                                       right: 16, bottom: 8),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: <Widget>[
//                                       Text(
//                                         "Quanity: 1",
//                                         textAlign: TextAlign.left,
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.w200,
//                                           fontSize: 12,
//                                           letterSpacing: 0.27,
//                                           color: LitPicTheme.grey,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(
//                                       bottom: 8, right: 16),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: <Widget>[
//                                       Text(
//                                         price,
//                                         textAlign: TextAlign.left,
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.w600,
//                                           fontSize: 18,
//                                           letterSpacing: 0.27,
//                                           color: LitPicTheme.nearlyBlue,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Container(
//                                   height: 50,
//                                   width: 170,
//                                   decoration: BoxDecoration(
//                                     color: LitPicTheme.nearlyBlue,
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(8.0)),
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(4.0),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceEvenly,
//                                       children: <Widget>[
//                                         Icon(
//                                           Icons.add,
//                                           color: Colors.white,
//                                         ),
//                                         Icon(
//                                           Icons.remove,
//                                           color: Colors.white,
//                                         ),
//                                         Icon(
//                                           Icons.delete,
//                                           color: Colors.white,
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Container(
//             height: 140,
//             child: Padding(
//               padding: const EdgeInsets.only(top: 24, bottom: 24, left: 16),
//               child: Row(
//                 children: <Widget>[
//                   ClipRRect(
//                     borderRadius: BorderRadius.all(Radius.circular(16.0)),
//                     child: AspectRatio(
//                       aspectRatio: 1.0,
//                       child: Image.network(imgUrl),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.all(MediaQuery.of(context).padding.top),
//         child: Column(
//           children: <Widget>[
//             verticalPadding,
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Text(
//                   "Shopping Cart",
//                   textAlign: TextAlign.left,
//                   style: TextStyle(
//                     fontFamily: LitPicTheme.fontName,
//                     fontWeight: FontWeight.w700,
//                     fontSize: 30,
//                     letterSpacing: 1.2,
//                     color: LitPicTheme.darkerText,
//                   ),
//                 ),
//                 Icon(Icons.refresh)
//               ],
//             ),
//             verticalPadding,
//             verticalPadding,
//             buildCartView(
//                 imgUrl: img1Url, name: 'Purple Flowers', price: '\$24.99'),
//             verticalPadding,
//             buildCartView(
//                 imgUrl: img2Url, name: 'Yellow Leaf', price: '\$34.99'),
//             verticalPadding,
//             Spacer(),
//             Divider(),
//             verticalPadding,
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Text(
//                   'Sub total',
//                 ),
//                 Text('\$69.98', style: textBold)
//               ],
//             ),
//             verticalPadding,
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Text(
//                   'Shipping',
//                 ),
//                 Text('\$5.00', style: textBold)
//               ],
//             ),
//             verticalPadding,
//             Divider(),
//             verticalPadding,
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Text('Order Total', style: orderTextStyle),
//                 Text(
//                   '\$74.98',
//                   style: orderTextStyle,
//                 )
//               ],
//             ),
//             verticalPadding,
//             GoodButton(
//                 text: 'PROCEED TO CHECKOUT',
//                 buttonColor: Colors.purple,
//                 onPressed: () {},
//                 textColor: Colors.white),
//           ],
//         ),
//       ),
//     );
//   }
// }
