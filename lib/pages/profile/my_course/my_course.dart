import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning/common/entities/course.dart';
import 'package:ulearning/common/routes/routes.dart';
import 'package:ulearning/common/values/colors.dart';
import 'package:ulearning/pages/profile/my_course/my_course_controller.dart';

class MyCourse extends ConsumerStatefulWidget {
  const MyCourse({super.key});

  @override
  ConsumerState<MyCourse> createState() => _MyCoursePage();
}

class _MyCoursePage extends ConsumerState<MyCourse> {


  @override
  Widget build(BuildContext context) {
    final asyncCourseList = ref.watch(asyncNotifierMyCourseControllerProvider);
      return Container(
          color: Colors.white,
          child: SafeArea(
          child: Scaffold(
        appBar: _buildAppBar(),
        backgroundColor: Colors.white,
        body: switch (asyncCourseList) {
          AsyncData(:final value) => value==null
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
                vertical: 0,
                horizontal: 25.w,
              ),
              sliver: SliverToBoxAdapter(child: _menuView()),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(
                vertical: 10.h,
                horizontal: 25.w,
              ),
              sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (content, index) {
                      var item = value.elementAt(index);
                      return _buildListItem(item);
                    },
                    childCount: value.length,
                  )),
            ),
          ]),
          AsyncError(:final error) =>Text('Error: $error'),
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
        title: Text(
          "My Courses",
          style: TextStyle(
            color: AppColors.primaryText,
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ));
  }


  Widget _menuView() {
    return Container(
        width: 325.w,
        margin: EdgeInsets.only(
          top: 15.h,
          bottom: 5.h,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 0.h, top: 0.h),
              child: Text(
                "My All Courses",
                style: TextStyle(
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildListItem(CourseItem item) {
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
            Navigator.of(context).pushNamed(AppRoutes.CourseDetail,arguments:{"id":item.id});
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
                          width: 180.w,
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
                          width: 180.w,
                          margin: EdgeInsets.only(left: 6.w),
                          child: Text(
                            "${item.lesson_num} Lesson",
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
                width: 55.w,
                alignment: Alignment.centerRight,
                child: Text(
                  "\$${item.price}",
                  maxLines: 2,
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          )),
    );
  }
}
