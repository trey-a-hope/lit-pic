import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:litpic/common/lit_pic_app_bar.dart';
import 'package:litpic/common/lit_pic_list_views.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/litpic_theme.dart';
import 'package:litpic/mixins/ui_properties_mixin.dart';
import 'package:litpic/models/litpic_model.dart';
import 'package:litpic/service_locator.dart';
import 'package:litpic/services/litpic_service.dart';
import 'package:litpic/services/validater_service.dart';
import 'package:litpic/views/round_button_view.dart';
import 'package:litpic/views/text_form_field_view.dart';

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
    }

    if (event is SubmitEvent) {
      String dimensions = event.dimensions;
      String imgUrl = event.imgUrl;
      int printMinutes = event.printMinutes;
      String title = event.title;

      try {
        String litPicId = await locator<LitPicService>().create(
          litPic: LitPicModel(
              dimensions: dimensions,
              id: null,
              imgUrl: imgUrl,
              printMinutes: printMinutes,
              title: title),
        );

        print('New Lit Pic: $litPicId');

        yield SuccessState(litPicId: litPicId);
      } catch (e) {
        yield ErrorState(error: e);
      }
    }
  }
}
