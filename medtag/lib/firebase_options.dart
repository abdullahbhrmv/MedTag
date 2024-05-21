// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyARuhBLU2ZwgSRO6zAarFehbIQm0GdTkbQ',
    appId: '1:1073632792650:web:0b36cd4adeaad58ea416b3',
    messagingSenderId: '1073632792650',
    projectId: 'medtag-a3362',
    authDomain: 'medtag-a3362.firebaseapp.com',
    storageBucket: 'medtag-a3362.appspot.com',
    measurementId: 'G-WS6RXWBGXY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDuau35QvhIuQHwkgnQLT9wNr8zHd2uSiE',
    appId: '1:1073632792650:android:1646017563042bc1a416b3',
    messagingSenderId: '1073632792650',
    projectId: 'medtag-a3362',
    storageBucket: 'medtag-a3362.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBab4kWDhLk2BXb2hWJH5kPYOI6g8QIGLQ',
    appId: '1:1073632792650:ios:083dd0d9b10d8988a416b3',
    messagingSenderId: '1073632792650',
    projectId: 'medtag-a3362',
    storageBucket: 'medtag-a3362.appspot.com',
    iosBundleId: 'com.example.medtag',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBab4kWDhLk2BXb2hWJH5kPYOI6g8QIGLQ',
    appId: '1:1073632792650:ios:083dd0d9b10d8988a416b3',
    messagingSenderId: '1073632792650',
    projectId: 'medtag-a3362',
    storageBucket: 'medtag-a3362.appspot.com',
    iosBundleId: 'com.example.medtag',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyARuhBLU2ZwgSRO6zAarFehbIQm0GdTkbQ',
    appId: '1:1073632792650:web:d75b50bbbc348f15a416b3',
    messagingSenderId: '1073632792650',
    projectId: 'medtag-a3362',
    authDomain: 'medtag-a3362.firebaseapp.com',
    storageBucket: 'medtag-a3362.appspot.com',
    measurementId: 'G-YGZWD4JHRV',
  );
}