part of 'checkout_bloc.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage() : super();

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage>
    with TickerProviderStateMixin, UIPropertiesMixin {
  // AnimationController animationController;
  // Animation<double> topBarAnimation;

  // List<Widget> listViews = [];
  // var scrollController = ScrollController();
  // double topBarOpacity = 0.0;

  // UserModel _currentUser;

  // bool loadCustomerInfoComplete = false;
  // bool addAllListDataComplete = false;

  // bool _isLoading = false;

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

  void addAllListData({required UserModel currentUser}) {
    // if (!addAllListDataComplete) {
    //   addAllListDataComplete = true;
    var count = 5;

    listViews.add(
      Padding(
        padding: EdgeInsets.fromLTRB(0, 30, 0, 40),
        child: PayFlowDiagramView(
          paymentComplete: false,
          shippingComplete: false,
          submitComplete: false,
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

    listViews.add(
      TitleView(
        showExtraOnTap: () {
          throw UnimplementedError();
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (_) {
          //     return EditShippingInfoPage();
          //   }),
          // );
        },
        showExtra: true,
        titleTxt: 'Shipping',
        subTxt: 'Edit',
        animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController,
            curve:
                Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: animationController,
      ),
    );

    if (currentUser.customer!.shipping == null) {
      listViews.add(
        TitleView(
          titleTxt: 'No Address Saved',
          animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: animationController,
              curve:
                  Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
          animationController: animationController,
          showExtra: false,
          subTxt: '',
        ),
      );
    } else {
      listViews.add(
        Padding(
          padding: EdgeInsets.all(10),
          child: DataBoxView(
            dataBoxChildren: [
              DataBoxChild(
                  iconData: Icons.location_on,
                  text: 'Address',
                  subtext: currentUser.customer!.shipping!.address.line1,
                  color: Colors.amber),
              DataBoxChild(
                  iconData: Icons.location_city,
                  text: 'City',
                  subtext: currentUser.customer!.shipping!.address.city,
                  color: Colors.amber),
              DataBoxChild(
                  iconData: Icons.my_location,
                  text: 'State',
                  subtext: currentUser.customer!.shipping!.address.state,
                  color: Colors.amber),
              DataBoxChild(
                  iconData: Icons.contact_mail,
                  text: 'ZIP',
                  subtext: currentUser.customer!.shipping!.address.postalCode,
                  color: Colors.amber)
            ],
            animation: Tween(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animationController,
                curve:
                    Interval((1 / count) * 3, 1.0, curve: Curves.fastOutSlowIn),
              ),
            ),
            animationController: animationController,
          ),
        ),
      );
    }

    if (currentUser.customer!.shipping != null) {
      listViews.add(
        Padding(
          padding: EdgeInsets.all(20),
          child: RoundButtonView(
            buttonColor: Colors.amber,
            text: 'CHOOSE PAYMENT',
            textColor: Colors.white,
            animation: Tween(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animationController,
                curve:
                    Interval((1 / count) * 3, 1.0, curve: Curves.fastOutSlowIn),
              ),
            ),
            animationController: animationController,
            onPressed: () {
              throw UnimplementedError();
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (_) {
              //     return CheckoutPaymentPage();
              //   }),
              // );
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: LitPicTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocConsumer<CheckoutBloc, CheckoutState>(
          builder: (context, state) {
            if (state is CheckoutLoadingState) {
              return Spinner();
            }

            if (state is CheckoutShippingState) {
              // final double subTotal = state.subTotal;
              // final double shippingFee = state.shippingFee;
              // final SkuModel sku = state.sku;
              // final List<CartItemModel> cartItems = state.cartItems;
              // final double total = state.total;

              addAllListData(
                currentUser: state.currentUser,
                // subTotal: subTotal,
                // shippingFee: shippingFee,
                // sku: sku,
                // cartItems: cartItems,
                // total: total,
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
                    goBackAction: () {
                      Navigator.of(context).pop();
                    },
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
