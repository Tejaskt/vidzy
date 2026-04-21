part of 'comment_bloc.dart';

sealed class CommentEvent extends Equatable {
  const CommentEvent();

  @override
  List<Object?> get props => [];
}

class FetchComments extends CommentEvent{
  final int pageIndex;

  const FetchComments(this.pageIndex);

  @override
  List<Object?> get props => [pageIndex];
}
