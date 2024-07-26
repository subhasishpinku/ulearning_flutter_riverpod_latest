import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulearning/common/entities/course.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountNotifier extends StateNotifier<AccountState> {
  AccountNotifier() : super(const AccountState()) {

  }

  void onAccountItemChanged(
      AccountItemChanged event,
      ) {
    state = state.copyWith(courseItem: event.courseItem);
  }

}

final accountProvider = StateNotifierProvider<AccountNotifier, AccountState>((ref) {
  return AccountNotifier();
});