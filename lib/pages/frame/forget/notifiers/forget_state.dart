part of 'forget_notifier.dart';

class ForgetState extends Equatable {
  const ForgetState({
    this.email="",
  });

  final String email;

  ForgetState copyWith({
    String? email,
  }) {
    return ForgetState(
      email: email ?? this.email,
    );
  }

  @override
  List<Object> get props => [email];
}
