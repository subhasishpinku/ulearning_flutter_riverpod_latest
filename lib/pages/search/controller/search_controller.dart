import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ulearning/common/apis/apis.dart';
import 'package:ulearning/common/entities/entities.dart';

part 'search_controller.g.dart';


@riverpod
class AsyncNotifierSearchController extends _$AsyncNotifierSearchController {

  @override
  FutureOr<List<CourseItem>?> build() async {
     return asyncRecommendData();
  }

  FutureOr<List<CourseItem>?> asyncRecommendData() async {
    final response = await CourseAPI.courseList();
    if (response.code == 0) {
      return response.data;
    } else {
      print('Request failed with status: ${response.code}.');
    }
    return null;
  }

  void asyncSearchData(String content) async {
    SearchRequestEntity searchRequestEntity = new SearchRequestEntity();
    searchRequestEntity.search = content;
    var response = await CourseAPI.search(params: searchRequestEntity);

    if(response.code==0){
      state = AsyncValue.data(response.data);
    }else{
      state = AsyncValue.data([]);
      print('Request failed with status: ${response.code}.');
    }
  }

}
