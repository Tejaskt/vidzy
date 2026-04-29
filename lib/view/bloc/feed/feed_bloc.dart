import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vidzy/api/common_model/feed_model.dart';
import 'package:vidzy/api/model/post_model.dart';
import 'package:vidzy/api/model/video_model.dart';
import 'package:vidzy/api/service/feed_service.dart';

import '../../../core/error/app_exception.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final FeedService _apiService = FeedService.shared;

  int _page = 1;
  bool _hasReachedEnd = false;
  bool _isFetchingMore = false;

  final List<FeedModel> _feedItems = [];

  FeedBloc() : super(FeedInitial()) {
    on<FetchFeedItem>(_onFetch);
    on<LoadMoreFeedItem>(_onLoadMore);
  }

  Future<void> _onFetch(FetchFeedItem event, Emitter<FeedState> emit) async {
    emit(FeedLoading());

    _page = 1;
    _hasReachedEnd = false;
    _feedItems.clear();

    try {
      final (videos, posts) = await _apiService.fetchFeed(
        page: _page,
        category: event.videoCategory,
        skip: 0,
      );

      _mergeData(videos, posts);

      emit(FeedLoaded(feedItem: List.from(_feedItems), hasReachedEnd: false));
    } on AppException catch (e) {
      emit(FeedError(e.toString()));
    } catch (e) {
      emit(FeedError(e.toString()));
    }
  }

  Future<void> _onLoadMore(
    LoadMoreFeedItem event,
    Emitter<FeedState> emit,
  ) async {

    if (_hasReachedEnd || _isFetchingMore) return;

    _isFetchingMore = true;
    final nextPage = _page + 1;

    try {
      final (videos, posts) = await _apiService.fetchFeed(
        page: nextPage,
        category: event.videoCategory,
        skip: _feedItems.length,
      );

      if (videos.isEmpty && posts.isEmpty) {
        _hasReachedEnd = true;
        return;
      } else{
        _page = nextPage;
        _mergeData(videos, posts);
      }

      emit(FeedLoaded(feedItem: List.from(_feedItems), hasReachedEnd: _hasReachedEnd));
    } on AppException catch (e) {
      emit(FeedLoaded(feedItem: List.from(_feedItems), hasReachedEnd: false, errorMessage: e.toString()));
    } catch (e) {
      emit(FeedLoaded(feedItem: List.from(_feedItems), hasReachedEnd: false, errorMessage: e.toString()));
    }

    _isFetchingMore = false;
  }

  void _mergeData(List<VideoModel> videos, List<PostModel> posts) {
    final maxLength = videos.length > posts.length
        ? videos.length
        : posts.length;

    for (int i = 0; i < maxLength; i++) {
      _feedItems.add(
        FeedModel(
          video: i < videos.length ? videos[i] : null,
          post: i < posts.length ? posts[i] : null,
        ),
      );
    }
  }
}
