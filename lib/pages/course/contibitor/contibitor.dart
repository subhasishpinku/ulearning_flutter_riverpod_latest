import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning/common/entities/course.dart';
import 'package:ulearning/common/entities/msg.dart';
import 'package:ulearning/common/entities/user.dart';
import 'package:ulearning/common/routes/names.dart';
import 'package:ulearning/common/values/colors.dart';
import 'package:ulearning/common/widgets/toast.dart';
import 'package:ulearning/global.dart';
import 'package:ulearning/pages/course/contibitor/contibitor_controller.dart';

class Contibitor extends ConsumerStatefulWidget {
  const Contibitor({super.key});

  @override
  ConsumerState<Contibitor> createState() => _ContibitorPage();
}

class _ContibitorPage extends ConsumerState<Contibitor> {

  //
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero,(){
      final args = ModalRoute.of(ref.context)!.settings.arguments as Map;
      print(args);
      ref.read(asyncNotifierContibitorControllerProvider.notifier).init(args["token"]);
      ref.read(asyncNotifierContibitorAuthorControllerProvider.notifier).init(args["token"]);
    });

  }

  goChat(AuthorItem authorItem) async {
    final db = FirebaseFirestore.instance;
    UserItem userProfile = Global.storageService.getUserProfile();

    if (authorItem.token == userProfile.token) {
      toastInfo(msg: "Can't chat with yourself！");
      return;
    }
    var from_messages = await db
        .collection("message")
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (Msg msg, options) => msg.toFirestore(),
        )
        .where("from_token", isEqualTo: userProfile.token)
        .where("to_token", isEqualTo: authorItem.token)
        .get();
    var to_messages = await db
        .collection("message")
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (Msg msg, options) => msg.toFirestore(),
        )
        .where("from_token", isEqualTo: authorItem.token)
        .where("to_token", isEqualTo: userProfile.token)
        .get();

    if (from_messages.docs.isEmpty && to_messages.docs.isEmpty) {
      print("----from_messages--to_messages--empty--");
      var msgdata = new Msg(
        from_token: userProfile.token,
        to_token: authorItem.token,
        from_name: userProfile.name,
        to_name: authorItem.name,
        from_avatar: userProfile.avatar,
        to_avatar: authorItem.avatar,
        from_online: userProfile.online,
        to_online: authorItem.online,
        last_msg: "",
        last_time: Timestamp.now(),
        msg_num: 0,
      );
      var doc_id = await db
          .collection("message")
          .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (Msg msg, options) => msg.toFirestore(),
          )
          .add(msgdata);
      Navigator.of(ref.context).pushNamed(AppRoutes.Chat, arguments: {
        "doc_id": doc_id.id,
        "to_token": authorItem.token ?? "",
        "to_name": authorItem.name ?? "",
        "to_avatar": authorItem.avatar ?? "",
        "to_online": authorItem.online.toString()
      });
    } else {
      if (!from_messages.docs.isEmpty) {
        print("---from_messages");
        print(from_messages.docs.first.id);
        Navigator.of(ref.context).pushNamed(AppRoutes.Chat, arguments: {
          "doc_id": from_messages.docs.first.id,
          "to_token": authorItem.token ?? "",
          "to_name": authorItem.name ?? "",
          "to_avatar": authorItem.avatar ?? "",
          "to_online": authorItem.online.toString()
        });
      }
      if (!to_messages.docs.isEmpty) {
        print("---to_messages");
        print(to_messages.docs.first.id);
        Navigator.of(ref.context).pushNamed(AppRoutes.Chat, arguments: {
          "doc_id": to_messages.docs.first.id,
          "to_token": authorItem.token ?? "",
          "to_name": authorItem.name ?? "",
          "to_avatar": authorItem.avatar ?? "",
          "to_online": authorItem.online.toString()
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final contibitorAuthor = ref.watch(asyncNotifierContibitorAuthorControllerProvider);
    final courseItem = ref.watch(asyncNotifierContibitorControllerProvider);
    return Container(
        color: Colors.white,
        child: SafeArea(
            child: Scaffold(
                appBar: _buildAppBar(),
                backgroundColor: Colors.white,
                body: switch (contibitorAuthor) {
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
                        vertical: 20.h,
                        horizontal: 25.w,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Container(
                          width: 325.w,
                          height: 220.h,
                          child: Stack(
                            children: [
                              Container(
                                width: 325.w,
                                height: 160.h,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/icons/background.png'),
                                    fit: BoxFit.fitWidth,
                                  ),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(20.h)),
                                ),
                              ),
                              Positioned(
                                  bottom: 0,
                                  left: 0,
                                  child: _menuView(value))
                            ],
                          ),
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
                            margin: EdgeInsets.only(top: 0.h),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    "About Me",
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
                                    "${value.description}",
                                    textAlign: TextAlign.start,
                                    strutStyle: StrutStyle(height: 1),
                                    style: TextStyle(
                                      color:
                                      AppColors.primaryThreeElementText,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  child: Container(
                                    width: 330.w,
                                    height: 50.h,
                                    margin: EdgeInsets.only(top: 20.h),
                                    padding: EdgeInsets.only(
                                        left: 15.w,
                                        right: 15.w,
                                        top: 13.h,
                                        bottom: 5.h),
                                    decoration: BoxDecoration(
                                        color: AppColors.primaryElement,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.w)),
                                        border: Border.all(
                                            color: AppColors.primaryElement)),
                                    child: Text(
                                      "Go Chat",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppColors.primaryElementText,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    goChat(value);
                                  },
                                ),
                              ],
                            ),
                          )),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.only(
                        top: 28.h,
                        left: 25.w,
                        right: 25.w,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Container(
                          child: Text(
                            "Author Courese List",
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
                              var item = courseItem.value!.elementAt(index);
                              return _buildListItem(content, item);
                            },
                            childCount: courseItem.value?.length,
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
                })));
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Container(
        child: Text(
          "Contibitor",
          style: TextStyle(
            color: AppColors.primaryText,
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }

  Widget _menuView(AuthorItem? authorItem) {
    return Container(
        width: 325.w,
        margin: EdgeInsets.only(
          top: 0.h,
          bottom: 0.h,
          left: 20.w,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            authorItem == null
                ? Container()
                : Container(
                    width: 80.h,
                    height: 80.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage("${authorItem.avatar}"),
                        fit: BoxFit.fitWidth,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20.w)),
                    ),
                  ),
            Container(
              margin: EdgeInsets.only(top: 0.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 50.h),
                  Container(
                    margin: EdgeInsets.only(left: 6.w),
                    child: Text(
                      "${authorItem != null ? authorItem.name : ""}",
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 6.w, bottom: 10.h, top: 5.h),
                    child: Text(
                      "${authorItem != null ? authorItem!.job : ""}",
                      style: TextStyle(
                        color: AppColors.primarySecondaryElementText,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 20.w),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Image(
                                image: AssetImage("assets/icons/people.png"),
                                width: 16.w,
                                height: 16.h,
                              ),
                            ),
                            Container(
                              child: Text(
                                "${authorItem != null ? authorItem!.follow : ""}",
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
                        margin: EdgeInsets.only(right: 20.w),
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
                                "${authorItem != null ? authorItem.score : "0"}",
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
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Image(
                                image: AssetImage("assets/icons/download.png"),
                                width: 16.w,
                                height: 16.h,
                              ),
                            ),
                            Container(
                              child: Text(
                                "${authorItem != null ? authorItem.download : "0"}",
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
                  )
                ],
              ),
            )
          ],
        ));
  }

  Widget _buildListItem(BuildContext context, CourseItem item) {
    return Container(
      width: 325.w,
      height: 80.h,
      margin: EdgeInsets.only(
        bottom: 15.h,
      ),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 1),
        borderRadius: BorderRadius.all(Radius.circular(10.w)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: InkWell(
          onTap: () {
            Navigator.of(context)
                .pushNamed(AppRoutes.CourseDetail, arguments: {"id": item.id});
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
                        margin: EdgeInsets.only(left: 5.w),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage("${item.thumbnail}"),
                              fit: BoxFit.fill),
                          borderRadius: BorderRadius.all(Radius.circular(15.h)),
                        )),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 230.w,
                          margin: EdgeInsets.only(left: 10.w),
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
                          width: 230.w,
                          margin: EdgeInsets.only(left: 10.w),
                          child: Text(
                            "${item.lesson_num} lesson",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              color: AppColors.primaryThreeElementText,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        // Container(
                        //   margin: EdgeInsets.only(left: 6.w),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        //     children: [
                        //       Container(
                        //         alignment: Alignment.center,
                        //         child: Image(
                        //           image: AssetImage("assets/icons/star(1).png"),
                        //           width: 10.w,
                        //           height: 10.h,
                        //         ),
                        //       ),
                        //       Container(
                        //         child: Text(
                        //           "${state.courseItem.elementAt(index).score}",
                        //           style: TextStyle(
                        //             color: AppColors.primaryThreeElementText,
                        //             fontWeight: FontWeight.normal,
                        //             fontSize: 9.sp,
                        //           ),
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // ),
                      ],
                    )
                  ]),
            ],
          )),
    );
  }
}
