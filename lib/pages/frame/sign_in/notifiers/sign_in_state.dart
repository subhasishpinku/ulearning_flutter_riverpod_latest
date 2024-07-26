part of 'sign_in_notifier.dart';

class SignInState extends Equatable {
  const SignInState({
    this.email="",
    this.password="",
  });

  final String email;
  final String password;

  SignInState copyWith({
    String? email,
    String? password,
  }) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  List<Object> get props => [email,password];
}
