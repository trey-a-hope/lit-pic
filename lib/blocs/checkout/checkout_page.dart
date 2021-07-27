part of 'checkout_bloc.dart';

 

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key key}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage>
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

  void _addAllListData({@required SkuModel sku, @required int quantity}) {
    var count = 9;
    listViews.clear();

    // listViews.add(
    //   GestureDetector(
    //     onTap: () {
    //       _showSelectImageDialog();
    //     },
    //     child: Container(
    //       height: screenWidth,
    //       width: screenWidth,
    //       color: Colors.grey[300],
    //       child: _image == null
    //           ? Icon(
    //               Icons.add_a_photo,
    //               color: Colors.white70,
    //               size: 150,
    //             )
    //           : Image(
    //               image: FileImage(File(_image.path)),
    //               fit: BoxFit.contain,
    //             ),
    //     ),
    //   ),
    // );

    listViews.add(
      SizedBox(
        height: 20,
      ),
    );

    listViews.add(
      TitleView(
        showExtra: false,
        titleTxt: 'Choose Quantity',
        subTxt: 'Details',
        animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController,
            curve:
                Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: animationController,
      ),
    );

    listViews.add(SizedBox(
      height: 20,
    ));

    listViews.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          InkWell(
            onTap: () {
              // if (quantity > 1) {
              //   context.read<CreateLithophaneBloc>().add(
              //         UpdateQuantityEvent(quantity: --quantity),
              //       );
              // }
            },
            child: Container(
              decoration: BoxDecoration(
                color: LitPicTheme.nearlyWhite,
                shape: BoxShape.circle,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: LitPicTheme.nearlyDarkBlue.withOpacity(0.4),
                      offset: Offset(4.0, 4.0),
                      blurRadius: 8.0),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Icon(
                  Icons.remove,
                  color: LitPicTheme.nearlyDarkBlue,
                  size: 24,
                ),
              ),
            ),
          ),
          Text(
            quantity.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: LitPicTheme.fontName,
              fontWeight: FontWeight.w600,
              fontSize: 32,
              color: LitPicTheme.nearlyDarkBlue,
            ),
          ),
          InkWell(
            onTap: () {
              // context.read<CreateLithophaneBloc>().add(
              //       UpdateQuantityEvent(quantity: ++quantity),
              //     );
            },
            child: Container(
              decoration: BoxDecoration(
                color: LitPicTheme.nearlyWhite,
                shape: BoxShape.circle,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: LitPicTheme.nearlyDarkBlue.withOpacity(0.4),
                      offset: Offset(4.0, 4.0),
                      blurRadius: 8.0),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Icon(
                  Icons.add,
                  color: LitPicTheme.nearlyDarkBlue,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    listViews.add(SizedBox(
      height: 20,
    ));
    listViews.add(
      Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: RoundButtonView(
          onPressed: () {
            // if (_image == null) {
            //   locator<ModalService>().showAlert(
            //       context: context,
            //       title: 'Error',
            //       message: 'Please select an image first.');
            //   return;
            // }

            // context
            //     .read<CreateLithophaneBloc>()
            //     .add(AddToCartEvent(image: _image));
          },
          buttonColor: Colors.amber,
          text:
              'ADD LITHOPHANE${quantity == 1 ? '' : 'S'} TO CART - ${locator<FormatterService>().money(amount: sku.price * quantity)}',
          textColor: Colors.white,
          animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: animationController,
              curve:
                  Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
          animationController: animationController,
        ),
      ),
    );
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
              // final SkuModel sku = state.sku;
              // final int quantity = state.quantity;

              // _addAllListData(sku: sku, quantity: quantity);

              return Stack(
                children: <Widget>[
                  LitPicListViews(
                    listViews: listViews,
                    animationController: animationController,
                    scrollController: scrollController,
                  ),
                  LitPicAppBar(
                    title: 'Checkout',
                    topBarOpacity: topBarOpacity,
                    animationController: animationController,
                    topBarAnimation: topBarAnimation,
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
