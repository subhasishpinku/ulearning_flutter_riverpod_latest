import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ulearning/common/entities/entities.dart';
import 'package:ulearning/global.dart';

part 'profile_controller.g.dart';



@riverpod
class ProfileController extends _$ProfileController{

  @override
  UserItem build()=>Global.storageService.getUserProfile();

}
