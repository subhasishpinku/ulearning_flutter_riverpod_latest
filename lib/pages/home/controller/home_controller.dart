import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ulearning/common/apis/apis.dart';
import 'package:ulearning/common/entities/entities.dart';
import 'package:ulearning/global.dart';

part 'home_controller.g.dart';

@riverpod
class HomeBannerDots extends _$HomeBannerDots{

  @override
  int build()=>0;

  void setIndex(int value){
    state = value;
  }
}

@riverpod
class HomeUserItem extends _$HomeUserItem{

  @override
  UserItem build()=>Global.storageService.getUserProfile();

}

@riverpod
class AsyncNotifierHomeController extends _$AsyncNotifierHomeController {

  @override
  FutureOr<List<CourseItem>?> build() async {
    final response = await CourseAPI.courseList();
    if (response.code == 0) {
      return response.data;
    } else {
      print('Request failed with status: ${response.code}.');
    }
    return null;
  }
}
