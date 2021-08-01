part of 'profile_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage() : super();
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin, UIPropertiesMixin {
  bool addAllListDataComplete = false;

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

  void _addAllListData({required UserModel currentUser}) {
    if (!addAllListDataComplete) {
      addAllListDataComplete = true;

      var count = 5;

      listViews.add(
        TitleView(
          showExtra: false,
          titleTxt: 'Welcome, ${currentUser.customer!.name}',
          subTxt: 'more',
          animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: animationController,
              curve:
                  Interval((1 / count) * 4, 1.0, curve: Curves.fastOutSlowIn))),
          animationController: animationController,
        ),
      );

      listViews.add(
        ProfileButtonsView(
          mainScreenAnimation: Tween(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                  parent: animationController,
                  curve: Interval((1 / count) * 5, 1.0,
                      curve: Curves.fastOutSlowIn))),
          mainScreenAnimationController: animationController,
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
        body: BlocConsumer<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoadingState) {
              return Spinner();
            }

            if (state is ProfileLoadedState) {
              final UserModel currentUser = state.currentUser;

              _addAllListData(currentUser: currentUser);

              return Stack(
                children: <Widget>[
                  LitPicListViews(
                    listViews: listViews,
                    animationController: animationController,
                    scrollController: scrollController,
                  ),
                  LitPicAppBar(
                    title: 'Profile',
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

            return Container();
          },
          listener: (context, state) {},
        ),
      ),
    );
  }
}
