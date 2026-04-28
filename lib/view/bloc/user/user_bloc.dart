import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../../api/model/user_model.dart';
import '../../../api/service/post_service.dart';
import '../../../core/error/app_exception.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final Map<int, UserModel> _cached = {};

  UserBloc() : super(UserInitial()) {
    on<FetchUserImage>(_onFetchUser);
  }

  Future<void> _onFetchUser(FetchUserImage event,
      Emitter<UserState> emit) async {

    emit(UserLoading());

    if (_cached.containsKey(event.userId)) {
      emit(UserLoaded(userImage: _cached[event.userId]!));
    }

    try {
      final response = await PostService.shared.fetchUserImage(userId: event.userId);

      _cached[event.userId] = response.data!;

      emit(UserLoaded(userImage: response.data!));
    } on DioException catch (e) {
      emit(UserError(ErrorHandler
          .handle(e)
          .message));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}