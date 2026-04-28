part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class FetchUserImage extends UserEvent{
  final int userId;
  const FetchUserImage({required this.userId});

  @override
  List<Object?> get props => [userId];
}