import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulearning/common/apis/apis.dart';
import 'package:ulearning/common/entities/entities.dart';
import 'package:ulearning/common/widgets/widgets.dart';
import 'package:ulearning/pages/course/lesson/notifiers/lesson_notifier.dart';
import 'package:video_player/video_player.dart';


class LessonLogic{
  final WidgetRef ref;
  VideoPlayerController? videoController;

  LessonLogic({
    required this.ref,
  });

  void init() async{
    final args = ModalRoute.of(ref.context)!.settings.arguments as Map;
    print(args["id"]);
    ref.read(lessonProvider.notifier).onIsPlayChanged(IsPlayChanged(false));
    await asyncPostLessonData(args["id"]);

  }
  

  asyncPostLessonData(int? id) async {
    print(id);
    LessonRequestEntity lessonRequestEntity = new LessonRequestEntity();
    lessonRequestEntity.id = id;
    var result = await LessonAPI.lessonDetail(params: lessonRequestEntity);
    print("LessonList---");
    print(result.data!.length);
    if(result.code==0){
      ref.read(lessonProvider.notifier).onLessonItemChanged(LessonVideoItemChanged(result.data!));
      if(result.data!.length>0){
        var url = result.data!.elementAt(0).url;
        videoController = VideoPlayerController.network(url!);
        var initializeVideoPlayerFuture = videoController?.initialize();
        ref.read(lessonProvider.notifier).onUrlItemChanged(UrlItemChanged(initializeVideoPlayerFuture));
      }

    }else{
      toastInfo(msg: 'internet error');
    }
  }

  playVideo(String url){
    if(videoController!=null){
      videoController?.pause();
      videoController?.dispose();
    }
    videoController = VideoPlayerController.network(url);

    ref.read(lessonProvider.notifier).onIsPlayChanged(IsPlayChanged(false));
    ref.read(lessonProvider.notifier).onUrlItemChanged(UrlItemChanged(null));
    var initializeVideoPlayerFuture =
        videoController?.initialize().then((_) {
          videoController
              ?.seekTo(Duration(milliseconds: 0));
          videoController?.play();
        });
    ref.read(lessonProvider.notifier).onUrlItemChanged(UrlItemChanged(initializeVideoPlayerFuture));
    ref.read(lessonProvider.notifier).onIsPlayChanged(IsPlayChanged(true));
  }



}