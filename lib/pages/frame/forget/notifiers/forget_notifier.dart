
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'forget_event.dart';
part 'forget_state.dart';

class ForgetNotifier extends StateNotifier<ForgetState> {
  ForgetNotifier() : super(const ForgetState()) {

  }

  void onEmailChanged(
      EmailChanged event,
      ) {
    state = state.copyWith(email: event.email);
  }

}
final ForgetProvider = StateNotifierProvider<ForgetNotifier, ForgetState>((ref) {
  return ForgetNotifier();
});
