import 'package:bloc/bloc.dart';
import 'package:flutter_marinabung/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<VerifAuth>((event, emit) {
      if (event.data["username"] == "" ||
          event.data["email"] == "" ||
          event.data["password"] == "") {
        emit(AuthError(message: "Pastikan semua field telah terisi"));
      } else {
        switch (event.type) {
          case "register":
            add(RegisterUser(data: event.data));
            break;
          case "login":
            add(LoginUser(data: event.data));
            break;
        }
      }
    });
    on<RegisterUser>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.registerUser(event.data);
        emit(AuthSuccess());
      } catch (e) {
        emit(AuthError(message: e.toString().substring(11)));
      }
    });
    on<LoginUser>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.loginUser(event.data);
        emit(AuthSuccess());
      } catch (e) {
        emit(AuthError(message: e.toString().substring(11)));
      }
    });
    on<LogoutUser>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.logoutUser();
        emit(AuthLogoutSuccess());
      } catch (e) {
        emit(AuthError(message: e.toString().substring(11)));
      }
    });
  }
}
