part of 'post_bloc.dart';

sealed class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object?> get props => [];
}

class FetchPosts extends PostEvent{
  const FetchPosts();
}

class LoadMorePosts extends PostEvent{
  const LoadMorePosts();
}
