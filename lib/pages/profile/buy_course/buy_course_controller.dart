import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ulearning/common/apis/apis.dart';
import 'package:ulearning/common/entities/entities.dart';

part 'buy_course_controller.g.dart';



@riverpod
class AsyncNotifierBuyCourseController extends _$AsyncNotifierBuyCourseController {

  @override
  FutureOr<List<CourseItem>?> build() async {
    final response = await CourseAPI.buyCourseList();
    if (response.code == 0) {
      return response.data;
    } else {
      print('Request failed with status: ${response.code}.');
    }
    return null;
  }
}
