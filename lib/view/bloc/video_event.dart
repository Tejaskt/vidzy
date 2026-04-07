part of 'video_bloc.dart';

sealed class VideoEvent extends Equatable {
  const VideoEvent();

  @override
  List<Object?> get props => [];
}

class FetchVideos extends VideoEvent {}

class LoadMoreVideos extends VideoEvent{}
