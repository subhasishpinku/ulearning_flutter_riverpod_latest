
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'register_state.dart';
part 'register_event.dart';

class RegisterNotifier extends StateNotifier<RegisterState> {
  RegisterNotifier() : super(const RegisterState()) {

  }

  void onUserNameChanged(
    UserNameChanged event
  ) {
    state = state.copyWith(username: event.username);
  }

  void onEmailChanged(
    EmailChanged event
  ) {
    state = state.copyWith(email: event.email);
  }

  void onPasswordChanged(
    PasswordChanged event,
  ) {
    state = state.copyWith(password: event.password);
  }

  void onRePasswordChanged(
    RePasswordChanged event,
  ) {
    state = state.copyWith(repassword: event.repassword);
  }
}

final RegisterProvider = StateNotifierProvider<RegisterNotifier, RegisterState>((ref) {
  return RegisterNotifier();
});