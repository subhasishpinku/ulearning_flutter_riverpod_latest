
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulearning/common/utils/utils.dart';
part 'sign_in_state.dart';

class SignInNotifier extends StateNotifier<SignInState> {

  SignInNotifier() : super(const SignInState()) {

  }

  void emailChanged(String? email) {
    state = state.copyWith(email: email);
    }
  void passwordChanged(String? password) {
    state =  state.copyWith(password: password);
  }

}
final SignInProvider = StateNotifierProvider<SignInNotifier, SignInState>((ref) {
  return SignInNotifier();
});
