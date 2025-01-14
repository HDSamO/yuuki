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
    apiKey: 'AIzaSyB35MiUXeiNGRSF3BRpui-GZxmSr6iak2I',
    appId: '1:228686973014:web:07e841a945b09d6bfd13f7',
    messagingSenderId: '228686973014',
    projectId: 'yuukidatabase-a715b',
    authDomain: 'yuukidatabase-a715b.firebaseapp.com',
    storageBucket: 'yuukidatabase-a715b.appspot.com',
    measurementId: 'G-R0FZKP1KXY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBdwbl-oJzn5dCzxoNsBkSK4M0hIMbRhQE',
    appId: '1:228686973014:android:316727fd83dfb7b8fd13f7',
    messagingSenderId: '228686973014',
    projectId: 'yuukidatabase-a715b',
    storageBucket: 'yuukidatabase-a715b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCuZCD7BdBQK5tMXB5YkMiyb2Z3Jwl7thM',
    appId: '1:228686973014:ios:bc8b7196e748a61efd13f7',
    messagingSenderId: '228686973014',
    projectId: 'yuukidatabase-a715b',
    storageBucket: 'yuukidatabase-a715b.appspot.com',
    iosBundleId: 'com.example.yuuki',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCuZCD7BdBQK5tMXB5YkMiyb2Z3Jwl7thM',
    appId: '1:228686973014:ios:185ea1429d5c0dbefd13f7',
    messagingSenderId: '228686973014',
    projectId: 'yuukidatabase-a715b',
    storageBucket: 'yuukidatabase-a715b.appspot.com',
    iosBundleId: 'com.example.yuuki.RunnerTests',
  );
}
