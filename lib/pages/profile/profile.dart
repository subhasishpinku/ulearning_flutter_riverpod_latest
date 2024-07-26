import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning/common/routes/names.dart';
import 'package:ulearning/common/values/colors.dart';
import 'package:ulearning/pages/profile/profile_controller.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfilePage();
}

class _ProfilePage extends ConsumerState<Profile> {


  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(profileControllerProvider);
      return Scaffold(
        appBar: _buildAppBar(),
        backgroundColor: Colors.white,
        body: CustomScrollView(slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(
              vertical: 30.h,
              horizontal: 25.w,
            ),
            sliver: SliverToBoxAdapter(
                child: Container(
              child: Column(
                children: [
                  Container(
                    width: 80.w,
                    height: 80.h,
                    decoration: userProfile.avatar == null
                        ? BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/icons/headpic.png')),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.w)),
                          )
                        : BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    userProfile.avatar ?? "")),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.w)),
                          ),
                    child: Container(
                      alignment: Alignment.bottomRight,
                      padding: EdgeInsets.only(right: 6.w),
                      child: Image(
                        image: AssetImage("assets/icons/edit_3.png"),
                        width: 25.w,
                        height: 25.h,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 12.w),
                    child: Text(
                      userProfile.name != null
                          ? "${userProfile.name}"
                          : "",
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  userProfile.description == null
                      ? Container()
                      : Container(
                          padding: EdgeInsets.only(left: 50.w, right: 50.w),
                          margin: EdgeInsets.only(bottom: 10.h, top: 5.h),
                          child: Text(
                            "${userProfile.description}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.primarySecondaryElementText,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                ],
              ),
            )),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              vertical: 0.h,
              horizontal: 25.w,
            ),
            sliver: SliverToBoxAdapter(
                child: Container(
                    child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    child: Container(
                      width: 100.w,
                      padding: EdgeInsets.only(top: 7.h, bottom: 7.h),
                      decoration: BoxDecoration(
                          color: AppColors.primaryElement,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(15.w)),
                          border: Border.all(color: AppColors.primaryElement)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 20.w,
                            height: 20.h,
                            child:
                                Image.asset("assets/icons/profile_video.png"),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5.h),
                            child: Text(
                              "My Courses",
                              style: TextStyle(
                                color: AppColors.primaryElementText,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.MyCourse);
                    }),
                GestureDetector(
                    child: Container(
                      width: 100.w,
                      padding: EdgeInsets.only(top: 7.h, bottom: 7.h),
                      decoration: BoxDecoration(
                          color: AppColors.primaryElement,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(15.w)),
                          border: Border.all(color: AppColors.primaryElement)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 20.w,
                            height: 20.h,
                            child: Image.asset("assets/icons/profile_book.png"),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5.h),
                            child: Text(
                              "Buy Courses",
                              style: TextStyle(
                                color: AppColors.primaryElementText,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.BuyCourse);
                    }),
                GestureDetector(
                    child: Container(
                      width: 100.w,
                      padding: EdgeInsets.only(top: 7.h, bottom: 7.h),
                      decoration: BoxDecoration(
                          color: AppColors.primaryElement,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(15.w)),
                          border: Border.all(color: AppColors.primaryElement)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 20.w,
                            height: 20.h,
                            child: Image.asset("assets/icons/profile_star.png"),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5.h),
                            child: Text(
                              "4.9",
                              style: TextStyle(
                                color: AppColors.primaryElementText,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {

                    }),
              ],
            ))),
          ),
          SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 25.w),
              sliver: SliverToBoxAdapter(
                child: _buildListView(context),
              )),
        ]),
      );

  }

  AppBar _buildAppBar() {
    return AppBar(
        title: Container(
      margin: EdgeInsets.only(left: 7.w, right: 7.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 18.w,
            height: 12.h,
            child: Image.asset("assets/icons/menu.png"),
          ),
          Container(
            child: Text(
              "Profile",
              style: TextStyle(
                color: AppColors.primaryText,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
          ),
          Container(
            width: 24.w,
            height: 24.h,
            child: Image.asset("assets/icons/more-vertical.png"),
          ),
        ],
      ),
    ));
  }

  Widget _buildListView(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          child: Container(
            margin: EdgeInsets.only(bottom: 15.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 40.h,
                  height: 40.h,
                  padding: EdgeInsets.all(7.w),
                  decoration: BoxDecoration(
                      color: AppColors.primaryElement,
                      borderRadius: BorderRadius.all(Radius.circular(10.w)),
                      border: Border.all(color: AppColors.primaryElement)),
                  child: Image.asset("assets/icons/settings.png"),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15.w),
                  child: Text(
                    "Settings",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.of(context).pushNamed(AppRoutes.Setting);
          },
        ),
        GestureDetector(
          child: Container(
            margin: EdgeInsets.only(bottom: 15.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 40.h,
                  height: 40.h,
                  padding: EdgeInsets.all(7.w),
                  decoration: BoxDecoration(
                      color: AppColors.primaryElement,
                      borderRadius: BorderRadius.all(Radius.circular(10.w)),
                      border: Border.all(color: AppColors.primaryElement)),
                  child: Image.asset("assets/icons/credit-card.png"),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15.w),
                  child: Text(
                    "Payment Details",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.of(context).pushNamed(AppRoutes.Account);
          },
        ),
        Container(
          margin: EdgeInsets.only(bottom: 15.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 40.h,
                height: 40.h,
                padding: EdgeInsets.all(7.w),
                decoration: BoxDecoration(
                    color: AppColors.primaryElement,
                    borderRadius: BorderRadius.all(Radius.circular(10.w)),
                    border: Border.all(color: AppColors.primaryElement)),
                child: Image.asset("assets/icons/award.png"),
              ),
              Container(
                margin: EdgeInsets.only(left: 15.w),
                child: Text(
                  "Achievement",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 15.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 40.h,
                height: 40.h,
                padding: EdgeInsets.all(7.w),
                decoration: BoxDecoration(
                    color: AppColors.primaryElement,
                    borderRadius: BorderRadius.all(Radius.circular(10.w)),
                    border: Border.all(color: AppColors.primaryElement)),
                child: Image.asset("assets/icons/heart(1).png"),
              ),
              Container(
                margin: EdgeInsets.only(left: 15.w),
                child: Text(
                  "Love",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 15.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 40.h,
                height: 40.h,
                padding: EdgeInsets.all(7.w),
                decoration: BoxDecoration(
                    color: AppColors.primaryElement,
                    borderRadius: BorderRadius.all(Radius.circular(10.w)),
                    border: Border.all(color: AppColors.primaryElement)),
                child: Image.asset("assets/icons/cube.png"),
              ),
              Container(
                margin: EdgeInsets.only(left: 15.w),
                child: Text(
                  "Learning Reminders",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
