part of 'lesson_notifier.dart';

class LessonState extends Equatable {
  const LessonState({
    this.lessonItem=const <LessonVideoItem>[],
    this.initializeVideoPlayerFuture,
    this.isPlay = false,
  });

  final List<LessonVideoItem> lessonItem;

  final Future<void>? initializeVideoPlayerFuture;
  final bool isPlay;

  LessonState copyWith({
    List<LessonVideoItem>? lessonItem,
    Future<void>? initializeVideoPlayerFuture,
    bool? isPlay,
  }) {
    return LessonState(
      lessonItem: lessonItem ?? this.lessonItem,
      isPlay: isPlay ?? this.isPlay,
      initializeVideoPlayerFuture: initializeVideoPlayerFuture ?? this.initializeVideoPlayerFuture,
    );
  }

  @override
  List<Object?> get props => [lessonItem,initializeVideoPlayerFuture,isPlay];
}
