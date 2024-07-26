import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ulearning/common/apis/apis.dart';
import 'package:ulearning/common/entities/entities.dart';

part 'my_course_controller.g.dart';



@riverpod
class AsyncNotifierMyCourseController extends _$AsyncNotifierMyCourseController {

  @override
  FutureOr<List<CourseItem>?> build() async {
    final response = await CourseAPI.myCourseList();
    if (response.code == 0) {
      return response.data;
    } else {
      print('Request failed with status: ${response.code}.');
    }
    return null;
  }
}
