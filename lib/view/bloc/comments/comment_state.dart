part of 'comment_bloc.dart';

sealed class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object> get props => [];
}

final class CommentInitial extends CommentState {}

final class CommentLoading extends CommentState {}

final class CommentLoaded extends CommentState {
  final List<CommentModel?> comment;
  const CommentLoaded({
    required this.comment
});

  @override
  List<Object> get props => [comment];
}

final class CommentError extends CommentState{
  final String message;

  const CommentError(this.message);

  @override
  List<Object> get props => [message];
}
