
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulearning/common/values/constant.dart';
import 'package:ulearning/common/widgets/widgets.dart';
import 'package:ulearning/pages/frame/register/notifiers/register_notifier.dart';

class RegisterLogic{
  final WidgetRef ref;
  RegisterLogic({
    required this.ref,
  });

  handleEmailRegister() async{
    final state = ref.read(RegisterProvider);
    String UserName = state.username;
    String emailAddress = state.email;
    String password = state.password;
    String repassword = state.repassword;

    if(UserName.isEmpty){
      toastInfo(msg: "UserName not empty!");
      return;
    }
    if(emailAddress.isEmpty){
      toastInfo(msg: "Email not empty!");
      return;
    }
    if(password.isEmpty){
      toastInfo(msg: "Password not empty!");
      return;
    }
    if(password!=repassword){
      toastInfo(msg: "The two passwords do not match!");
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      print(credential);
      if(credential!=null){
        await credential.user?.sendEmailVerification();
        await credential.user?.updateDisplayName(UserName);
        String photoURL = "${SERVER_API_URL}uploads/default.png";
        await credential.user?.updatePhotoURL(photoURL);
        toastInfo(msg: "An email has been sent to your registered email. To activate your account, please open the link from the email.");
        Navigator.of(ref.context).pop();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        toastInfo(msg: "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        toastInfo(msg: "The account already exists for that email.");
      }
    } catch (e) {
      print(e);
    }


  }


}