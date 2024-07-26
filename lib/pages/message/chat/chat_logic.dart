import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ulearning/common/apis/chat.dart';
import 'package:ulearning/common/entities/entities.dart';
import 'package:ulearning/common/routes/names.dart';
import 'package:ulearning/common/utils/utils.dart';
import 'package:ulearning/common/widgets/widgets.dart';
import 'package:ulearning/global.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ulearning/pages/message/chat/notifiers/chat_notifier.dart';

class ChatLogic {
  final WidgetRef ref;
  final db = FirebaseFirestore.instance;
  UserItem userProfile = Global.storageService.getUserProfile();
  var doc_id;
  TextEditingController myinputController = TextEditingController();
  ScrollController myscrollController = new ScrollController();
  ScrollController inputScrollController = new ScrollController();
  bool isloadmore = true;
  double inputHeightStatus = 0;
  File? _photo;
  final ImagePicker _picker = ImagePicker();
  StreamSubscription<QuerySnapshot<Object?>>? listener;


  ChatLogic({
    required this.ref,
  });

  void init() {
    final data = ModalRoute.of(ref.context)!.settings.arguments as Map;
    print(data);
    doc_id = data["doc_id"];
    ref.read(chatProvider.notifier).onProfileChanged(ProfileChanged(data["to_token"]??"",data["to_name"]??"",data["to_avatar"]??"",data["to_online"]??"1"));
    _clearMsgNum(doc_id);
    _chatSnapshots();
  }

