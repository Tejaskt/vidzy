import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:vidzy/api/model/video_model.dart';
import 'package:vidzy/api/service/video_service.dart';
import 'package:vidzy/core/error/app_exception.dart';

part 'video_event.dart';

part 'video_state.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final VideoService apiService;

  int page = 1;
  List<VideoModel> _videos = [];
  bool _hasReachedEnd = false;

  VideoBloc(this.apiService) : super(VideoStateInitial()) {
    on<FetchVideos>(_onFetch);
    on<LoadMoreVideos>(_onLoadMore);
  }

  Future<void> _onFetch(FetchVideos event, Emitter<VideoState> emit) async {

    emit(VideoStateLoading());

    //page = 1;
    _hasReachedEnd = false;

    try {
      final videos = await apiService.fetchVideos(page: page);

      _videos = videos;

      emit(VideoStateLoaded(videos: _videos, hasReachedEnd: false));
    } on DioException catch (e) {
      emit(VideoStateError(ErrorHandler.handle(e).message));
    } catch (e) {
      emit(VideoStateError(e.toString()));
    }
  }

  Future<void> _onLoadMore(
    LoadMoreVideos event,
    Emitter<VideoState> emit,
  ) async {

    if (_hasReachedEnd || state is VideoStateLoading) return;

    try {
      final moreVideos = await apiService.fetchVideos(page : page + 1);

      if (moreVideos.isEmpty) {
        _hasReachedEnd = true;
        emit(VideoStateLoaded(videos: _videos, hasReachedEnd: true));
      } else {
        page++;
        _videos = [..._videos, ...moreVideos];

        emit(VideoStateLoaded(videos: _videos, hasReachedEnd: false));
      }
    } on DioException catch (e) {
      emit(VideoStateError(ErrorHandler.handle(e).message));
    } catch (e) {
      emit(VideoStateError(e.toString()));
    }
  }
}
