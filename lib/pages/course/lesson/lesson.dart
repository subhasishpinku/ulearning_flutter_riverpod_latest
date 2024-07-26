import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ulearning/common/entities/entities.dart';
import 'package:ulearning/common/values/colors.dart';
import 'package:ulearning/common/widgets/widgets.dart';
import 'package:ulearning/pages/course/lesson/lesson_logic.dart';
import 'package:ulearning/pages/course/lesson/notifiers/lesson_notifier.dart';
import 'package:video_player/video_player.dart';

class Lesson extends ConsumerStatefulWidget {
  const Lesson({super.key});

  @override
  ConsumerState<Lesson> createState() => _LessonPage();
}

class _LessonPage extends ConsumerState<Lesson> {
  late LessonLogic lessonLogic;

  int video_index = 0;

  @override
  void initState() {
    super.initState();
    lessonLogic = LessonLogic(ref: ref);
    Future.delayed(Duration.zero,(){
      ref.read(lessonProvider.notifier).onUrlItemChanged(UrlItemChanged(null));
      lessonLogic.init();
    });
  }

  @override
  void dispose() {
    lessonLogic.videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(lessonProvider);
      return Container(
          color: Colors.white,
          child: SafeArea(
          child: Scaffold(
        appBar: _buildAppBar(),
        backgroundColor: Colors.white,
        body: CustomScrollView(slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(
              vertical: 20.h,
              horizontal: 25.w,
            ),
            sliver: SliverToBoxAdapter(
              child: Container(
                child: Column(
                  children: [
                    Container(
                      width: 325.w,
                      height: 200.h,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/icons/Video.png'),
                          fit: BoxFit.fitWidth,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20.h)),
                      ),
                      child: FutureBuilder(
                        future: state.initializeVideoPlayerFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return lessonLogic.videoController==null?Container():AspectRatio(
                              aspectRatio: lessonLogic.videoController!.value.aspectRatio,
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: <Widget>[
                                  VideoPlayer(lessonLogic.videoController!),
                                  VideoProgressIndicator(lessonLogic.videoController!, allowScrubbing: true,colors: VideoProgressColors(playedColor: AppColors.primaryElement),),
                                ],
                              ),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 15.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              child: Container(
                                width: 24.w,
                                height: 24.h,
                                margin: EdgeInsets.only(right: 15.w),
                                child:
                                    Image.asset("assets/icons/rewind-left.png"),
                              ),
                              onTap: () {
                                video_index = video_index - 1;
                                if (video_index < 0) {
                                  video_index = 0;
                                  toastInfo(msg: 'No previous video');
                                  return;
                                }
                                var video_item = state.lessonItem.elementAt(video_index);
                                  lessonLogic.playVideo(video_item.url!);

                              },
                            ),
                            GestureDetector(
                              child: state.isPlay?Container(
                                width: 24.w,
                                height: 24.h,
                                child: Image.asset("assets/icons/pause.png"),
                              ):Container(
                                width: 24.w,
                                height: 24.h,
                                child: Image.asset("assets/icons/play-circle.png"),
                              ),
                              onTap: () {
                                if(state.isPlay){
                                  lessonLogic.videoController?.pause();
                                  ref.read(lessonProvider.notifier).onIsPlayChanged(IsPlayChanged(false));
                                }else{
                                  lessonLogic.videoController?.play();
                                  ref.read(lessonProvider.notifier).onIsPlayChanged(IsPlayChanged(true));
                                }

                              },
                            ),
                            GestureDetector(
                              child: Container(
                                width: 24.w,
                                height: 24.h,
                                margin: EdgeInsets.only(left: 15.w),
                                child: Image.asset(
                                    "assets/icons/rewind-right.png"),
                              ),
                              onTap: () {
                                // video_index
                                video_index = video_index + 1;
                                if (video_index >= state.lessonItem.length) {
                                  video_index = video_index - 1;
                                  toastInfo(msg: 'No next video！');
                                  return;
                                }
                                var video_item = state.lessonItem.elementAt(video_index);
                                lessonLogic.playVideo(video_item.url!);
                              },
                            ),
                          ],
                        )),
                    // Container(
                    //   margin: EdgeInsets.only(top:12.h),
                    //   child: Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Container(
                    //       child: Text(
                    //         "1:01",
                    //         textAlign: TextAlign.start,
                    //         style: TextStyle(
                    //           color: AppColors.primarySecondaryElementText,
                    //           fontWeight: FontWeight.normal,
                    //           fontSize: 13.sp,
                    //         ),
                    //       ),
                    //     ),
                    //     Container(
                    //       child: Text(
                    //         " | ",
                    //         textAlign: TextAlign.start,
                    //         style: TextStyle(
                    //           color: AppColors.primarySecondaryElementText,
                    //           fontWeight: FontWeight.normal,
                    //           fontSize: 13.sp,
                    //         ),
                    //       ),
                    //     ),
                    //     Container(
                    //       child: Text(
                    //         "7:23",
                    //         textAlign: TextAlign.start,
                    //         style: TextStyle(
                    //           color: AppColors.primarySecondaryElementText,
                    //           fontWeight: FontWeight.normal,
                    //           fontSize: 13.sp,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),)
                  ],
                ),
              ),
            ),
          ),
          // SliverPadding(
          //   padding: EdgeInsets.symmetric(
          //     vertical: 0,
          //     horizontal: 25.w,
          //   ),
          //   sliver: SliverToBoxAdapter(child: _menuView(context, state)),
          // ),
          SliverPadding(
            padding: EdgeInsets.only(
              top: 0.h,
              left: 25.w,
              right: 25.w,
            ),
            sliver: SliverToBoxAdapter(
              child: Container(
                child: Text(
                  "All Video",
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
                return _buildListItem(
                    content,index, state.lessonItem.elementAt(index));
              },
              childCount: state.lessonItem.length,
            )),
          ),
        ]),
      )));

  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Container(
        child: Text(
          "Lessons",
          style: TextStyle(
            color: AppColors.primaryText,
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }

  Widget _menuView(BuildContext context, state) {
    return Container(
        width: 325.w,
        margin: EdgeInsets.only(
          top: 0.h,
          bottom: 0.h,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Image(
                      image: AssetImage("assets/icons/heart.png"),
                      width: 16.w,
                      height: 16.h,
                    ),
                  ),
                  Container(
                    child: Text(
                      "20 Love",
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
                      image: AssetImage("assets/icons/message.png"),
                      width: 16.w,
                      height: 16.h,
                    ),
                  ),
                  Container(
                    child: Text(
                      "06 Comments",
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
                      "13 Download",
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

  Widget _buildListItem(BuildContext context,int index, LessonVideoItem item) {
    return Container(
      width: 325.w,
      height: 80.h,
      margin: EdgeInsets.only(
        bottom: 20.h,
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
            video_index = index;
            lessonLogic.playVideo(item.url!);
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
                              image: NetworkImage("${item.thumbnail}"),
                              fit: BoxFit.fill),
                          borderRadius: BorderRadius.all(Radius.circular(15.h)),
                        )),
                    Container(
                      width: 210.w,
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
                  ]),
              // 右侧
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "play",
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }
}
