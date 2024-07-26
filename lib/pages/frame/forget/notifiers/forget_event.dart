part of 'forget_notifier.dart';

abstract class ForgetEvent extends Equatable {
  const ForgetEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends ForgetEvent {
  const EmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

