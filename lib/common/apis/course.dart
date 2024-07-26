import 'package:ulearning/common/entities/entities.dart';
import 'package:ulearning/common/utils/utils.dart';
import 'package:ulearning/common/values/values.dart';

class CourseAPI {

  static Future<CourseListResponseEntity> courseList() async {
    var response = await HttpUtil().post(
      'api/course_list',
    );
    return CourseListResponseEntity.fromJson(response);
  }

  static Future<CourseDetailResponseEntity> courseDetail({
    CourseRequestEntity? params,
  }) async {
    var response = await HttpUtil().post(
      'api/course_detail',
      queryParameters: params?.toJson(),
    );
    return CourseDetailResponseEntity.fromJson(response);
  }

  static Future<AuthorResponseEntity> courseAuthor({
    AuthorRequestEntity? params,
  }) async {
    var response = await HttpUtil().post(
      'api/course_author',
      queryParameters: params?.toJson(),
    );
    return AuthorResponseEntity.fromJson(response);
  }

  static Future<CourseListResponseEntity> authorCourseList({
    AuthorRequestEntity? params,
  }) async {
    var response = await HttpUtil().post(
      'api/author_course_list',
      queryParameters: params?.toJson(),
    );
    return CourseListResponseEntity.fromJson(response);
  }

  static Future<CourseListResponseEntity> search({
    SearchRequestEntity? params,
  }) async {
    var response = await HttpUtil().post(
      'api/search',
      queryParameters: params?.toJson(),
    );
    return CourseListResponseEntity.fromJson(response);
  }

  static Future<BaseResponseEntity> coursePay({
    CourseRequestEntity? params,
  }) async {
    var response = await HttpUtil().post(
      'api/checkout',
      queryParameters: params?.toJson(),
    );
    return BaseResponseEntity.fromJson(response);
  }

  static Future<CourseListResponseEntity> myCourseList() async {
    var response = await HttpUtil().post(
      'api/my_course_list',
    );
    return CourseListResponseEntity.fromJson(response);
  }

  static Future<CourseListResponseEntity> buyCourseList() async {
    var response = await HttpUtil().post(
      'api/buy_course_list',
    );
    return CourseListResponseEntity.fromJson(response);
  }

  static Future<CourseListResponseEntity> orderList() async {
    var response = await HttpUtil().post(
      'api/order_list',
    );
    return CourseListResponseEntity.fromJson(response);
  }

}
