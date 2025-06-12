part of 'auth_bloc.dart';

class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {}

final class AuthLogoutSuccess extends AuthState {}

final class AuthError extends AuthState {
  final String message;
  AuthError({required this.message});
}
