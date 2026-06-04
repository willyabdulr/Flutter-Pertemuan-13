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
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // ========== WEB (Sudah diisi dengan kunci asli dari Firebase Console) ==========
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD1XcBm7dZ1dUhe_PnbWswAvDVtqHBjuQI',
    appId: '1:811034739702:web:5138c1919a76967f713dd7',
    messagingSenderId: '811034739702',
    projectId: 'latihan1-efae9',
    authDomain: 'latihan1-efae9.firebaseapp.com',
    storageBucket: 'latihan1-efae9.firebasestorage.app',
  );

  // ========== ANDROID (SUDAH BENAR) ==========
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAdY6bNdHY9Yi_dyPQ2xKZ7pd2McCNL-A0',
    appId: '1:811034739702:android:a52abdd356a05a2e713dd7',
    messagingSenderId: '811034739702',
    projectId: 'latihan1-efae9',
    storageBucket: 'latihan1-efae9.firebasestorage.app',
  );

  // ========== iOS (Tambahkan nanti jika perlu) ==========
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'demo-api-key-ios',
    appId: 'demo-app-id-ios',
    messagingSenderId: 'demo-sender-id',
    projectId: 'latihan1-efae9',
    storageBucket: 'latihan1-efae9.firebasestorage.app',
  );

  // ========== macOS (Tambahkan nanti jika perlu) ==========
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'demo-api-key-macos',
    appId: 'demo-app-id-macos',
    messagingSenderId: 'demo-sender-id',
    projectId: 'latihan1-efae9',
    storageBucket: 'latihan1-efae9.firebasestorage.app',
  );

  // ========== WINDOWS (Tambahkan nanti jika perlu) ==========
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'demo-api-key-windows',
    appId: 'demo-app-id-windows',
    messagingSenderId: 'demo-sender-id',
    projectId: 'latihan1-efae9',
    storageBucket: 'latihan1-efae9.firebasestorage.app',
  );

  // ========== LINUX (Tambahkan nanti jika perlu) ==========
  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'demo-api-key-linux',
    appId: 'demo-app-id-linux',
    messagingSenderId: 'demo-sender-id',
    projectId: 'latihan1-efae9',
    storageBucket: 'latihan1-efae9.firebasestorage.app',
  );
}
