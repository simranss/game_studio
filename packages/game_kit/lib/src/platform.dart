import 'package:flutter/foundation.dart';

/// One place that answers "can this build do X?". Ads, billing and Play
/// Games exist only on Android (and iOS), not on Linux or inside VS Code.
class Capabilities {
  static bool get isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  static bool get isIOS =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
  static bool get isMobile => isAndroid || isIOS;

  static bool get ads => isMobile;
  static bool get inAppPurchases => isMobile;
  static bool get playGames => isAndroid;

  /// Set at build time: flutter build web --dart-define=TARGET=vscode
  static const target = String.fromEnvironment('TARGET', defaultValue: 'app');
  static bool get isVsCode => target == 'vscode';
}
