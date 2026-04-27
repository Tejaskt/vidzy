import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:vidzy/api/model/post_model.dart';
import 'package:vidzy/api/service/post_service.dart';
import 'package:vidzy/core/error/app_exception.dart';
import 'package:vidzy/res/app_strings.dart';

part 'post_event.dart';

part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  int _perPageItem = 10;
  bool _haseReachEnd = false;
  final List<PostModel> _posts = [];

  PostBloc() : super(PostInitial()) {
    on<FetchPosts>(_onFetch);
    on<LoadMorePosts>(_onLoadMore);
  }

  Future<void> _onFetch(FetchPosts event, Emitter<PostState> emit) async {
    emit(PostLoading());


    _haseReachEnd = false;
    _posts.clear();

    try {
      final response = await PostService.shared.fetchPosts();

      final posts = response.data;

      if (posts == null) {
        throw Exception(response.message ?? AppStrings.videoFetchError);
      }

      _posts.addAll(posts);

      emit(PostLoaded(posts: List.from(_posts), hasReachedEnd: false));
    } on DioException catch (e) {
      emit(PostError(ErrorHandler.handle(e).message));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> _onLoadMore(LoadMorePosts event, Emitter<PostState> emit) async {
    if (_haseReachEnd || state is PostLoading) return;

    _perPageItem += 10;

    try {
      final response = await PostService.shared.fetchPosts(skip: _perPageItem);

      final morePost = response.data;

      if (morePost == null) {
        throw Exception(response.message ?? AppStrings.postFetchError);
      }

      if (morePost.isEmpty) {
        _haseReachEnd = true;
      } else {
        _posts.addAll(morePost);
      }

      emit(
        PostLoaded(
          posts: List.from(_posts),
          hasReachedEnd: _haseReachEnd,
          errorMessage: null,
        ),
      );
    } on DioException catch (e) {
      _perPageItem -= 10;

      emit(
        PostLoaded(
          posts: List.from(_posts),
          hasReachedEnd: false,
          errorMessage: ErrorHandler.handle(e).message,
        ),
      );
    } catch (e) {
      _perPageItem -= 10;

      emit(
        PostLoaded(
          posts: List.from(_posts),
          hasReachedEnd: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
