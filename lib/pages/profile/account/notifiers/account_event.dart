part of 'account_notifier.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object> get props => [];
}

class AccountItemChanged extends AccountEvent {
  const AccountItemChanged(this.courseItem);

  final List<CourseItem> courseItem;

  @override
  List<Object> get props => [courseItem];
}

