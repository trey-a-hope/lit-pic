// part of 'checkout_bloc.dart';

// class CheckoutPage extends StatefulWidget {
//   const CheckoutPage() : super();

//   @override
//   _CheckoutPageState createState() => _CheckoutPageState();
// }

// class _CheckoutPageState extends State<CheckoutPage>
//     with TickerProviderStateMixin, UIPropertiesMixin {
//   @override
//   void initState() {
//     animationController =
//         AnimationController(duration: Duration(milliseconds: 600), vsync: this);

//     topBarAnimation = Tween(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: animationController,
//         curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn),
//       ),
//     );

//     scrollController.addListener(() {
//       if (scrollController.offset >= 24) {
//         if (topBarOpacity != 1.0) {
//           setState(() {
//             topBarOpacity = 1.0;
//           });
//         }
//       } else if (scrollController.offset <= 24 &&
//           scrollController.offset >= 0) {
//         if (topBarOpacity != scrollController.offset / 24) {
//           setState(() {
//             topBarOpacity = scrollController.offset / 24;
//           });
//         }
//       } else if (scrollController.offset <= 0) {
//         if (topBarOpacity != 0.0) {
//           setState(() {
//             topBarOpacity = 0.0;
//           });
//         }
//       }
//     });
//     super.initState();
//   }

//   void addShippingListData({required UserModel currentUser}) {
//     var count = 5;
//     listViews.add(
//       Padding(
//         padding: EdgeInsets.fromLTRB(0, 30, 0, 40),
//         child: PayFlowDiagramView(
//           currentStep: 0,
//         ),
//       ),
//     );

//     if (currentUser.customer!.shipping != null) {
//       listViews.add(
//         Padding(
//           padding: EdgeInsets.all(20),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               ElevatedButton(
//                 onPressed: () {
//                   context.read<CheckoutBloc>().add(NextStepEvent());
//                 },
//                 child: Text('NEXT'),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     listViews.add(
//       TitleView(
//         showExtraOnTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) {
//               return EditShippingInfoPage();
//             }),
//           );
//         },
//         showExtra: true,
//         titleTxt: 'Shipping',
//         subTxt: 'Edit',
//         animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
//             parent: animationController,
//             curve:
//                 Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
//         animationController: animationController,
//       ),
//     );

//     if (currentUser.customer!.shipping == null) {
//       listViews.add(
//         TitleView(
//           titleTxt: 'No Address Saved',
//           animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
//               parent: animationController,
//               curve:
//                   Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
//           animationController: animationController,
//           showExtra: false,
//           subTxt: '',
//         ),
//       );
//     } else {
//       listViews.add(
//         Padding(
//           padding: EdgeInsets.all(10),
//           child: DataBoxView(
//             dataBoxChildren: [
//               DataBoxChild(
//                   iconData: Icons.location_on,
//                   text: 'Address',
//                   subtext: currentUser.customer!.shipping!.address.line1,
//                   color: Colors.amber),
//               DataBoxChild(
//                   iconData: Icons.location_city,
//                   text: 'City',
//                   subtext: currentUser.customer!.shipping!.address.city,
//                   color: Colors.amber),
//               DataBoxChild(
//                   iconData: Icons.my_location,
//                   text: 'State',
//                   subtext: currentUser.customer!.shipping!.address.state,
//                   color: Colors.amber),
//               DataBoxChild(
//                   iconData: Icons.contact_mail,
//                   text: 'ZIP',
//                   subtext: currentUser.customer!.shipping!.address.postalCode,
//                   color: Colors.amber)
//             ],
//             animation: Tween(begin: 0.0, end: 1.0).animate(
//               CurvedAnimation(
//                 parent: animationController,
//                 curve:
//                     Interval((1 / count) * 3, 1.0, curve: Curves.fastOutSlowIn),
//               ),
//             ),
//             animationController: animationController,
//           ),
//         ),
//       );
//     }
//   }

