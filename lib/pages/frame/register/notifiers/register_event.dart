part of 'register_notifier.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class UserNameChanged extends RegisterEvent {
  const UserNameChanged(this.username);
  final String username;
  @override
  List<Object> get props => [username];
}

class EmailChanged extends RegisterEvent {
  const EmailChanged(this.email);
  final String email;
  @override
  List<Object> get props => [email];
}

class PasswordChanged extends RegisterEvent {
  const PasswordChanged(this.password);
  final String password;
  @override
  List<Object> get props => [password];
}

class RePasswordChanged extends RegisterEvent {
  const RePasswordChanged(this.repassword);
  final String repassword;
  @override
  List<Object> get props => [repassword];
}