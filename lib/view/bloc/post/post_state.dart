part of 'post_bloc.dart';

sealed class PostState extends Equatable {
  const PostState();

  @override
  List<Object?> get props => [];
}

/// Initial state
final class PostInitial extends PostState {}

/// Loading state
final class PostLoading extends PostState{}

/// Loaded state
final class PostLoaded extends PostState{
  final List<PostModel> posts;
  final bool hasReachedEnd;
  final String? errorMessage;

  const PostLoaded({
    required this.posts,
    required this.hasReachedEnd,
    this.errorMessage
  });

  @override
  List<Object?> get props => [posts, hasReachedEnd, errorMessage];
}

/// Error state
final class PostError extends PostState{
  final String message;
  const PostError(this.message);

  @override
  List<Object?> get props => [message];
}
