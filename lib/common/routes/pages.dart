import 'package:flutter/material.dart';
import 'package:ulearning/common/routes/observers.dart';
import 'package:ulearning/global.dart';
import 'package:ulearning/pages/application/application.dart';
import 'package:ulearning/pages/course/contibitor/contibitor.dart';
import 'package:ulearning/pages/course/course.dart';
import 'package:ulearning/pages/course/course_detail/course_detail.dart';
import 'package:ulearning/pages/course/lesson/lesson.dart';
import 'package:ulearning/pages/course/pay_webview/pay_webview.dart';
import 'package:ulearning/pages/frame/forget/forget.dart';
import 'package:ulearning/pages/frame/register/register.dart';
import 'package:ulearning/pages/frame/sign_in/sign_in.dart';
import 'package:ulearning/pages/frame/welcome/welcome.dart';
import 'package:ulearning/pages/home/home.dart';
import 'package:ulearning/pages/message/chat/chat.dart';
import 'package:ulearning/pages/message/message.dart';
import 'package:ulearning/pages/message/photoview/photoview.dart';
import 'package:ulearning/pages/message/videocall/videocall.dart';
import 'package:ulearning/pages/message/voicecall/voicecall.dart';
import 'package:ulearning/pages/profile/account/account.dart';
import 'package:ulearning/pages/profile/buy_course/buy_course.dart';
import 'package:ulearning/pages/profile/my_course/my_course.dart';
import 'package:ulearning/pages/profile/profile.dart';
import 'package:ulearning/pages/profile/setting/setting.dart';
import 'package:ulearning/pages/search/search.dart';
import 'package:ulearning/pages/unotification/unotification.dart';

import 'routes.dart';

class AppPages {
  static final RouteObserver<Route> observer = RouteObservers();
  static List<String> history = [];

  static List<PageEntity> Routes(){
    return [
      PageEntity(
          path:AppRoutes.INITIAL,
          page:Welcome(),

      ),
      PageEntity(
          path:AppRoutes.Sign_in,
          page:SignIn(),
      ),
      PageEntity(
          path:AppRoutes.Register,
          page:Register(),
      ),
      PageEntity(
          path:AppRoutes.Forget,
          page:Forget(),
      ),
      PageEntity(
          path:AppRoutes.Application,
          page:Application(),
      ),
      PageEntity(
          path:AppRoutes.Home,
          page:Home(),
      ),
      PageEntity(
          path:AppRoutes.Course,
          page:Course(),
      ),
      PageEntity(
          path:AppRoutes.Contibitor,
          page:Contibitor(),
      ),
      PageEntity(
          path:AppRoutes.CourseDetail,
          page:CourseDetail(),
      ),
      PageEntity(
          path:AppRoutes.MyCourse,
          page:MyCourse(),
      ),
      PageEntity(
          path:AppRoutes.BuyCourse,
          page:BuyCourse(),
      ),
      PageEntity(
          path:AppRoutes.Lesson,
          page:Lesson(),
      ),
      PageEntity(
          path:AppRoutes.Message,
          page:Message(),
      ),
      PageEntity(
          path:AppRoutes.Chat,
          page:Chat(),
      ),
      PageEntity(
          path:AppRoutes.Photoview,
          page:PhotoView(),
      ),
      PageEntity(
          path:AppRoutes.VideoCall,
          page:VideoCall(),
      ),
      PageEntity(
          path:AppRoutes.VoiceCall,
          page:VoiceCall(),
      ),
      PageEntity(
          path:AppRoutes.Unotification,
          page:Unotification(),
      ),
      PageEntity(
          path:AppRoutes.Profile,
          page:Profile(),
      ),
      PageEntity(
          path:AppRoutes.Account,
          page:Account(),
      ),
      PageEntity(
          path:AppRoutes.Setting,
          page:Setting(),
      ),
      PageEntity(
          path:AppRoutes.Search,
          page:Search(),
      ),
      PageEntity(
          path:AppRoutes.PayWebview,
          page:PayWebview(),
      ),
    ];
  }



  static MaterialPageRoute GenerateRouteSettings(RouteSettings settings) {

    if(settings.name!=null){
      var result = Routes().where((element) => element.path==settings.name);
      if(result.isNotEmpty){
        // first open App
        bool deviceFirstOpen = Global.storageService.getDeviceFirstOpen();
        if(result.first.path==AppRoutes.INITIAL && deviceFirstOpen){
          bool isLogin = Global.storageService.getIsLogin();
          //is login
          if(isLogin){
            return MaterialPageRoute<void>(builder: (_) => Application(),settings: settings);
          }
          return MaterialPageRoute<void>(builder: (_) => SignIn(),settings: settings);
        }
        return MaterialPageRoute<void>(builder: (_) => result.first.page,settings: settings);
      }
    }

    return MaterialPageRoute<void>(builder: (_) => SignIn(),settings: settings);
  }
}

class PageEntity<T> {
  String path;
  Widget page;

  PageEntity({
    required this.path,
    required this.page,
  });
}
