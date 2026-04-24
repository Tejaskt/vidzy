import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:vidzy/api/model/comment_model.dart';
import 'package:vidzy/api/service/comment_service.dart';
import 'package:vidzy/core/error/app_exception.dart';
import 'package:vidzy/res/app_strings.dart';

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
      final response = await CommentService.shared.fetchComments( postID: event.pageIndex);

      final comments = response.data;

      if(comments == null){
        throw Exception(response.message ?? AppStrings.commentFetchError);      }

      _comments = comments;
      emit(CommentLoaded(comment: _comments));
    }on DioException catch (e){
      emit(CommentError(ErrorHandler.handle(e).message));
    }catch(e){
      emit(CommentError(e.toString()));
    }
  }
}
