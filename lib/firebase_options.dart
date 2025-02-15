// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAOqbTdQ0gIIBV63k8LHhbLtKlOVqg_SY8',
    appId: '1:346326847595:android:01f22effa1c31bfda5a12e',
    messagingSenderId: '346326847595',
    projectId: 'ulearning-go',
    storageBucket: 'ulearning-go.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAa8wXi7Sl7o--dgwwx1jKpcb0T3MmpPk4',
    appId: '1:346326847595:ios:bb258917d5320c67a5a12e',
    messagingSenderId: '346326847595',
    projectId: 'ulearning-go',
    storageBucket: 'ulearning-go.appspot.com',
    androidClientId: '346326847595-mofqhout9o1l5vbv5ajiad31rhtougfb.apps.googleusercontent.com',
    iosClientId: '346326847595-mvi6q2iersgoqpmmo0gg8bqqbj0dtt7s.apps.googleusercontent.com',
    iosBundleId: 'com.dbestech.riverpod.ulearning',
  );
}
