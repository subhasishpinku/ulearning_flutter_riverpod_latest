part of 'account_notifier.dart';

class AccountState extends Equatable {
  const AccountState({
    this.courseItem = const <CourseItem>[],
  });

  final List<CourseItem> courseItem;

  AccountState copyWith({
    List<CourseItem>? courseItem,
  }) {
    return AccountState(
      courseItem: courseItem ?? this.courseItem,
    );
  }

  @override
  List<Object> get props => [courseItem];
}
