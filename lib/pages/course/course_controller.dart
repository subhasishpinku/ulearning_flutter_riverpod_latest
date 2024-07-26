import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ulearning/common/apis/apis.dart';
import 'package:ulearning/common/entities/entities.dart';

part 'course_controller.g.dart';


@riverpod
class AsyncNotifierCourseController extends _$AsyncNotifierCourseController {

  @override
  FutureOr<List<CourseItem>?> build() async {
     return asyncAllData();
  }

  FutureOr<List<CourseItem>?> asyncAllData() async {
    final response = await CourseAPI.courseList();
    if (response.code == 0) {
      return response.data;
    } else {
      print('Request failed with status: ${response.code}.');
    }
    return null;
  }


}