//   void addPaymentListData({required UserModel currentUser}) {
//     var count = 5;
//     listViews.add(
//       Padding(
//         padding: EdgeInsets.fromLTRB(0, 30, 0, 40),
//         child: PayFlowDiagramView(
//           currentStep: 1,
//         ),
//       ),
//     );

//     if (currentUser.customer!.sources.isNotEmpty) {
//       listViews.add(
//         Padding(
//           padding: EdgeInsets.all(20),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               ElevatedButton(
//                 onPressed: () {
//                   context.read<CheckoutBloc>().add(PreviousStepEvent());
//                 },
//                 child: Text('PREVIOUS'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   context.read<CheckoutBloc>().add(NextStepEvent());
//                 },
//                 child: Text('NEXT'),
//               ),
//             ],
//           ),
//         ),
//       );
//     } else {
//       listViews.add(
//         Padding(
//           padding: EdgeInsets.all(20),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               ElevatedButton(
//                 onPressed: () {
//                   context.read<CheckoutBloc>().add(PreviousStepEvent());
//                 },
//                 child: Text('PREVIOUS'),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     listViews.add(
//       TitleView(
//         showExtraOnTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) {
//               return SavedCardsPage();
//             }),
//           );
//         },
//         showExtra: true,
//         titleTxt: 'Payment',
//         subTxt: 'Edit',
//         animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
//             parent: animationController,
//             curve:
//                 Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
//         animationController: animationController,
//       ),
//     );

//     if (currentUser.customer!.sources.isEmpty) {
//       listViews.add(
//         TitleView(
//           titleTxt: 'No Saved Cards',
//           animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
//               parent: animationController,
//               curve:
//                   Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
//           animationController: animationController,
//           showExtra: false,
//           subTxt: '',
//         ),
//       );
//     } else {
//       CreditCardModel creditCard = currentUser.customer!.card!;
//       listViews.add(
//         CreditCardView(
//           deleteCard: () async {
//             locator<ModalService>().showAlert(
//                 context: context,
//                 title: 'Error',
//                 message: 'Click edit to make changes to this card.');
//           },
//           makeDefaultCard: () async {
//             locator<ModalService>().showAlert(
//                 context: context,
//                 title: 'Error',
//                 message: 'Click edit to make changes to this card.');
//           },
//           isDefault: true,
//           creditCard: creditCard,
//           animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
//               parent: animationController,
//               curve:
//                   Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
//           animationController: animationController,
//         ),
//       );
//     }
//   }

//   void addSubmitListData({
//     required UserModel currentUser,
//     required List<CartItemModel> cartItems,
//     required SkuModel sku,
//     required double subTotal,
//     required double shippingFee,
//     required double total,
//   }) {
//     var count = 5;
//     listViews.add(
//       Padding(
//         padding: EdgeInsets.fromLTRB(0, 30, 0, 40),
//         child: PayFlowDiagramView(
//           currentStep: 2,
//         ),
//       ),
//     );

//     if (currentUser.customer!.sources.isNotEmpty) {
//       listViews.add(
//         Padding(
//           padding: EdgeInsets.all(20),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               ElevatedButton(
//                 onPressed: () {
//                   context.read<CheckoutBloc>().add(PreviousStepEvent());
//                 },
//                 child: Text('PREVIOUS'),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//     for (int i = 0; i < cartItems.length; i++) {
//       listViews.add(
//         Padding(
//           padding: EdgeInsets.all(10),
//           child: CartItemBoughtView(
//             price: sku.price,
//             cartItem: cartItems[i],
//             animation: Tween(begin: 0.0, end: 1.0).animate(
//               CurvedAnimation(
//                 parent: animationController,
//                 curve:
//                     Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn),
//               ),
//             ),
//             animationController: animationController,
//           ),
//         ),
//       );
//     }

//     listViews.add(Divider());

