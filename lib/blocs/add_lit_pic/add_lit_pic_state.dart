part of 'add_lit_pic_bloc.dart';

enum AddLitPicStates { initialState, loadingState, loadedState, errorState }

class AddLitPicState extends Equatable {
  const AddLitPicState._(
      {this.state = AddLitPicStates.initialState, this.error});

  const AddLitPicState.addLitPicInitial()
      : this._(state: AddLitPicStates.initialState);

  const AddLitPicState.addLitPicLoadingState()
      : this._(state: AddLitPicStates.loadingState);

  const AddLitPicState.addLitPicLoadedState()
      : this._(state: AddLitPicStates.loadedState);

  const AddLitPicState.errorState(dynamic error)
      : this._(state: AddLitPicStates.errorState);

  final AddLitPicStates state;
  final dynamic error;

  @override
  List<Object> get props => [state];
}
