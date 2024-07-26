import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'pay_webview_event.dart';
part 'pay_webview_state.dart';

class PayWebviewNotifier extends StateNotifier<PayWebviewState> {
  PayWebviewNotifier() : super(const PayWebviewState()) {

  }

  void onUrlChanged(
      UrlChanged event,
      ) {
    state = state.copyWith(url: event.url);
  }

}
final payWebviewProvider = StateNotifierProvider<PayWebviewNotifier, PayWebviewState>((ref) {
  return PayWebviewNotifier();
});