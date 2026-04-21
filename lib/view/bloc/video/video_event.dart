part of 'video_bloc.dart';

sealed class VideoEvent extends Equatable {
  const VideoEvent();

  @override
  List<Object?> get props => [];
}

class FetchVideos extends VideoEvent {
  final String category;

  const FetchVideos({required this.category});

  @override
  List<Object?> get props => [category];
}

class LoadMoreVideos extends VideoEvent{
  final String category;

  const LoadMoreVideos({required this.category});

  @override
  List<Object?> get props => [category];
}
