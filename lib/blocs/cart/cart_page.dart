part of 'cart_bloc.dart';

class CartPage extends StatefulWidget {
  const CartPage() : super();

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage>
    with TickerProviderStateMixin, UIPropertiesMixin {
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
    required List<CartItemModel> cartItems,
    required SkuModel sku,
    required double subTotal,
    required double shippingFee,
    required double total,
  }) async {
    listViews.clear();

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
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();

              prefs.setDouble('subTotal', subTotal);
              prefs.setDouble('shippingFee', shippingFee);
              prefs.setDouble('total', total);

              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (_) {
              //     return CheckoutShippingPage();
              //   }),
              // );

              Route route = MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => CHECKOUT_BP.CheckoutBloc()
                    ..add(
                      CHECKOUT_BP.LoadPageEvent(),
                    ),
                  child: CHECKOUT_BP.CheckoutPage(),
                ),
              );
              Navigator.push(context, route);
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
                  LitPicListViews(
                    listViews: listViews,
                    animationController: animationController,
                    scrollController: scrollController,
                  ),
                  LitPicAppBar(
                    title: 'Shopping Cart',
                    topBarOpacity: topBarOpacity,
                    animationController: animationController,
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
          listener: (context, state) {},
        ),
      ),
    );
  }
}
