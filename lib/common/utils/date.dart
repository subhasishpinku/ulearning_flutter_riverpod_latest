
import 'dart:io';

import 'package:intl/intl.dart';

String timeFormated(String? time){
  final DateTime now = time==null?DateTime.now().toLocal():DateTime.parse(time).toLocal();
  final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss',Platform.localeName);
  return formatter.format(now);
}

/// 格式化时间
String duTimeLineFormat(DateTime dt) {

  var now = DateTime.now();
  var difference = now.difference(dt);
  if (difference.inSeconds < 60) {
    if(difference.inSeconds<0){
      return "0s ago";
    }
    return "${difference.inSeconds}s ago";
  }
  if (difference.inMinutes < 60) {
    return "${difference.inMinutes}m ago";
  }
  // 1天内
  if (difference.inHours < 24) {
    return "${difference.inHours}h ago";
  }
  // 30天内
  else if (difference.inDays < 30) {
    return "${difference.inDays}d ago";
  }
  // MM-dd
  else if (difference.inDays < 365) {
    final dtFormat = new DateFormat('MM-dd',Platform.localeName);
    return dtFormat.format(dt);
  }
  // yyyy-MM-dd
  else {
    final dtFormat = new DateFormat('yyyy-MM-dd',Platform.localeName);
    var str = dtFormat.format(dt);
    return str;
  }
}
