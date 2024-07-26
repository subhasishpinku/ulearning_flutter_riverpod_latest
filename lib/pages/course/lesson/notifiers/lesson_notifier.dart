
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulearning/common/entities/entities.dart';

part 'lesson_event.dart';
part 'lesson_state.dart';

class LessonNotifier extends StateNotifier<LessonState> {
  LessonNotifier() : super(const LessonState()) {

  }

  void onLessonItemChanged(
      LessonVideoItemChanged event,
      ) {
    state = state.copyWith(lessonItem: event.lessonItem);
  }

  void onUrlItemChanged(
      UrlItemChanged event,
      ) {
    state = state.copyWith(initializeVideoPlayerFuture: event.initializeVideoPlayerFuture);
  }
  void onIsPlayChanged(
      IsPlayChanged event,
      ) {
    state = state.copyWith(isPlay: event.isPlay);
  }

}
final lessonProvider = StateNotifierProvider<LessonNotifier, LessonState>((ref) {
  return LessonNotifier();
});