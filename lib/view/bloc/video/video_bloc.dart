import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:vidzy/api/model/video_model.dart';
import 'package:vidzy/api/service/video_service.dart';
import 'package:vidzy/core/error/app_exception.dart';
import 'package:vidzy/res/app_strings.dart';

part 'video_event.dart';

part 'video_state.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {


  int _page = 1;
  bool _hasReachedEnd = false;
  final List<VideoModel> _videos = [];

  VideoBloc() : super(VideoStateInitial()) {
    on<FetchVideos>(_onFetch);
    on<LoadMoreVideos>(_onLoadMore);
  }

  Future<void> _onFetch(FetchVideos event, Emitter<VideoState> emit) async {
    emit(VideoStateLoading());

    _page = 1;
    _hasReachedEnd = false;
    _videos.clear();

    try {
      final response = await VideoService.shared.fetchVideos(page: _page, category: event.category);

      final videos = response.data;

      if(videos == null){
        //emit(VideoStateError(ErrorHandler.handle(response.message as DioException).toString()));
        throw Exception(response.message ?? AppStrings.videoFetchError);
      }

      _videos.addAll(videos);

      emit(VideoStateLoaded(videos: List.from(_videos), hasReachedEnd: false));
    } on DioException catch (e) {
      emit(VideoStateError(ErrorHandler.handle(e).message));
    }
    catch (e) {
      emit(VideoStateError(e.toString()));
    }
  }

  Future<void> _onLoadMore(
    LoadMoreVideos event,
    Emitter<VideoState> emit,
  ) async {

    if (_hasReachedEnd || state is VideoStateLoading) return;

    _page++;

    try {
      final response = await VideoService.shared.fetchVideos(page : _page, category: event.category);

      final moreVideos = response.data;

      if(moreVideos == null){
        throw Exception(response.message ?? AppStrings.videoFetchError);
      }

      if (moreVideos.isEmpty) {
        _hasReachedEnd = true;
        //emit(VideoStateLoaded(videos: _videos, hasReachedEnd: true));
      } else {
        _videos.addAll(moreVideos); // [..._videos, ...moreVideos];
      }

      emit(VideoStateLoaded(
          videos: List.from(_videos),
          hasReachedEnd: _hasReachedEnd,
          errorMessage: null
      ));
    } on DioException catch (e) {
      _page--;

      emit(VideoStateLoaded(
       videos: List.from(_videos),
       hasReachedEnd: false,
       errorMessage: ErrorHandler.handle(e).message
      ));
    }
    catch (e) {
      _page--;

      emit(VideoStateLoaded(
          videos: List.from(_videos),
          hasReachedEnd: false,
          errorMessage: e.toString()
      ));

    }
  }
}
