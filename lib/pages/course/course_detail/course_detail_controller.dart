
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ulearning/common/apis/apis.dart';
import 'package:ulearning/common/entities/entities.dart';

part 'course_detail_controller.g.dart';

@riverpod
class AsyncNotifierCourseDetailController extends _$AsyncNotifierCourseDetailController {

  @override
  FutureOr<CourseItem?> build() async {

    return null;
  }

  void init(int? id){
      asyncCourseData(id);
  }

  asyncCourseData(int? id) async {
    CourseRequestEntity courseRequestEntity = new CourseRequestEntity();
    courseRequestEntity.id = id;
    var response = await CourseAPI.courseDetail(params: courseRequestEntity);
    if(response.code==0){
      state = AsyncValue.data(response.data);
    }else{
      print('Request failed with status: ${response.code}.');
    }

  }

}

@riverpod
class AsyncNotifierCourseDetailLessonController extends _$AsyncNotifierCourseDetailLessonController {

  @override
  FutureOr<List<LessonItem>?> build() async {
    return null;
  }

  void init(int? id){
    asyncLessonData(id);
  }
  void asyncLessonData(int? id) async {
    LessonRequestEntity lessonRequestEntity = new LessonRequestEntity();
    lessonRequestEntity.id = id;
    var response = await LessonAPI.lessonList(params: lessonRequestEntity);
    print(response);
    if (response.code == 0) {
      state = AsyncValue.data(response.data);
    } else {
      // toastInfo(msg: 'internet error');
      print('Request failed with status: ${response.code}.');
    }

  }


}
