import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:litpic/common/lit_pic_app_bar.dart';
import 'package:litpic/common/lit_pic_list_views.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/litpic_theme.dart';
import 'package:litpic/views/list_tile_view.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

part 'add_lit_pic_event.dart';
part 'add_lit_pic_state.dart';
part 'add_lit_pic_page.dart';

class AddLitPicBloc extends Bloc<AddLitPicEvent, AddLitPicState> {
  AddLitPicBloc() : super(AddLitPicInitial());

  @override
  Stream<AddLitPicState> mapEventToState(
    AddLitPicEvent event,
  ) async* {
    yield AddLitPicLoadingState();

    if (event is LoadPageEvent) {
      yield AddLitPicLoadedState();
      // try {
      //   _currentUser = await locator<AuthService>().getCurrentUser();

      //   _price = await locator<StripePriceService>().get(priceID: PRICE_ID);

      //   print(_price);

      //   yield CreateLithophaneLoadedState(
      //     price: _price,
      //     quantity: _quantity,
      //     imageUploaded: false,
      //   );
      // } catch (error) {
      //   yield ErrorState(error: error);
      // }
    }
  }
}
