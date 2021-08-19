part of 'add_lit_pic_bloc.dart';

class AddLitPicPage extends StatefulWidget {
  const AddLitPicPage() : super();

  @override
  _AddLitPicPageState createState() => _AddLitPicPageState();
}

class _AddLitPicPageState extends State<AddLitPicPage>
    with TickerProviderStateMixin, UIPropertiesMixin {
  late AnimationController animationController;
  late Animation<double> topBarAnimation;

  List<Widget> listViews = [];
  var scrollController = ScrollController();
  double topBarOpacity = 0.0;

  final Color iconColor = Colors.amber[700]!;

  bool addAllListDataComplete = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

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

  void addAllListData() {
    if (!addAllListDataComplete) {
      addAllListDataComplete = true;

      int count = 2;

      // Form
      listViews.add(
        Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: TextFormFieldView(
                  keyboardType: TextInputType.text,
                  labelText: 'Name',
                  validator: locator<ValidatorService>().isEmpty,
                  textEditingController: _nameController,
                  iconData: Icons.face,
                  animation: Tween(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: animationController,
                          curve: Interval((1 / count) * 0, 1.0,
                              curve: Curves.fastOutSlowIn))),
                  animationController: animationController,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: TextFormFieldView(
                  keyboardType: TextInputType.text,
                  labelText: 'Email',
                  validator: locator<ValidatorService>().email,
                  textEditingController: _emailController,
                  iconData: Icons.email,
                  animation: Tween(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: animationController,
                          curve: Interval((1 / count) * 1, 1.0,
                              curve: Curves.fastOutSlowIn))),
                  animationController: animationController,
                ),
              ),
            ],
          ),
        ),
      );

      listViews.add(
        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: RoundButtonView(
            buttonColor: Colors.amber,
            textColor: Colors.white,
            onPressed: () async {},
            text: 'SAVE',
            animation: Tween(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animationController,
                curve:
                    Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn),
              ),
            ),
            animationController: animationController,
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
        body: BlocConsumer<AddLitPicBloc, AddLitPicState>(
          builder: (context, state) {
            switch (state.state) {
              case AddLitPicStates.loadingState:
                return Spinner();
              case AddLitPicStates.loadedState:
                addAllListData();

                return Stack(
                  children: <Widget>[
                    LitPicListViews(
                      listViews: listViews,
                      animationController: animationController,
                      scrollController: scrollController,
                    ),
                    LitPicAppBar(
                      goBackAction: () {
                        Navigator.of(context).pop();
                      },
                      title: 'Add Lit Pic',
                      topBarOpacity: topBarOpacity,
                      animationController: animationController,
                      // topBarAnimation: topBarAnimation,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom,
                    )
                  ],
                );
              case AddLitPicStates.errorState:
                final dynamic error = state.error;
                return Center(
                  child: Text(error.toString()),
                );
              default:
                return Container();
            }
          },
          listener: (context, state) {},
        ),
      ),
    );
  }
}