//     listViews.add(
//       Padding(
//         padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Text(
//               'Shipping To',
//             ),
//             Text(
//               '${currentUser.customer!.name}\n${currentUser.customer!.shipping!.address.line1}\n${currentUser.customer!.shipping!.address.city}, ${currentUser.customer!.shipping!.address.state} ${currentUser.customer!.shipping!.address.postalCode}',
//               textAlign: TextAlign.end,
//               style: TextStyle(fontWeight: FontWeight.bold),
//             )
//           ],
//         ),
//       ),
//     );

//     listViews.add(
//       Padding(
//         padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Text(
//               'Paying w/ Card',
//             ),
//             Text(
//               '${currentUser.customer!.card!.brand} - ${currentUser.customer!.card!.last4}',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             )
//           ],
//         ),
//       ),
//     );
//     listViews.add(Divider());

//     listViews.add(
//       Padding(
//         padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Text(
//               'Sub total',
//             ),
//             Text(
//               locator<FormatterService>().money(amount: subTotal),
//               style: TextStyle(fontWeight: FontWeight.bold),
//             )
//           ],
//         ),
//       ),
//     );

//     listViews.add(
//       Padding(
//         padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Text(
//               'Shipping',
//             ),
//             Text(locator<FormatterService>().money(amount: shippingFee),
//                 style: TextStyle(fontWeight: FontWeight.bold))
//           ],
//         ),
//       ),
//     );

//     listViews.add(
//       Divider(),
//     );

//     TextStyle orderTotalStyle = TextStyle(
//         fontWeight: FontWeight.bold,
//         color: LitPicTheme.nearlyDarkBlue,
//         fontSize: 20);
//     listViews.add(
//       Padding(
//         padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Text(
//               'Order Total',
//               style: orderTotalStyle,
//             ),
//             Text(
//               locator<FormatterService>().money(amount: total),
//               style: orderTotalStyle,
//             )
//           ],
//         ),
//       ),
//     );

//     listViews.add(Divider());

//     listViews.add(
//       Padding(
//         padding: EdgeInsets.all(20),
//         child: RoundButtonView(
//           buttonColor: Colors.amber,
//           text: 'SUBMIT PAYMENT',
//           textColor: Colors.white,
//           animation: Tween(begin: 0.0, end: 1.0).animate(
//             CurvedAnimation(
//               parent: animationController,
//               curve:
//                   Interval((1 / count) * 3, 1.0, curve: Curves.fastOutSlowIn),
//             ),
//           ),
//           animationController: animationController,
//           onPressed: () async {
//             bool confirm = await locator<ModalService>().showConfirmation(
//                 context: context,
//                 title: 'Submit Order',
//                 message: 'Are you sure?');

//             if (confirm) context.read<CheckoutBloc>().add(SubmitEvent());
//           },
//         ),
//       ),
//     );
//   }

//   void addSuccessListData({required UserModel currentUser}) {
//     listViews.add(
//       Padding(
//         padding: EdgeInsets.fromLTRB(0, 30, 0, 40),
//         child: PayFlowDiagramView(
//           currentStep: 3,
//         ),
//       ),
//     );
//     listViews.add(
//       Padding(
//         padding: EdgeInsets.all(20),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('DONE'),
//             ),
//           ],
//         ),
//       ),
//     );

