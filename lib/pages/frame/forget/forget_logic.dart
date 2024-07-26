import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulearning/common/widgets/toast.dart';
import 'package:ulearning/pages/frame/forget/notifiers/forget_notifier.dart';

class ForgetLogic {
  final WidgetRef ref;

  ForgetLogic({
    required this.ref,
  });

  handleEmailForgot() async{
    final state = ref.read(ForgetProvider);
    String emailAddress = state.email;
    if(emailAddress.isEmpty){
      toastInfo(msg: "Email not empty!");
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailAddress);
      toastInfo(msg: "An email has been sent to your registered email. To activate your account, please open the link from the email.");

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