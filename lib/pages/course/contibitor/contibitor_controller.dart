
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ulearning/common/apis/apis.dart';
import 'package:ulearning/common/entities/entities.dart';

part 'contibitor_controller.g.dart';

@riverpod
class AsyncNotifierContibitorController extends _$AsyncNotifierContibitorController {

  @override
  FutureOr<List<CourseItem>?> build() async {

    return null;
  }

  void init(String token){
      asyncCourseData(token);
  }

  asyncCourseData(String token) async {
    AuthorRequestEntity authorRequestEntity = AuthorRequestEntity();
    authorRequestEntity.token = token;
    var response = await CourseAPI.authorCourseList(params: authorRequestEntity);
    if(response.code==0){
      state = AsyncValue.data(response.data);

    }else{
      print('Request failed with status: ${response.code}.');
    }

  }

}

@riverpod
class AsyncNotifierContibitorAuthorController extends _$AsyncNotifierContibitorAuthorController {

  @override
  FutureOr<AuthorItem?> build() async {


    return null;
  }

  void init(String token){
    asyncAuthorData(token);
  }
  void asyncAuthorData(String token) async {
    AuthorRequestEntity authorRequestEntity = AuthorRequestEntity();
    authorRequestEntity.token = token;
    var response = await CourseAPI.courseAuthor(params: authorRequestEntity);
    print(response);
    if (response.code == 0) {
      state = AsyncValue.data(response.data);
    } else {
      // toastInfo(msg: 'internet error');
      print('Request failed with status: ${response.code}.');
    }

  }


}
