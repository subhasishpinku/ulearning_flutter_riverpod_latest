import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning/common/apis/course.dart';
import 'package:ulearning/common/entities/entities.dart';
import 'package:ulearning/common/routes/names.dart';
import 'package:ulearning/common/values/colors.dart';
import 'package:ulearning/common/widgets/toast.dart';
import 'package:ulearning/pages/course/course_detail/course_detail_controller.dart';

class CourseDetail extends ConsumerStatefulWidget {
  const CourseDetail({super.key});

  @override
  ConsumerState<CourseDetail> createState() => _CourseDetailPage();
}

class _CourseDetailPage extends ConsumerState<CourseDetail> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,(){
      final args = ModalRoute.of(ref.context)!.settings.arguments as Map;
      print(args);
      ref.read(asyncNotifierCourseDetailControllerProvider.notifier).init(args["id"]);
      ref.read(asyncNotifierCourseDetailLessonControllerProvider.notifier).init(args["id"]);
    });
  }

  goPay(int? id) async {
    EasyLoading.show(indicator: CircularProgressIndicator(),maskType: EasyLoadingMaskType.clear,dismissOnTap: true);
    CourseRequestEntity courseRequestEntity = new CourseRequestEntity();
    courseRequestEntity.id = id;
    var result = await CourseAPI.coursePay(
      params: courseRequestEntity,
    );
    print(result);
    EasyLoading.dismiss();
    if(result.code==0){
      var url = Uri.decodeFull(result.data!);
      print(url);
      var res = await Navigator.of(ref.context).pushNamed(AppRoutes.PayWebview,arguments: {"url":url});
      if(res=="success"){
        toastInfo(msg: "Pay successful!");
        // Navigator.of(context).pop();
      }else{
        toastInfo(msg: "Picked the wrong pay?");
      }
    }else{
      toastInfo(msg: result.msg!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final courseItem = ref.watch(asyncNotifierCourseDetailControllerProvider);
    final LessonList = ref.watch(asyncNotifierCourseDetailLessonControllerProvider);

      return Container(
          color: Colors.white,
          child: SafeArea(
          child: Scaffold(
        appBar: _buildAppBar(),
        backgroundColor: Colors.white,
        body: switch (courseItem) {
          AsyncData(:final value) => value == null
              ? Center(
            child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    color: Colors.black26, strokeWidth: 2)),
          )
              : CustomScrollView(slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(
              vertical: 15.h,
              horizontal: 25.w,
            ),
            sliver: SliverToBoxAdapter(
              child: Container(
                width: 325.w,
                height: 200.h,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage("${value.thumbnail}"),
                    fit: BoxFit.fitWidth,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20.h)),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 25.w,
            ),
            sliver: SliverToBoxAdapter(child: _menuView(context, value)),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 25.w,
            ),
            sliver: SliverToBoxAdapter(
                child: Container(
              margin: EdgeInsets.only(top: 15.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      "Course Description",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 11.h),
                    child: Text(
                      value.description??"Not Some Description",
                      textAlign: TextAlign.start,
                      strutStyle: StrutStyle(height: 1),
                      style: TextStyle(
                        color: AppColors.primaryThreeElementText,
                        fontWeight: FontWeight.normal,
                        fontSize: 11.sp,
                      ),
                    ),
                  )
                ],
              ),
            )),
          ),
          SliverPadding(
            padding: EdgeInsets.only(
              top: 20.h,
              left: 25.w,
              right: 25.w,
            ),
            sliver: SliverToBoxAdapter(
              child: GestureDetector(
                child: Container(
                  width: 330.w,
                  height: 50.h,
                  margin: EdgeInsets.only(top: 0.h),
                  padding: EdgeInsets.only(
                      left: 15.w, right: 15.w, top: 13.h, bottom: 5.h),
                  decoration: BoxDecoration(
                      color: AppColors.primaryElement,
                      borderRadius: BorderRadius.all(Radius.circular(10.w)),
                      border: Border.all(color: AppColors.primaryElement)),
                  child: Text(
                    "Go Buy",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.primaryElementText,
                      fontWeight: FontWeight.normal,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                onTap: () {
                  goPay(value.id);
                },
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 25.w,
            ),
            sliver: SliverToBoxAdapter(
                child: Container(
              margin: EdgeInsets.only(top: 20.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      "The Course Includes",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 0.h),
                    child: Column(
                      children: [
                        Container(
                            margin: EdgeInsets.only(top: 16.w),
                            child: Row(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  child: Image(
                                    image: AssetImage(
                                        "assets/icons/video_detail.png"),
                                    width: 30.w,
                                    height: 30.h,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10.w),
                                  child: Text(
                                    "${value.video_len} Hours Video",
                                    style: TextStyle(
                                      color:
                                          AppColors.primarySecondaryElementText,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                )
                              ],
                            )),
                        Container(
                            margin: EdgeInsets.only(top: 16.w),
                            child: Row(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  child: Image(
                                    image: AssetImage(
                                        "assets/icons/file_detail.png"),
                                    width: 30.w,
                                    height: 30.h,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10.w),
                                  child: Text(
                                    "Total ${value.lesson_num} Lessons",
                                    style: TextStyle(
                                      color:
                                          AppColors.primarySecondaryElementText,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                )
                              ],
                            )),
                        Container(
                          margin: EdgeInsets.only(top: 16.w),
                          child: Row(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: Image(
                                  image: AssetImage(
                                      "assets/icons/download_detail.png"),
                                  width: 30.w,
                                  height: 30.h,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10.w),
                                child: Text(
                                  "${value.down_num} Download Resources",
                                  style: TextStyle(
                                    color:
                                        AppColors.primarySecondaryElementText,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11.sp,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )),
          ),

          SliverPadding(
            padding: EdgeInsets.only(
              top: 20.h,
              left: 25.w,
              right: 25.w,
            ),
            sliver: SliverToBoxAdapter(
              child: Container(
                child: Text(
                  "Lesson List",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              vertical: 18.h,
              horizontal: 25.w,
            ),
            sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (content, index) {
                        var item = LessonList.value!.elementAt(index);
                    return _buildListItem(content,item);
                  },
                  childCount: LessonList.value?.length,
                )),
          ),
        ]),
          AsyncError(:final error) => Text('Error: $error'),
          _ => Center(
            child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    color: Colors.black26, strokeWidth: 2)),
          ),
        }
      )));
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Container(
        child: Text(
          "Courses Detail",
          style: TextStyle(
            color: AppColors.primaryText,
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }

  Widget _menuView(BuildContext context,CourseItem item) {
    return Container(
        width: 325.w,
        margin: EdgeInsets.only(
          top: 0.h,
          bottom: 5.h,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              child: Container(
                margin: EdgeInsets.only(right: 30.w),
                padding: EdgeInsets.only(
                    left: 15.w, right: 15.w, top: 5.h, bottom: 5.h),
                decoration: BoxDecoration(
                    color: AppColors.primaryElement,
                    borderRadius: BorderRadius.all(Radius.circular(7.w)),
                    border: Border.all(color: AppColors.primaryElement)),
                child: Text(
                  "Author Page",
                  style: TextStyle(
                    color: AppColors.primaryElementText,
                    fontWeight: FontWeight.normal,
                    fontSize: 10.sp,
                  ),
                ),
              ),
              onTap: () {
                  Navigator.of(context).pushNamed(AppRoutes.Contibitor,arguments: {"token":item.user_token});
              },
            ),
            Container(
              margin: EdgeInsets.only(right: 30.w),
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Image(
                      image: AssetImage("assets/icons/people.png"),
                      width: 20.w,
                      height: 20.h,
                    ),
                  ),
                  Container(
                    child: Text(
                      "${item.follow??0}",
                      style: TextStyle(
                        color: AppColors.primaryThreeElementText,
                        fontWeight: FontWeight.normal,
                        fontSize: 11.sp,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 30.w),
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Image(
                      image: AssetImage("assets/icons/star.png"),
                      width: 16.w,
                      height: 16.h,
                    ),
                  ),
                  Container(
                    child: Text(
                      "${item.score??0}",
                      style: TextStyle(
                        color: AppColors.primaryThreeElementText,
                        fontWeight: FontWeight.normal,
                        fontSize: 11.sp,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  Widget _buildListItem(BuildContext context,LessonItem item) {
    return Container(
      width: 325.w,
      height: 80.h,
      margin: EdgeInsets.only(
        bottom: 15.h,
      ),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 1),
        borderRadius: BorderRadius.all(Radius.circular(10.w)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(AppRoutes.Lesson,arguments:{"id":item.id});
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        height: 60.h,
                        width: 60.h,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  "${item.thumbnail}"),
                              fit: BoxFit.fill),
                          borderRadius: BorderRadius.all(
                              Radius.circular(15.h)),
                        )),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 200.w,
                          margin: EdgeInsets.only(left: 6.w),
                          child: Text(
                            "${item.name}",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          width: 200.w,
                          margin: EdgeInsets.only(left: 6.w),
                          child: Text(
                            "${item.description}",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              color: AppColors.primaryThreeElementText,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    )
                  ]),
              // 右侧
              Container(
                alignment: Alignment.centerRight,
                child: Image(
                  image: AssetImage("assets/icons/arrow_right.png"),
                  width: 24.w,
                  height: 24.h,
                ),
              )
            ],
          )),
    );
  }
}
