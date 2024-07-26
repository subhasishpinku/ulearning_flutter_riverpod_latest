import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulearning/common/apis/apis.dart';
import 'package:ulearning/common/widgets/widgets.dart';
import 'package:ulearning/pages/profile/account/notifiers/account_notifier.dart';


class AccountLogic{
  final WidgetRef ref;

  AccountLogic({
    required this.ref,
  });

  void init(){
    asyncPostAllData();
  }

  asyncPostAllData() async {

    var result = await CourseAPI.orderList();
    print(result);
    if(result.code==0){
      ref.read(accountProvider.notifier).onAccountItemChanged(AccountItemChanged(result.data!));
    }else{
      toastInfo(msg: 'internet error');
    }

  }

}