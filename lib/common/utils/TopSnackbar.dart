import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning/common/apis/chat.dart';
import 'package:ulearning/common/entities/entities.dart';
import 'package:ulearning/common/values/colors.dart';
import 'package:ulearning/global.dart';

class TopSnackbar extends StatefulWidget {
  const TopSnackbar({super.key});

  @override
  TopSnackbarState createState() => TopSnackbarState();
}

class TopSnackbarState extends State<TopSnackbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _position;
  bool _isShow = false;
  String _toName = "";
  String _toToken = "";
  String _toAvatar = "";
  String _docId = "";
  String _callRole = "";
  String _title = "";
  String _routeName = "";


  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 750));
    _position = Tween<Offset>(begin: Offset(0.0, -1), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.decelerate));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> show(String to_name,String to_token,String to_avatar,String doc_id,String call_role,String title,String route_name) {
    _isShow = true;
    setState(() {
      _toName = to_name;
      _toToken = to_token;
      _toAvatar = to_avatar;
      _docId = doc_id;
      _callRole = call_role;
      _title = title;
      _routeName = route_name;
    });
    return _animationController.forward();
  }

  bool isShow() {
   return _isShow;
  }

  hide() async{
    _isShow = false;
    _animationController.reverse();
    setState(() {
      _toName = "";
      _toToken = "";
      _toAvatar = "";
      _docId = "";
      _callRole = "";
      _title = "";
      _routeName = "";
    });

  }
   _sendNotifications(String call_type, String to_token,
      String to_avatar, String to_name, String doc_id) async {
    CallRequestEntity callRequestEntity = new CallRequestEntity();
    callRequestEntity.call_type = call_type;
    callRequestEntity.to_token = to_token;
    callRequestEntity.to_avatar = to_avatar;
    callRequestEntity.doc_id = doc_id;
    callRequestEntity.to_name = to_name;
    var res = await ChatAPI.call_notifications(params: callRequestEntity);
    if (res.code == 0) {
      print("sendNotifications success");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (BuildContext context) {
            return Stack(alignment: Alignment.topCenter, children: <Widget>[
              SlideTransition(
                  position: _position,
                  child:  GestureDetector(
                    onPanEnd: (DragEndDetails e){
                      //打印滑动结束时在x、y轴上的速度
                      if(e.velocity.pixelsPerSecond.dy<-50){
                        hide();
                      }
                    },
                      behavior: HitTestBehavior.translucent,
                      child: Container(
                        width: 340.w,
                        height: 70.w,
                        margin: EdgeInsets.only(top: 40.h),
                        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          borderRadius: BorderRadius.all(Radius.circular(5.w)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                      height: 70.w,
                                      width: 70.w,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                "https://ulearning.codemain.top/uploads/default.png"),
                                            fit: BoxFit.fill),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.h)),
                                      )),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 135.w,
                                        margin: EdgeInsets.only(left: 10.w),
                                        child: Text(
                                          "${_toName}",
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
                                        width: 135.w,
                                        margin: EdgeInsets.only(left: 10.w),
                                        child: Text(
                                          "Video Call",
                                          overflow: TextOverflow.clip,
                                          maxLines: 1,
                                          style: TextStyle(
                                            color:
                                            AppColors.primaryThreeElementText,
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ]),
                            // 右侧
                            Row(children: [
                              GestureDetector(child:Container(
                                width: 40.w,
                                height: 40.w,
                                padding: EdgeInsets.all(10.w),
                                margin: EdgeInsets.only(left: 10.w,right: 10.w),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryElementBg,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(30.w)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 3,
                                      offset: Offset(0, 1), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Image.asset(
                                    "assets/icons/a_phone.png"),
                              ),onTap: (){
                                hide();
                                _sendNotifications("cancel",_toToken,_toAvatar,_toName,_docId);
                              },),
                              GestureDetector(child:Container(
                                width: 40.w,
                                height: 40.w,
                                padding: EdgeInsets.all(10.w),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryElementStatus,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(30.w)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 3,
                                      offset: Offset(0, 1), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Image.asset(
                                    "assets/icons/a_telephone.png"),
                              ),onTap: (){
                                if(Global.navigatorKey.currentContext!=null){
                                  Navigator.of(Global.navigatorKey.currentContext!)
                                      .pushNamed(_routeName, arguments: {
                                    "to_token": _toToken,
                                    "to_name": _toName,
                                    "to_avatar": _toAvatar,
                                    "doc_id": _docId,
                                    "call_role": _callRole
                                  });
                                }
                                hide();
                              },)
                            ],)
                          ],
                        ),
                      ),
                  ))
            ]);
          },
        ),
      ],
    );
  }
}
