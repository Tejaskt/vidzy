part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

final class UserInitial extends UserState {}
final class UserLoading extends UserState {}

final class UserLoaded extends UserState{
  final UserModel userImage;

  const UserLoaded({required this.userImage});

  @override
  List<Object?> get props => [userImage];
}

final class UserError extends UserState{
  final String message;
  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}