  void dispose(){
    print("--------dispose");
    _clearMsgNum(doc_id);
    myinputController.dispose();
    inputScrollController.dispose();
  }
  void _chatSnapshots(){
    var mRef = ref;
    mRef.read(chatProvider.notifier).onMsgContentClear(MsgContentClear());
    final messages = db.collection("message").doc(doc_id).collection("msglist").withConverter(
      fromFirestore: Msgcontent.fromFirestore,
      toFirestore: (Msgcontent msgcontent, options) => msgcontent.toFirestore(),
    ).orderBy("addtime", descending: true).limit(15);

    listener = messages.snapshots().listen(
          (event) {
        print("current data: ${event.docs}");
        print("current data: ${event.metadata.hasPendingWrites}");
        List<Msgcontent> tempMsgList = <Msgcontent>[];
        for (var change in event.docChanges) {
          switch (change.type) {
            case DocumentChangeType.added:
              print("added----: ${change.doc.data()}");
              if(change.doc.data()!=null){
                tempMsgList.add(change.doc.data()!);
              }
              break;
            case DocumentChangeType.modified:
              print("Modified City: ${change.doc.data()}");
              break;
            case DocumentChangeType.removed:
              print("Removed City: ${change.doc.data()}");
              break;
          }
        }
        for (var element in tempMsgList.reversed) {
          mRef.read(chatProvider.notifier).onMsgContentListChanged(MsgContentListChanged(element));
        }

        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (myscrollController.hasClients){
            myscrollController.animateTo(
              myscrollController.position.minScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,);
          }
        });

      },
      onError: (error) => print("Listen failed: $error"),
    );
    myscrollController.addListener((){

      if((myscrollController.offset+10)>myscrollController.position.maxScrollExtent){
        if(isloadmore){
          mRef.read(chatProvider.notifier).onIsloadingChanged(isloadingChanged(true));
          isloadmore = false;
          _asyncLoadMoreData(mRef.read(chatProvider).msgcontentList.toList().length);
        }

      }

    });

  }

  _clearMsgNum(String doc_id) async{
    var message_res = await db.collection("message").doc(doc_id).withConverter(
      fromFirestore: Msg.fromFirestore,
      toFirestore: (Msg msg, options) => msg.toFirestore(),
    ).get();
    if(message_res.data()!=null){
      var item = message_res.data()!;
      int to_msg_num = item.to_msg_num==null?0:item.to_msg_num!;
      int from_msg_num = item.from_msg_num==null?0:item.from_msg_num!;
      if (item.from_token == userProfile.token) {
        to_msg_num = 0;
      } else {
        from_msg_num = 0;
      }
      await db.collection("message").doc(doc_id).update({"to_msg_num":to_msg_num,"from_msg_num":from_msg_num});
    }
  }

  _asyncLoadMoreData(int page) async{
    var mRef = ref;
    var state = mRef.read(chatProvider);
    final messages = await db.collection("message").doc(doc_id).collection("msglist").withConverter(
      fromFirestore: Msgcontent.fromFirestore,
      toFirestore: (Msgcontent msgcontent, options) => msgcontent.toFirestore(),
    ).orderBy("addtime", descending: true).where("addtime", isLessThan: state.msgcontentList.last.addtime)
        .limit(10).get();
    print("isGreaterThan-----");
    if(messages.docs.isNotEmpty){
      messages.docs.forEach((element) {
        var data = element.data();
        mRef.read(chatProvider.notifier).onMsgContentAdd(MsgContentAdd(data));
        print(data.content);
      });

      SchedulerBinding.instance.addPostFrameCallback((_) {
        isloadmore = true;
      });
    }
    mRef.read(chatProvider.notifier).onIsloadingChanged(isloadingChanged(false));
  }


  Future imgFromGallery() async {
      if(Platform.isIOS) {
        bool photosStatus = await request_permission(Permission.photos);
        if(!photosStatus){
          return;
        }
      }
        final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          _photo = File(pickedFile.path);
          uploadFile();
        } else {
          print('No image selected.');
        }
  }

  Future imgFromCamera() async {
    bool cameraStatus = await request_permission(Permission.camera);
    if(cameraStatus) {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    }
  }

  Future uploadFile() async {
    // if (_photo == null) return;
    // print(_photo);
    var result = await ChatAPI.upload_img(file:_photo);
    print(result.data);
    if(result.code==0){
      sendImageMessage(result.data!);
    }else{
      toastInfo(msg: "image error");
    }
  }


  sendMessage() async{

    print("---------------chat-----------------");
    String sendcontent = myinputController.text;
    print(sendcontent);
    myinputController.clear();
    if(sendcontent.isEmpty){
      toastInfo(msg: "content not empty");
      return;
    }
    print("---------------chat--${sendcontent}-----------------");
    final content = Msgcontent(
      token: userProfile.token,
      content: sendcontent,
      type: "text",
      addtime: Timestamp.now(),
    );

    await db.collection("message").doc(doc_id).collection("msglist").withConverter(
      fromFirestore: Msgcontent.fromFirestore,
      toFirestore: (Msgcontent msgcontent, options) => msgcontent.toFirestore(),
    ).add(content).then((DocumentReference doc) {
      print('DocumentSnapshot added with ID: ${doc.id}');


    });
    var message_res = await db.collection("message").doc(doc_id).withConverter(
      fromFirestore: Msg.fromFirestore,
      toFirestore: (Msg msg, options) => msg.toFirestore(),
    ).get();
    if(message_res.data()!=null){
      var item = message_res.data()!;
      int to_msg_num = item.to_msg_num==null?0:item.to_msg_num!;
      int from_msg_num = item.from_msg_num==null?0:item.from_msg_num!;
      if (item.from_token == userProfile.token) {
        from_msg_num = from_msg_num + 1;
      } else {
        to_msg_num = to_msg_num + 1;
      }
      await db.collection("message").doc(doc_id).update({"to_msg_num":to_msg_num,"from_msg_num":from_msg_num,"last_msg":sendcontent,"last_time":Timestamp.now()});
    }
    _sendNotifications("text");
  }
  sendImageMessage(String url) async{
    ref.read(chatProvider.notifier).onMoreStatusChanged(moreStatusChanged(false));
    print("---------------chat-----------------");
    final content = Msgcontent(
      token: userProfile.token,
      content: url,
      type: "image",
      addtime: Timestamp.now(),
    );

    await db.collection("message").doc(doc_id).collection("msglist").withConverter(
      fromFirestore: Msgcontent.fromFirestore,
      toFirestore: (Msgcontent msgcontent, options) => msgcontent.toFirestore(),
    ).add(content).then((DocumentReference doc) {
      print('DocumentSnapshot added with ID: ${doc.id}');
    });
    var message_res = await db.collection("message").doc(doc_id).withConverter(
      fromFirestore: Msg.fromFirestore,
      toFirestore: (Msg msg, options) => msg.toFirestore(),
    ).get();
    if(message_res.data()!=null){
      var item = message_res.data()!;
      int to_msg_num = item.to_msg_num==null?0:item.to_msg_num!;
      int from_msg_num = item.from_msg_num==null?0:item.from_msg_num!;
      if (item.from_token == userProfile.token) {
        from_msg_num = from_msg_num + 1;
      } else {
        to_msg_num = to_msg_num + 1;
      }
      await db.collection("message").doc(doc_id).update({"to_msg_num":to_msg_num,"from_msg_num":from_msg_num,"last_msg":"【image】","last_time":Timestamp.now()});
    }

    _sendNotifications("text");
  }

  _sendNotifications(String call_type) async {
    var state = ref.read(chatProvider);
    CallRequestEntity callRequestEntity = new CallRequestEntity();
    // text,voice,video,cancel
    callRequestEntity.call_type = call_type;
    callRequestEntity.to_token = state.to_token;
    callRequestEntity.to_avatar = state.to_avatar;
    callRequestEntity.doc_id = doc_id;
    callRequestEntity.to_name = state.to_name;
    var res = await ChatAPI.call_notifications(params: callRequestEntity);
    print(res);
    if (res.code == 0) {
      print("sendNotifications success");
    }
  }

  close_all_pop() async{
    FocusManager.instance.primaryFocus?.unfocus();
    ref.read(chatProvider.notifier).onMoreStatusChanged(moreStatusChanged(false));
    print("------close_all_pop");
  }

  goMore(){
    var more_status = ref.read(chatProvider).more_status;
    ref.read(chatProvider.notifier).onMoreStatusChanged(moreStatusChanged(more_status?false:true));
  }

  photoImg(Msgcontent item){
    Navigator.of(ref.context).pushNamed(AppRoutes.Photoview,arguments: {"url": item.content});
  }

  goVoiceCall() async{
    if(listener!=null){
      listener?.cancel();
    }
    bool microphoneStatus = await request_permission(Permission.microphone);
    if(microphoneStatus){
    ChatState state = ref.read(chatProvider);
    Navigator.of(ref.context).pushNamed(AppRoutes.VoiceCall, arguments: {
      "to_token": state.to_token,
      "to_name": state.to_name,
      "to_avatar": state.to_avatar,
      "doc_id": doc_id,
      "call_role": "anchor"
    }).then((completion){
      _chatSnapshots();
    });
    }
  }
  goVideoCall() async{
    if(listener!=null){
      listener?.cancel();
    }
    bool microphoneStatus = await request_permission(Permission.microphone);
    bool cameraStatus = await request_permission(Permission.camera);
    if(microphoneStatus && cameraStatus){
    ChatState state = ref.read(chatProvider);
    Navigator.of(ref.context).pushNamed(AppRoutes.VideoCall, arguments: {
      "to_token": state.to_token,
      "to_name": state.to_name,
      "to_avatar": state.to_avatar,
      "doc_id": doc_id,
      "call_role": "anchor"
    }).then((completion){
      _chatSnapshots();
    });
    }
  }



}
