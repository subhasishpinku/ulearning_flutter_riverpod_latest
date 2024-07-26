part of 'pay_webview_notifier.dart';

class PayWebviewState extends Equatable {
  const PayWebviewState({
    this.url="",
  });

  final String url;

  PayWebviewState copyWith({
    String? url,
  }) {
    return PayWebviewState(
      url: url ?? this.url,
    );
  }

  @override
  List<Object> get props => [url];
}
