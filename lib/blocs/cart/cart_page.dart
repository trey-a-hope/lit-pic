part of 'cart_bloc.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with TickerProviderStateMixin {
  Animation<double> topBarAnimation;
  AnimationController animationController;
  List<Widget> listViews = [];
  ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  @override
  void initState() {
    animationController =
        AnimationController(duration: Duration(milliseconds: 600), vsync: this);

    topBarAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn),
      ),
    );

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  void addAllListData({
    @required List<CartItemModel> cartItems,
    @required SkuModel sku,
    @required double subTotal,
    @required double shippingFee,
    @required double total,
  }) async {
    listViews.clear();
    // if (!addAllListDataComplete) {
    //   addAllListDataComplete = true;

    var count = 1;

    if (cartItems.isEmpty) {
      listViews.add(
        TitleView(
          showExtra: false,
          titleTxt: 'Your cart is empty boss.',
          subTxt: 'Shop',
          animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: animationController,
              curve:
                  Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
          animationController: animationController,
        ),
      );
    } else {
      for (int i = 0; i < cartItems.length; i++) {
        CartItemModel cartItem = cartItems[i];
        listViews.add(
          Padding(
            padding: EdgeInsets.all(10),
            child: CartItemView(
              price: sku.price,
              delete: () async {
                bool confirm = await locator<ModalService>().showConfirmation(
                  context: context,
                  title: 'Remove Item From Cart',
                  message: 'Are you sure.',
                );

                if (!confirm) return;

                context.read<CartBloc>().add(
                      DeleteCartItemEvent(cartItem: cartItem),
                    );
              },
              cartItem: cartItems[i],
              animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                  parent: animationController,
                  curve: Interval((1 / count) * 0, 1.0,
                      curve: Curves.fastOutSlowIn))),
              animationController: animationController,
              increment: () {
                context.read<CartBloc>().add(
                      IncrementQuantityEvent(cartItem: cartItem),
                    );
              },
              decrement: () {
                if (cartItem.quantity == 1) return;

                context.read<CartBloc>().add(
                      DecrementQuantityEvent(cartItem: cartItem),
                    );
              },
            ),
          ),
        );
      }
      listViews.add(Divider());

      listViews.add(
        Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Sub total',
              ),
              Text(locator<FormatterService>().money(amount: subTotal),
                  style: TextStyle(fontWeight: FontWeight.bold))
            ],
          ),
        ),
      );

      listViews.add(
        Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Shipping',
              ),
              Text(locator<FormatterService>().money(amount: shippingFee),
                  style: TextStyle(fontWeight: FontWeight.bold))
            ],
          ),
        ),
      );

      listViews.add(Divider());

      TextStyle orderTotalStyle = TextStyle(
          fontWeight: FontWeight.bold, color: Colors.green, fontSize: 20);
      listViews.add(
        Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Order Total',
                style: orderTotalStyle,
              ),
              Text(
                locator<FormatterService>().money(amount: total),
                style: orderTotalStyle,
              )
            ],
          ),
        ),
      );

      listViews.add(Divider());

      listViews.add(
        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: RoundButtonView(
            text: 'PROCEED TO CHECKOUT',
            buttonColor: Colors.amber,
            onPressed: () {
              // prefs.setDouble('subTotal', subTotal);
              // prefs.setDouble('shippingFee', shippingFee);
              // prefs.setDouble('total', total);

              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (_) {
              //     return CheckoutShippingPage();
              //   }),
              // );
            },
            textColor: Colors.white,
            animation: Tween(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animationController,
                curve:
                    Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn),
              ),
            ),
            animationController: animationController,
          ),
        ),
      );
    }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: LitPicTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocConsumer<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoadingState) {
              return Spinner();
            }

            if (state is CartLoadedState) {
              final double subTotal = state.subTotal;
              final double shippingFee = state.shippingFee;
              final SkuModel sku = state.sku;
              final List<CartItemModel> cartItems = state.cartItems;
              final double total = state.total;

              addAllListData(
                subTotal: subTotal,
                shippingFee: shippingFee,
                sku: sku,
                cartItems: cartItems,
                total: total,
              );
              return Stack(
                children: <Widget>[
                  ListView.builder(
                    controller: scrollController,
                    padding: EdgeInsets.only(
                      top: AppBar().preferredSize.height +
                          MediaQuery.of(context).padding.top +
                          24,
                      bottom: 62 + MediaQuery.of(context).padding.bottom,
                    ),
                    itemCount: listViews.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      animationController.forward();
                      return listViews[index];
                    },
                  ),
                  Column(
                    children: <Widget>[
                      AnimatedBuilder(
                        animation: animationController,
                        builder: (BuildContext context, Widget child) {
                          return FadeTransition(
                            opacity: topBarAnimation,
                            child: Transform(
                              transform: Matrix4.translationValues(
                                  0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: LitPicTheme.white
                                      .withOpacity(topBarOpacity),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(32.0),
                                  ),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: LitPicTheme.grey
                                            .withOpacity(0.4 * topBarOpacity),
                                        offset: Offset(1.1, 1.1),
                                        blurRadius: 10.0),
                                  ],
                                ),
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).padding.top,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          top: 16 - 8.0 * topBarOpacity,
                                          bottom: 12 - 8.0 * topBarOpacity),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Shopping Cart",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontFamily:
                                                      LitPicTheme.fontName,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 22 +
                                                      6 -
                                                      6 * topBarOpacity,
                                                  letterSpacing: 1.2,
                                                  color: LitPicTheme.darkerText,
                                                ),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              context
                                                  .read<CartBloc>()
                                                  .add(RefreshEvent());
                                            },
                                            icon: Icon(Icons.refresh),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).padding.bottom,
                  )
                ],
              );
            }

            if (state is ErrorState) {
              final dynamic error = state.error;
              return Center(
                child: Text(error.toString()),
              );
            }

            return Container();
          },
          listener: (context, state) {
            // if (state is CreateLithophaneLoadedState) {
            //   final bool imageUploaded = state.imageUploaded;
            //   if (imageUploaded) {
            //     _image = null;
            //     locator<ModalService>().showAlert(
            //       context: context,
            //       title: 'Got It',
            //       message: 'This item has been added to your shopping cart.',
            //     );
            //   }
            // }
          },
        ),
        // body: Stack(
        //   children: <Widget>[
        //     getMainListViewUI(),
        //     getAppBarUI(),
        //     SizedBox(
        //       height: MediaQuery.of(context).padding.bottom,
        //     )
        //   ],
        // ),
      ),
    );
  }

  _deleteCartItem({@required CartItemModel cartItem}) async {
    // bool confirm = await locator<ModalService>().showConfirmation(
    //     context: context,
    //     title: 'Remove Item From Cart',
    //     message: 'Are you sure.');
    // if (confirm) {
    //   setState(() {
    //     _isLoading = true;
    //   });

    //   //Remove cart item from database.
    //   await locator<CartItemService>()
    //       .deleteCartItem(uid: _currentUser.uid, cartItemID: cartItem.id);

    //   //Remove image of cart item from storage.
    //   await locator<StorageService>().deleteImage(imgPath: cartItem.imgPath);

    //   //Refresh cart data.
    //   fetchCartItemsComplete = false;
    //   await fetchCartItems();

    //   //Rerun total calculations.
    //   calculateTotalsComplete = false;
    //   calculateTotals();

    //   //Re add views with data.
    //   addAllListDataComplete = false;
    //   addAllListData();

    //   //
    //   setState(() {
    //     _isLoading = false;
    //   });
    // }
  }
}
