import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;


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
    apiKey: 'AIzaSyBjKtNKsvcdj0jKbS0wD9LHcBdGck9pq6o',
    appId: '1:61433815770:web:3d3d25bbadd7e901b7bbe3',
    messagingSenderId: '61433815770',
    projectId: 'spendwise-f3c38',
    authDomain: 'spendwise-f3c38.firebaseapp.com',
    storageBucket: 'spendwise-f3c38.firebasestorage.app',
    measurementId: 'G-7TTWV14KEF',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCYr-qcgaP68t5EgdDMa_utzhx5B31QMh0',
    appId: '1:61433815770:ios:231e9761e9b97504b7bbe3',
    messagingSenderId: '61433815770',
    projectId: 'spendwise-f3c38',
    storageBucket: 'spendwise-f3c38.firebasestorage.app',
    iosBundleId: 'com.example.spendwise',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCYr-qcgaP68t5EgdDMa_utzhx5B31QMh0',
    appId: '1:61433815770:ios:231e9761e9b97504b7bbe3',
    messagingSenderId: '61433815770',
    projectId: 'spendwise-f3c38',
    storageBucket: 'spendwise-f3c38.firebasestorage.app',
    iosBundleId: 'com.example.spendwise',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBjKtNKsvcdj0jKbS0wD9LHcBdGck9pq6o',
    appId: '1:61433815770:web:448296465971af5ab7bbe3',
    messagingSenderId: '61433815770',
    projectId: 'spendwise-f3c38',
    authDomain: 'spendwise-f3c38.firebaseapp.com',
    storageBucket: 'spendwise-f3c38.firebasestorage.app',
    measurementId: 'G-JVVY6BY4DD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDPlpwhNR2AsUJuBWl4FcsKFyJkD-JWt4M',
    appId: '1:61433815770:android:b5c33c257602498eb7bbe3',
    messagingSenderId: '61433815770',
    projectId: 'spendwise-f3c38',
    storageBucket: 'spendwise-f3c38.firebasestorage.app',
  );

}