import 'dart:io';

/// Being on Wi-Fi doesn't mean being online (think hotel login pages).
/// A DNS lookup proves we can actually reach the internet.
Future<bool> canReachInternet() async {
  try {
    final result = await InternetAddress.lookup(
      'google.com',
    ).timeout(const Duration(seconds: 3));
    return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
  } catch (_) {
    return false;
  }
}