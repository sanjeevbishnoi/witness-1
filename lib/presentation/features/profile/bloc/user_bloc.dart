import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nice_shot/core/util/enums.dart';

import '../../../../data/model/api/User_model.dart';
import '../../../../data/model/api/data_model.dart';
import '../../../../data/repositories/user_repository.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(const UserState()) {
    on<UserEvent>((event, emit) async {});
    on<GetUserDataEvent>(_onGetUserData);
  }

  Future<void> _onGetUserData(
      GetUserDataEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(requestState: RequestState.loading));
    var result = await userRepository.getUserData(id: event.id);
    result.fold(
      (l) => emit(state.copyWith(
        requestState: RequestState.error,
        message: "${l.runtimeType}",
      )),
      (r) => emit(state.copyWith(
        requestState: RequestState.loaded,
        user: r,
      )),
    );
  }
}
