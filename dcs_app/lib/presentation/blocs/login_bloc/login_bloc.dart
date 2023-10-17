import 'package:bloc/bloc.dart';
import 'package:dcs_app/domain/repositories/auth_repository.dart';
import 'package:dcs_app/utils/constants.dart';
import 'package:dcs_app/utils/internet_connection_utils.dart';
import 'package:dcs_app/global/locator.dart';
import 'package:dcs_app/utils/resouces/data_state.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository = locator<AuthRepository>();

  LoginBloc() : super(const LoginState()) {
    on<LoginWithButtonPressed>(
      (event, emit) async {
        emit(state.copyWith(loading: true));
        if (await InternetConnectionUtils.checkConnection()) {
          final response = await _authRepository.login(
              event.email.trim(), event.password.trim());
          emit(state.copyWith(loading: false));
          if (response is DataSuccess) {
            await _authRepository.saveUserToken(
              username: response.data!.firstName,
              token: response.data!.token,
              email: event.email.trim(),
              defaultSessionName: response.data?.defaultSessionName,
              browsers: response.data?.browsers ?? [],
            );
            emit(
              state.copyWith(success: true),
            );
          } else if (response is DataFailed) {
            emit(
              state.copyWith(
                message: AppText.emailOrPwdIncorrect,
                success: false,
              ),
            );
          }
        } else {
          emit(
            state.copyWith(
              message: AppText.noInternetMsg,
              success: false,
            ),
          );
        }
      },
    );

    on<LoginValidateEvent>((event, emit) {
      emit(
        state.copyWith(
          validatePassword: event.password,
          validateUsername: event.username,
          loading: false,
        ),
      );
    });
  }
}
