// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
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
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCqLIARLLShPrBhqo1DpOCbtS_BTY30T1Q',
    appId: '1:538495696565:android:659beadd395f40ace608fc',
    messagingSenderId: '538495696565',
    projectId: 'spending-share',
    storageBucket: 'spending-share.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD4eHrZGiN2dB44FhS5weDM7m5HxSKw4jg',
    appId: '1:538495696565:ios:4df9b637e1b690dce608fc',
    messagingSenderId: '538495696565',
    projectId: 'spending-share',
    storageBucket: 'spending-share.appspot.com',
    iosClientId: '538495696565-hv23f0eeb12d8ps12c8s8rjeo35vmqc1.apps.googleusercontent.com',
    iosBundleId: 'hu.havasig.spending-share',
  );
}
