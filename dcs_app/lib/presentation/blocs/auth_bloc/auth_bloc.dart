import 'package:bloc/bloc.dart';
import 'package:dcs_app/domain/models/user/user.dart';
import 'package:dcs_app/utils/internet_connection_utils.dart';

import '../../../domain/repositories/auth_repository.dart';
import '../../../global/locator.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository = locator<AuthRepository>();

  AuthBloc() : super(const AuthInitial()) {
    on<AppLoaded>((event, emit) async {
      emit(AuthLoading());
      if (await InternetConnectionUtils.checkConnection()) {
        User? user;
        try {
          user = _authRepository.getUser;
        } catch (e) {
          emit(AuthFailure(message: e.toString()));
        }
        if (user != null) {
          emit(AuthAuthenticated(user: user));
        } else {
          emit(AuthNotAuthenticated());
        }
      } else {
        emit(AuthNoInternetConnection());
      }
    });

    on<UserLoggedOut>((event, emit) async {
      await _authRepository.clearData();
      emit(AuthNotAuthenticated());
    });

    on<UserTokenExpired>((event, emit) async {
      await _authRepository.clearData();
      emit(AuthFailure(message: event.message));
    });
  }
}