//     listViews.add(
//       Column(
//         children: [
//           Icon(
//             Icons.check,
//             color: LitPicTheme.nearlyDarkBlue,
//             size: 150,
//           ),
//           Text('Order Submitted'),
//           Text('Your order will be ready within 3 business days.',
//               style: TextStyle(fontSize: 12))
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: LitPicTheme.background,
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: BlocConsumer<CheckoutBloc, CheckoutState>(
//           builder: (context, state) {
//             listViews = [];

//             if (state is CheckoutLoadingState) {
//               return Spinner();
//             }

//             if (state is CheckoutShippingState) {
//               addShippingListData(
//                 currentUser: state.currentUser,
//               );

//               return Stack(
//                 children: <Widget>[
//                   LitPicListViews(
//                     listViews: listViews,
//                     animationController: animationController,
//                     scrollController: scrollController,
//                   ),
//                   LitPicAppBar(
//                     title: 'Shopping Cart',
//                     topBarOpacity: topBarOpacity,
//                     animationController: animationController,
//                     goBackAction: () {
//                       Navigator.of(context).pop();
//                     },
//                     secondaryActionButton: IconButton(
//                       onPressed: () {
//                         context.read<CheckoutBloc>().add(
//                               RefreshEvent(),
//                             );
//                       },
//                       icon: Icon(Icons.refresh),
//                     ),
//                   ),
//                   SizedBox(
//                     height: MediaQuery.of(context).padding.bottom,
//                   )
//                 ],
//               );
//             }

//             if (state is CheckoutPaymentState) {
//               addPaymentListData(
//                 currentUser: state.currentUser,
//               );

//               return Stack(
//                 children: <Widget>[
//                   LitPicListViews(
//                     listViews: listViews,
//                     animationController: animationController,
//                     scrollController: scrollController,
//                   ),
//                   LitPicAppBar(
//                     title: 'Shopping Cart',
//                     topBarOpacity: topBarOpacity,
//                     animationController: animationController,
//                     goBackAction: () {
//                       Navigator.of(context).pop();
//                     },
//                     secondaryActionButton: IconButton(
//                       onPressed: () {
//                         context.read<CheckoutBloc>().add(
//                               RefreshEvent(),
//                             );
//                       },
//                       icon: Icon(Icons.refresh),
//                     ),
//                   ),
//                   SizedBox(
//                     height: MediaQuery.of(context).padding.bottom,
//                   )
//                 ],
//               );
//             }

//             if (state is CheckoutSubmitState) {
//               final double subTotal = state.subTotal;
//               final double shippingFee = state.shippingFee;
//               final SkuModel sku = state.sku;
//               final List<CartItemModel> cartItems = state.cartItems;
//               final double total = state.total;

//               addSubmitListData(
//                 currentUser: state.currentUser,
//                 subTotal: subTotal,
//                 shippingFee: shippingFee,
//                 sku: sku,
//                 cartItems: cartItems,
//                 total: total,
//               );

//               return Stack(
//                 children: <Widget>[
//                   LitPicListViews(
//                     listViews: listViews,
//                     animationController: animationController,
//                     scrollController: scrollController,
//                   ),
//                   LitPicAppBar(
//                     title: 'Shopping Cart',
//                     topBarOpacity: topBarOpacity,
//                     animationController: animationController,
//                     goBackAction: () {
//                       Navigator.of(context).pop();
//                     },
//                     secondaryActionButton: IconButton(
//                       onPressed: () {
//                         context.read<CheckoutBloc>().add(
//                               RefreshEvent(),
//                             );
//                       },
//                       icon: Icon(Icons.refresh),
//                     ),
//                   ),
//                   SizedBox(
//                     height: MediaQuery.of(context).padding.bottom,
//                   )
//                 ],
//               );
//             }

//             if (state is CheckoutSuccessState) {
//               addSuccessListData(
//                 currentUser: state.currentUser,
//               );

//               return Stack(
//                 children: <Widget>[
//                   LitPicListViews(
//                     listViews: listViews,
//                     animationController: animationController,
//                     scrollController: scrollController,
//                   ),
//                   LitPicAppBar(
//                     title: 'Shopping Cart',
//                     topBarOpacity: topBarOpacity,
//                     animationController: animationController,
//                     goBackAction: () {
//                       Navigator.of(context).pop();
//                     },
//                     secondaryActionButton: IconButton(
//                       onPressed: () {
//                         context.read<CheckoutBloc>().add(
//                               RefreshEvent(),
//                             );
//                       },
//                       icon: Icon(Icons.refresh),
//                     ),
//                   ),
//                   SizedBox(
//                     height: MediaQuery.of(context).padding.bottom,
//                   )
//                 ],
//               );
//             }

//             if (state is ErrorState) {
//               final dynamic error = state.error;
//               return Center(
//                 child: Text(error.toString()),
//               );
//             }

//             return Container();
//           },
//           listener: (context, state) {},
//         ),
//       ),
//     );
//   }
// }
