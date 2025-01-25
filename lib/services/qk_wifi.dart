import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:wifi_scan/wifi_scan.dart';

class QkWifi {
  Future<bool> isSupported() async =>
      await WiFiScan.instance.canGetScannedResults(askPermissions: true) ==
      CanGetScannedResults.yes;

  // Checks if wifi is enabled
  Future<bool> isEnabled() async {
    // Wi-fi is available.
    // Note for Android:
    // When both mobile and Wi-Fi are turned on system will return Wi-Fi only as active network type
    StreamSubscription<List<ConnectivityResult>>? subscription;
    Completer<bool> completer = Completer<bool>();

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (!completer.isCompleted) {
        if (result.contains(ConnectivityResult.wifi)) {
          completer.complete(true);
        } else {
          completer.complete(false);
        }
      }
      subscription?.cancel();
    });

    return completer.future;
  }

  // Start scan of wifi devices return list of devices found or empty list
  Future<List<WiFiAccessPoint>> startScan() async {
    StreamSubscription<List<WiFiAccessPoint>>? subscription;
    Completer<List<WiFiAccessPoint>> completer =
        Completer<List<WiFiAccessPoint>>();

    subscription =
        WiFiScan.instance.onScannedResultsAvailable.listen((results) {
      if (!completer.isCompleted) {
        completer.complete(results);
      }
      subscription?.cancel();
    });

    return completer.future;
  }
}
