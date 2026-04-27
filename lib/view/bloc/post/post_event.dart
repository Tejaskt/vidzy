part of 'post_bloc.dart';

sealed class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object?> get props => [];
}

class FetchPosts extends PostEvent{
  final int skip;
  const FetchPosts({required this.skip});

  @override
  List<Object?> get props => [skip];
}

class LoadMorePosts extends PostEvent{
  final int skip;
  const LoadMorePosts(this.skip);

  @override
  List<Object?> get props => [skip];
}
