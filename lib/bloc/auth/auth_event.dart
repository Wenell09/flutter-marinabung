part of 'auth_bloc.dart';

class AuthEvent {}

class RegisterUser extends AuthEvent {
  final Map<String, dynamic> data;
  RegisterUser({required this.data});
}

class LoginUser extends AuthEvent {
  final Map<String, dynamic> data;
  LoginUser({
    required this.data,
  });
}

class VerifAuth extends AuthEvent {
  final String type;
  final Map<String, dynamic> data;
  VerifAuth({required this.data, required this.type});
}

class LogoutUser extends AuthEvent {}
