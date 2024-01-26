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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCt5R8jXFqvyYzRnfQYzUTPeaD44lpxk-4',
    appId: '1:1063590114517:web:6d154badda100aafbede5c',
    messagingSenderId: '1063590114517',
    projectId: 'ontime-d9a38',
    authDomain: 'ontime-d9a38.firebaseapp.com',
    storageBucket: 'ontime-d9a38.appspot.com',
    measurementId: 'G-LE954KL6G2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCiqOd_LV5tPD1MXIj9ZiWoxYvP_KLwn8g',
    appId: '1:1063590114517:android:246bf55635a5c2d0bede5c',
    messagingSenderId: '1063590114517',
    projectId: 'ontime-d9a38',
    storageBucket: 'ontime-d9a38.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCd7exjQkJ53BfZhzpGIxV3LbfU9xdv4pw',
    appId: '1:1063590114517:ios:398953e2a64048dcbede5c',
    messagingSenderId: '1063590114517',
    projectId: 'ontime-d9a38',
    storageBucket: 'ontime-d9a38.appspot.com',
    iosClientId: '1063590114517-vhppoe005ekv68c2njn74pgb2sebenmi.apps.googleusercontent.com',
    iosBundleId: 'com.ontimemobile3.newfcheckproject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCd7exjQkJ53BfZhzpGIxV3LbfU9xdv4pw',
    appId: '1:1063590114517:ios:398953e2a64048dcbede5c',
    messagingSenderId: '1063590114517',
    projectId: 'ontime-d9a38',
    storageBucket: 'ontime-d9a38.appspot.com',
    iosClientId: '1063590114517-vhppoe005ekv68c2njn74pgb2sebenmi.apps.googleusercontent.com',
    iosBundleId: 'com.ontimemobile3.newfcheckproject',
  );
}