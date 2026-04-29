part of 'feed_bloc.dart';

sealed class FeedState extends Equatable {
  const FeedState();

  @override
  List<Object?> get props => [];
}

/// Initial State
final class FeedInitial extends FeedState {}

/// Loading State
final class FeedLoading extends FeedState {}

/// Loaded State
final class FeedLoaded extends FeedState {
  final List<FeedModel> feedItem;
  final bool hasReachedEnd;
  final String? errorMessage;

  const FeedLoaded({
    required this.feedItem,
    required this.hasReachedEnd,
    this.errorMessage
  });

  @override
  List<Object?> get props => [feedItem,hasReachedEnd,errorMessage];
}

/// Error State
final class FeedError extends FeedState{
  final String message;

  const FeedError(this.message);

  @override
  List<Object?> get props => [message];
}
