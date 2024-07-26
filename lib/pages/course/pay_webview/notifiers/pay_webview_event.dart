part of 'pay_webview_notifier.dart';

abstract class PayWebviewEvent extends Equatable {
  const PayWebviewEvent();

  @override
  List<Object> get props => [];
}

class UrlChanged extends PayWebviewEvent {
  const UrlChanged(this.url);

  final String url;

  @override
  List<Object> get props => [url];
}

