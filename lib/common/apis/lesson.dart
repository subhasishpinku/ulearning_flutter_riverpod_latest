import 'package:ulearning/common/entities/entities.dart';
import 'package:ulearning/common/utils/utils.dart';
import 'package:ulearning/common/values/values.dart';

class LessonAPI {

  static Future<LessonListResponseEntity> lessonList({
    LessonRequestEntity? params,
  }) async {
    var response = await HttpUtil().post(
      'api/lesson_list',
      queryParameters: params?.toJson(),
    );
    return LessonListResponseEntity.fromJson(response);
  }

  static Future<LessonDetailResponseEntity> lessonDetail({
    LessonRequestEntity? params,
  }) async {
    var response = await HttpUtil().post(
      'api/lesson_detail',
      queryParameters: params?.toJson(),
    );
    return LessonDetailResponseEntity.fromJson(response);
  }


}
