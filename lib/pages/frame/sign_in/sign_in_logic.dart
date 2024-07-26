import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ulearning/common/apis/apis.dart';
import 'package:ulearning/common/entities/entities.dart';
import 'package:ulearning/common/routes/routes.dart';
import 'package:ulearning/common/utils/utils.dart';
import 'package:ulearning/common/values/constant.dart';
import 'package:ulearning/common/widgets/widgets.dart';
import 'package:ulearning/global.dart';
import 'package:ulearning/pages/frame/sign_in/notifiers/sign_in_notifier.dart';


class SignInLogic{
  final WidgetRef ref;

   SignInLogic({
    required this.ref,
  });

  init(){}
   
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'openid',
    ],
  );

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  Future<UserCredential> signInWithApple() async {
    final appleProvider = AppleAuthProvider();
    return await FirebaseAuth.instance.signInWithProvider(appleProvider);
  }

  handleSignIn(String type) async {
    // type 1:email，2:google,3:facebook,4 apple,5 phone
    try {
      if(type=="email"){
        final state = ref.read(SignInProvider);
        String emailAddress = state.email;
        String password = state.password;

        if(emailAddress.isEmpty){
          toastInfo(msg: "Email not empty!");
          return;
        }
        if(password.isEmpty){
          toastInfo(msg: "Password not empty!");
          return;
        }
        FocusManager.instance.primaryFocus?.unfocus();
        try {
          final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: emailAddress,
              password: password
          );

          if(credential.user==null) {
            toastInfo(msg: "user not login.");
            return;
          }
          if(!credential.user!.emailVerified){
            toastInfo(msg: "please log in to verify your email address");
            return;
          }
          var user = credential.user;
          if(user!=null){

            String? displayName = user.displayName;
            String? email = user.email;
            String? id = user.uid;
            String? photoUrl = user.photoURL;

            LoginRequestEntity loginPageListRequestEntity = new LoginRequestEntity();
            loginPageListRequestEntity.avatar = photoUrl;
            loginPageListRequestEntity.name = displayName;
            loginPageListRequestEntity.email = email;
            loginPageListRequestEntity.open_id = id;
            loginPageListRequestEntity.type = 1;
            asyncPostAllData(loginPageListRequestEntity);

          }else{
            toastInfo(msg: 'login error');
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            print('No user found for that email.');
            toastInfo(msg: "No user found for that email.");
          } else if (e.code == 'wrong-password') {
            print('Wrong password provided for that user.');
            toastInfo(msg: "Wrong password provided for that user.");
          }
        }

      }else if(type=="google"){
        var user = await _googleSignIn.signIn();
        print("user------");
        print(user);
        if(user!=null){
          String? displayName = user.displayName;
          String email = user.email;
          String id = user.id;
          String photoUrl = user.photoUrl??"${SERVER_API_URL}uploads/default.png";

          LoginRequestEntity loginPageListRequestEntity = new LoginRequestEntity();
          loginPageListRequestEntity.avatar = photoUrl;
          loginPageListRequestEntity.name = displayName;
          loginPageListRequestEntity.email = email;
          loginPageListRequestEntity.open_id = id;
          loginPageListRequestEntity.type = 2;
          asyncPostAllData(loginPageListRequestEntity);

        }else{
          toastInfo(msg: 'email login error');
        }
      }else if(type=="facebook"){
        Logger.write("facebook");
        var user = await signInWithFacebook();
        Logger.write("${user.user}");
        if(user.user!=null){
          String? displayName = user.user?.displayName;
          String? email = user.user?.email;
          String? id = user.user?.uid;
          String? photoUrl = user.user?.photoURL;

          LoginRequestEntity loginPageListRequestEntity = new LoginRequestEntity();
          loginPageListRequestEntity.avatar = photoUrl;
          loginPageListRequestEntity.name = displayName;
          loginPageListRequestEntity.email = email;
          loginPageListRequestEntity.open_id = id;
          loginPageListRequestEntity.type = 3;
          asyncPostAllData(loginPageListRequestEntity);
        }else{
          toastInfo(msg: 'facebook login error');
        }

      }else if(type=="apple"){
        Logger.write("apple");
        var user = await signInWithApple();
        Logger.write("${user.user}");
        if(user.user!=null){

          String displayName = "apple_user";
          String email = "apple@email.com";
          String id = user.user!.uid;
          String photoUrl = "${SERVER_API_URL}uploads/default.png";
          print(photoUrl);
          print("apple uid----");
          print(id);
          LoginRequestEntity loginPageListRequestEntity = new LoginRequestEntity();
          loginPageListRequestEntity.avatar = photoUrl;
          loginPageListRequestEntity.name = displayName;
          loginPageListRequestEntity.email = email;
          loginPageListRequestEntity.open_id = id;
          loginPageListRequestEntity.type = 4;
          asyncPostAllData(loginPageListRequestEntity);

        }else{
          toastInfo(msg: 'apple login error');
        }

      }

    } catch (error) {
      toastInfo(msg: 'login error');
      Logger.write("${error}");
    }
  }

  asyncPostAllData(LoginRequestEntity loginRequestEntity) async {
    EasyLoading.show(indicator: CircularProgressIndicator(),maskType: EasyLoadingMaskType.clear,dismissOnTap: true);
    var result = await UserAPI.Login(params: loginRequestEntity);
    print(result);
    if(result.code==0){
      try{
        Global.storageService.setString(STORAGE_USER_PROFILE_KEY, jsonEncode(result.data!));
        Global.storageService.setString(STORAGE_USER_TOKEN_KEY, result.data!.access_token!);
        EasyLoading.dismiss();
        Navigator.of(ref.context).pushNamedAndRemoveUntil(AppRoutes.Application, (Route<dynamic> route) => false);
      }catch(e){
        Logger.write("${e}");
      }

    }else{
      EasyLoading.dismiss();
      toastInfo(msg: 'internet error');
    }

  }

}