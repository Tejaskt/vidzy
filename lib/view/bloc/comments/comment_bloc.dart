import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:vidzy/api/model/comment_model.dart';
import 'package:vidzy/api/service/comment_service.dart';
import 'package:vidzy/core/error/app_exception.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {

  List<CommentModel?> _comments = [];

  CommentBloc() : super(CommentInitial()) {
    on<FetchComments>(_onFetchComments);
  }

  Future<void> _onFetchComments(FetchComments event, Emitter<CommentState> emit) async{
    emit(CommentInitial());

    _comments.clear();
    emit(CommentLoading());
    try{
      final comments = await CommentService().fetchComments( postID: event.pageIndex);

      _comments = comments;
      emit(CommentLoaded(comment: _comments));
    }on DioException catch (e){
      emit(CommentError(ErrorHandler.handle(e).message));
    }catch(e){
      emit(CommentError(e.toString()));
    }
  }
}
