import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning/common/routes/names.dart';
import 'package:ulearning/common/values/colors.dart';
import 'package:ulearning/common/values/constant.dart';
import 'package:ulearning/global.dart';

class Welcome extends ConsumerStatefulWidget {
  const Welcome({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => Welcome());
  }

  @override
  ConsumerState<Welcome> createState() => _WelcomePage();
}

class _WelcomePage extends ConsumerState<Welcome> {
  PageController pageController = new PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    // "ref" can be used in all life-cycles of a StatefulWidget.
    //ref.read(welcomeProvider).page

  }

  @override
  Widget build(BuildContext context) {

    return Container(
          color: Colors.white,
          child: SafeArea(
          child: Scaffold(
              body: Container(
        width: 375.w,
        margin: EdgeInsets.only(top: 34.h),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            PageView(
              scrollDirection: Axis.horizontal,
              reverse: false,
              onPageChanged: (index) {
                print("------$index");
              },
              controller: pageController,
              pageSnapping: true,
              physics: ClampingScrollPhysics(),
              children: [
                Column(
                  children: [
                    Container(
                      width: 345.w,
                      height: 345.w,
                      child: Image.asset("assets/images/reading.png",
                          fit: BoxFit.fitWidth),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15.h),
                      child: Text("First See Learning",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.normal,
                          )),
                    ),
                    Container(
                      width: 375.w,
                      margin: EdgeInsets.only(top: 15.h),
                      padding: EdgeInsets.only(left: 30.w, right: 30.w),
                      child: Text(
                        "Forget about a for of paper all knowledge in one learning!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.primarySecondaryElementText,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    buildTLogin(context, 1, "Next")
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: 345.w,
                      height: 345.w,
                      child: Image.asset("assets/images/man.png",
                          fit: BoxFit.fitWidth),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15.h),
                      child: Text("Connect With Everyone",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.normal,
                          )),
                    ),
                    Container(
                      width: 375.w,
                      margin: EdgeInsets.only(top: 15.h),
                      padding: EdgeInsets.only(left: 30.w, right: 30.w),
                      child: Text(
                        "Always keep in touch with your tutor & friend. let’s get connected!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.primarySecondaryElementText,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    buildTLogin(context, 2, "Next")
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: 345.w,
                      height: 345.w,
                      child: Image.asset("assets/images/boy.png",
                          fit: BoxFit.fitWidth),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15.h),
                      child: Text("Always Fascinated Learning",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.normal,
                          )),
                    ),
                    Container(
                      width: 375.w,
                      margin: EdgeInsets.only(top: 15.h),
                      padding: EdgeInsets.only(left: 30.w, right: 30.w),
                      child: Text(
                        "Anywhere, anytime. The time is at your discretion so study whenever you want.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.primarySecondaryElementText,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    buildTLogin(context, 3, "Get Started")
                  ],
                ),
              ],
            ),

          ],
        ),
      ))));
  }

  Widget buildTLogin(BuildContext context, int index, String title) {
    return GestureDetector(
        child: Container(
            width: 325.w,
            height: 50.h,
            margin: EdgeInsets.only(top: 100.h, left: 25.w, right: 25.w),
            decoration: BoxDecoration(
              color: AppColors.primaryElement,
              borderRadius: BorderRadius.all(Radius.circular(15.w)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: Center(
                child: Text(
              "${title}",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.primaryBackground,
                fontWeight: FontWeight.normal,
                fontSize: 16.sp,
              ),
            ))),
        onTap: () {
          if (index < 3) {
            pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 500),
              curve: Curves.ease,
            );
          } else {
            Global.storageService.setBool(STORAGE_DEVICE_FIRST_OPEN_KEY, true);
            Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.Sign_in, (Route<dynamic> route) => false);
          }
        });
  }
}
