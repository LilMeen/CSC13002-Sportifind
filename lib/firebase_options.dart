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
    apiKey: 'AIzaSyCgcmn4LJZx3n26izMb6EofP_ys95GA02g',
    appId: '1:386495976488:web:893f7490818d9d9cf5111d',
    messagingSenderId: '386495976488',
    projectId: 'sportifind-d0b25',
    authDomain: 'sportifind-d0b25.firebaseapp.com',
    storageBucket: 'sportifind-d0b25.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB00ntd8LGgWW2juT_sgMdnRDvqlp93Jng',
    appId: '1:386495976488:android:8561019b195d0661f5111d',
    messagingSenderId: '386495976488',
    projectId: 'sportifind-d0b25',
    storageBucket: 'sportifind-d0b25.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCN-VSGJLSs0gV_sPgzbsepTSwF1GpA_Gg',
    appId: '1:386495976488:ios:af9dea04dce95837f5111d',
    messagingSenderId: '386495976488',
    projectId: 'sportifind-d0b25',
    storageBucket: 'sportifind-d0b25.appspot.com',
    iosBundleId: 'com.example.sportifind',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCN-VSGJLSs0gV_sPgzbsepTSwF1GpA_Gg',
    appId: '1:386495976488:ios:af9dea04dce95837f5111d',
    messagingSenderId: '386495976488',
    projectId: 'sportifind-d0b25',
    storageBucket: 'sportifind-d0b25.appspot.com',
    iosBundleId: 'com.example.sportifind',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCgcmn4LJZx3n26izMb6EofP_ys95GA02g',
    appId: '1:386495976488:web:6ffbfdd24425c5e3f5111d',
    messagingSenderId: '386495976488',
    projectId: 'sportifind-d0b25',
    authDomain: 'sportifind-d0b25.firebaseapp.com',
    storageBucket: 'sportifind-d0b25.appspot.com',
  );
}
