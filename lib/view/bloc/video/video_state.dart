part of 'video_bloc.dart';

sealed class VideoState extends Equatable {
  const VideoState();

  @override
  List<Object?> get props => [];
}

/// Initial state
final class VideoStateInitial extends VideoState {}

/// Loading state
final class VideoStateLoading extends VideoState {}

/// Loaded state (with data)
final class VideoStateLoaded extends VideoState {
  final List<VideoModel> videos;
  final bool hasReachedEnd;
  final String? errorMessage;

  const VideoStateLoaded({
    required this.videos,
    required this.hasReachedEnd,
    this.errorMessage
  });

  @override
  List<Object?> get props => [videos, hasReachedEnd, errorMessage];
}

/// Error state (optional but recommended)
final class VideoStateError extends VideoState {
  final String message;

  const VideoStateError(this.message);

  @override
  List<Object?> get props => [message];
}
