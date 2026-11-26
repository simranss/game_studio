import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import 'net_probe.dart';

/// Knows whether the device is online, and tells listeners when it changes.
class ConnectivityService extends ChangeNotifier {
  bool _online = true;
  bool get isOnline => _online;
  StreamSubscription<List<ConnectivityResult>>? _sub;

  Future<void> init() async {
    _sub = Connectivity().onConnectivityChanged.listen((_) => refresh());
    await refresh();
  }

  /// Fast path: no network interface at all → offline. Otherwise confirm
  /// with a real lookup, because "connected to Wi-Fi" can still be offline.
  Future<bool> refresh() async {
    var online = false;
    try {
      final types = await Connectivity().checkConnectivity();
      online =
          !types.every((t) => t == ConnectivityResult.none) &&
          await canReachInternet();
    } catch (_) {
      online = await canReachInternet(); // plugin missing on this platform
    }
    if (online != _online) {
      _online = online;
      notifyListeners();
    }
    return online;
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}