part of 'add_lit_pic_bloc.dart';

abstract class AddLitPicEvent extends Equatable {
  const AddLitPicEvent();

  @override
  List<Object> get props => [];
}

class LoadPageEvent extends AddLitPicEvent {
  const LoadPageEvent();

  @override
  List<Object> get props => [];
}

class SubmitEvent extends AddLitPicEvent {
  final String dimensions;
  final String imgUrl;
  final int printMinutes;
  final String title;

  const SubmitEvent({
    required this.dimensions,
    required this.imgUrl,
    required this.printMinutes,
    required this.title,
  });

  @override
  List<Object> get props => [
        dimensions,
        imgUrl,
        printMinutes,
        title,
      ];
}
