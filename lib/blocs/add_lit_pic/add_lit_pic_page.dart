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

  final TextEditingController _dimensionsController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _printMinutesController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

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
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: TextFormFieldView(
                  keyboardType: TextInputType.text,
                  labelText: 'Dimensions',
                  validator: locator<ValidatorService>().isEmpty,
                  textEditingController: _dimensionsController,
                  iconData: Icons.account_box,
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
                  labelText: 'Image URL',
                  validator: locator<ValidatorService>().isEmpty,
                  textEditingController: _imageUrlController,
                  iconData: Icons.picture_in_picture,
                  animation: Tween(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: animationController,
                          curve: Interval((1 / count) * 1, 1.0,
                              curve: Curves.fastOutSlowIn))),
                  animationController: animationController,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: TextFormFieldView(
                  keyboardType: TextInputType.text,
                  labelText: 'Print Minutes',
                  validator: locator<ValidatorService>().isEmpty,
                  textEditingController: _printMinutesController,
                  iconData: Icons.lock_clock,
                  animation: Tween(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: animationController,
                          curve: Interval((1 / count) * 1, 1.0,
                              curve: Curves.fastOutSlowIn))),
                  animationController: animationController,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: TextFormFieldView(
                  keyboardType: TextInputType.text,
                  labelText: 'Title',
                  validator: locator<ValidatorService>().isEmpty,
                  textEditingController: _titleController,
                  iconData: Icons.text_fields,
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
            onPressed: _save,
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

  void _save() async {
    if (_formKey.currentState!.validate() == false) return;

    context.read<AddLitPicBloc>().add(
          SubmitEvent(
            dimensions: _dimensionsController.text,
            imgUrl: _imageUrlController.text,
            printMinutes: int.parse(_printMinutesController.text),
            title: _titleController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: LitPicTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocConsumer<AddLitPicBloc, AddLitPicState>(
          builder: (context, state) {
            if (state is AddLitPicLoadingState) {
              return Spinner();
            }

            if (state is AddLitPicLoadedState) {
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
            }

            if (state is SuccessState) {
              String litPicId = state.litPicId;

              return Stack(
                children: <Widget>[
                  LitPicListViews(
                    listViews: [
                      Center(
                        child: Text('Success! New Lit Pic ID: $litPicId'),
                      )
                    ],
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

              // return
            }

            if (state is ErrorState) {
              dynamic error = state.error;
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
