part of 'register_notifier.dart';

class RegisterState extends Equatable {
  const RegisterState({
    this.username = "",
    this.email = "",
    this.password = "",
    this.repassword = "",
  });

  final String username;
  final String email;
  final String password;
  final String repassword;

  RegisterState copyWith({
    String? username,
    String? email,
    String? password,
    String? repassword,
  }) {
    return RegisterState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      repassword: repassword ?? this.repassword,
    );
  }

  @override
  List<Object> get props => [username, email, password, repassword];
}
