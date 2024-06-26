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
    apiKey: 'AIzaSyBj2pC3V6Bs6oaHCGKu8kuNxCbqYvjNdDs',
    appId: '1:502664237978:web:7101159363b2b7cb996023',
    messagingSenderId: '502664237978',
    projectId: 'fitness-d9ed0',
    authDomain: 'fitness-d9ed0.firebaseapp.com',
    storageBucket: 'fitness-d9ed0.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCUbiAWeOs5OkqwUiZTuG5T4nAw9IV7x3w',
    appId: '1:502664237978:android:8f10f5830261141b996023',
    messagingSenderId: '502664237978',
    projectId: 'fitness-d9ed0',
    storageBucket: 'fitness-d9ed0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBggaMIHuRqMpl9hyDJJICmZpNb9k0G8ho',
    appId: '1:502664237978:ios:35020441db31df5b996023',
    messagingSenderId: '502664237978',
    projectId: 'fitness-d9ed0',
    storageBucket: 'fitness-d9ed0.appspot.com',
    iosBundleId: 'com.example.fitnessApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBggaMIHuRqMpl9hyDJJICmZpNb9k0G8ho',
    appId: '1:502664237978:ios:35020441db31df5b996023',
    messagingSenderId: '502664237978',
    projectId: 'fitness-d9ed0',
    storageBucket: 'fitness-d9ed0.appspot.com',
    iosBundleId: 'com.example.fitnessApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBj2pC3V6Bs6oaHCGKu8kuNxCbqYvjNdDs',
    appId: '1:502664237978:web:7c715febd8593252996023',
    messagingSenderId: '502664237978',
    projectId: 'fitness-d9ed0',
    authDomain: 'fitness-d9ed0.firebaseapp.com',
    storageBucket: 'fitness-d9ed0.appspot.com',
  );
}
