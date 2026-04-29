part of 'feed_bloc.dart';

sealed class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object?> get props => [];
}

class FetchFeedItem extends FeedEvent{
  final String videoCategory;

  const FetchFeedItem({required this.videoCategory});

  @override
  List<Object?> get props => [videoCategory];
}

class LoadMoreFeedItem extends FeedEvent{
  final String videoCategory;

  const LoadMoreFeedItem({required this.videoCategory});

  @override
  List<Object?> get props => [videoCategory];

}


