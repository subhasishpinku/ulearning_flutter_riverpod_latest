part of 'lesson_notifier.dart';

abstract class LessonEvent extends Equatable {
  const LessonEvent();

  @override
  List<Object?> get props => [];
}


class LessonVideoItemChanged extends LessonEvent {
  const LessonVideoItemChanged(this.lessonItem);

  final List<LessonVideoItem> lessonItem;

  @override
  List<Object> get props => [lessonItem];
}

class UrlItemChanged extends LessonEvent {

  const UrlItemChanged(this.initializeVideoPlayerFuture);

  final Future<void>? initializeVideoPlayerFuture;

  @override
  List<Object?> get props => [initializeVideoPlayerFuture];
}
class IsPlayChanged extends LessonEvent {

  const IsPlayChanged(this.isPlay);

  final bool isPlay;

  @override
  List<Object> get props => [isPlay];
}