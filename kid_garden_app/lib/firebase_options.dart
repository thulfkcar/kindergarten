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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC08YR5mqPUokMFsGYaiqK8OVrWW4T5Gi0',
    appId: '1:517790856908:android:96ae59173dae5c7dedf469',
    messagingSenderId: '517790856908',
    projectId: 'kindergarten-2a1b9',
    storageBucket: 'kindergarten-2a1b9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB8pD0JPhc-BjSrHXJfTRqItlXGB5GC_dE',
    appId: '1:517790856908:ios:610134b095eb947fedf469',
    messagingSenderId: '517790856908',
    projectId: 'kindergarten-2a1b9',
    storageBucket: 'kindergarten-2a1b9.appspot.com',
    iosClientId: '517790856908-ds0f4mn79ej9amg97j1t69134am20eoe.apps.googleusercontent.com',
    iosBundleId: 'com.phoenix.kindergarten',
  );
}
