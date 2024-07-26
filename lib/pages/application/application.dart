import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulearning/pages/application/controller/application_controller.dart';
import 'package:ulearning/pages/course/course.dart';
import 'package:ulearning/pages/home/home.dart';
import 'package:ulearning/pages/message/message.dart';
import 'package:ulearning/pages/profile/profile.dart';
import 'package:ulearning/pages/search/search.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning/common/values/colors.dart';


class Application extends ConsumerStatefulWidget{
  const Application({super.key});
  @override
  ConsumerState<Application> createState() => _ApplicationPage();
}

class _ApplicationPage extends ConsumerState<Application> with WidgetsBindingObserver{
  PageController pageController = new PageController(initialPage: 0);
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,(){
      ref.read(applicationControllerProvider.notifier).init();
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("-didChangeAppLifecycleState-" + state.toString());
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        print("处于这种状态的应用程序应该假设它们可能在任何时候暂停。");
        break;
      case AppLifecycleState.resumed: //从后台切换前台，界面可见
        ref.read(applicationControllerProvider.notifier).CallVocieOrVideo();
        print("从后台切换前台，界面可见");
        break;
      case AppLifecycleState.paused: // 界面不可见，后台
        print("界面不可见，后台");
        break;
      case AppLifecycleState.detached: // APP结束时调用
        break;
        default:
          break;
    }
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final index = ref.watch(applicationControllerProvider);
    return Container(
      color: Colors.white,
      child: SafeArea(
          child: Scaffold(
              body: buildPageView(pageController),
              bottomNavigationBar:Container(
                  width: 375.w,
                  height: 58.h,
                  decoration: BoxDecoration(
                    color: AppColors.primaryElement,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.h),
                        topRight: Radius.circular(20.h)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 0), // changes position of shadow
                      ),
                    ],
                  ),
                  child: BottomNavigationBar(
                    elevation: 0,
                    items: bottomTabs,
                    currentIndex: index,
                    type: BottomNavigationBarType.fixed,
                    onTap: (value) {
                      ref.read(applicationControllerProvider.notifier).changeIndex(value);
                      pageController.jumpToPage(value);
                    },
                    showSelectedLabels: false,
                    showUnselectedLabels: false,
                    unselectedItemColor: AppColors.primaryFourElementText,
                    selectedItemColor: AppColors.primaryElement,
                  ),
                )
              )),
    );
  }


  Widget buildPageView(PageController pageController) {
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Home(),
        Search(),
        Course(),
        Message(),
        Profile(),
      ],
      controller: pageController,
      onPageChanged: (value) {},
    );
  }

  var bottomTabs = <BottomNavigationBarItem>[
    new BottomNavigationBarItem(
      icon: Container(
          width: 15.w,
          height: 15.w,
          child: Image.asset(
            "assets/icons/home.png",
            color: AppColors.primaryFourElementText,
          )),
      activeIcon: Container(
        width: 15.w,
        height: 15.w,
        child: Image.asset(
          "assets/icons/home.png",
          color: AppColors.primaryElement,
        ),
      ),
      label: "home",
      backgroundColor: AppColors.primaryBackground,
    ),
    new BottomNavigationBarItem(
      icon: Container(
          width: 15.w,
          height: 15.w,
          child: Image.asset(
            "assets/icons/search2.png",
            color: AppColors.primaryFourElementText,
          )),
      activeIcon: Container(
        width: 15.w,
        height: 15.w,
        child: Image.asset(
          "assets/icons/search2.png",
          color: AppColors.primaryElement,
        ),
      ),
      label: "search",
      backgroundColor: AppColors.primaryBackground,
    ),
    new BottomNavigationBarItem(
      icon: Container(
        width: 15.w,
        height: 15.w,
        child: Image.asset(
          "assets/icons/play-circle1.png",
          color: AppColors.primaryFourElementText,
        ),
      ),
      activeIcon: Container(
        width: 15.w,
        height: 15.w,
        child: Image.asset(
          "assets/icons/play-circle1.png",
          color: AppColors.primaryElement,
        ),
      ),
      label: "play",
      backgroundColor: AppColors.primaryBackground,
    ),
    new BottomNavigationBarItem(
      icon: Container(
        width: 15.w,
        height: 15.w,
        child: Image.asset(
          "assets/icons/message-circle.png",
          color: AppColors.primaryFourElementText,
        ),
      ),
      activeIcon: Container(
        width: 15.w,
        height: 15.w,
        child: Image.asset(
          "assets/icons/message-circle.png",
          color: AppColors.primaryElement,
        ),
      ),
      label: "message",
      backgroundColor: AppColors.primaryBackground,
    ),
    new BottomNavigationBarItem(
      icon: Container(
        width: 15.w,
        height: 15.w,
        child: Image.asset(
          "assets/icons/person2.png",
          color: AppColors.primaryFourElementText,
        ),
      ),
      activeIcon: Container(
        width: 15.w,
        height: 15.w,
        child: Image.asset(
          "assets/icons/person2.png",
          color: AppColors.primaryElement,
        ),
      ),
      label: "person",
      backgroundColor: AppColors.primaryBackground,
    ),
  ];

}
