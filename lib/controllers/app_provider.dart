import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quokka_mobile_app/app_localizations.dart';
import 'package:quokka_mobile_app/components/wifi_connecting_modal.dart';
import 'package:quokka_mobile_app/constants.dart';
import 'package:quokka_mobile_app/models/qk_device_model.dart';
import 'package:quokka_mobile_app/models/qk_wifi_network_model.dart';
import 'package:quokka_mobile_app/services/storage.dart';
import 'package:quokka_mobile_app/utils/debug.dart';
import 'package:quokka_mobile_app/utils/ui_utils.dart';

import '../services/qk_ble.dart';

class AppProvider extends ChangeNotifier {
  Locale lang = const Locale('en');
  List<QkDeviceModel> qkDevices = [];
  List<QkWifiNetworkModel> wifiNetworks = [];
  QkWifiConnectStatus wifiConnectStatus = QkWifiConnectStatus.connecting;
  String selectedWifiNetwork = "";
  bool _isDebug = false;
  bool _isMockBluetooth = false;

  bool isDebugMode() => _isDebug;

  void setDebugMode(bool enabled) {
    _isDebug = enabled;
    notifyListeners();
  }

  bool isMockBluetoothEnabled() => _isMockBluetooth;

  void setMockBluetooth(bool enabled) {
    _isMockBluetooth = enabled;
    notifyListeners();
  }

  // Helper method: returns true if we should skip real device I/O operations
  // (pairing, WiFi config writes) and use mock/fake responses instead
  bool shouldSkipDeviceIO() => _isDebug || _isMockBluetooth;

  void onWifiNetworkSelected(String network) {
    selectedWifiNetwork = network;
    notifyListeners();
  }

  Future<void> saveDevice(
      String deviceId, String deviceName, String deviceIp) async {
    final knownQuokkas = await storageGet(KNOWN_QUOKKAS_KEY);
    String newQuokkasList = (knownQuokkas == null || knownQuokkas.length < 3)
        ? '$deviceId\t$deviceName\t$deviceIp'
        : '$knownQuokkas\n$deviceId\t$deviceName\t$deviceIp';

    await storageSet(KNOWN_QUOKKAS_KEY, newQuokkasList);
  }

  void tryWifiConnection(
      BuildContext context, String ssid, String password, QkBLE bt) async {
    wifiConnectStatus = QkWifiConnectStatus.connecting;
    notifyListeners();

    // TODO: Implement error handling
    Map<String, String> wifiData = {"ssid": ssid, "password": password};

    // TODO: remove debug
    printDebug('Writing to device: ${jsonEncode(wifiData)}');

    if (qkDevices.first.btSettings == null) {
      wifiConnectStatus = QkWifiConnectStatus.error;
      notifyListeners();
      return;
    }

    final btDevice = qkDevices.first.btSettings!;

    // fake wifi pairing if debug mode or mock Bluetooth enabled
    if (shouldSkipDeviceIO()) {
      await Future.delayed(const Duration(seconds: 5));
      saveDevice(
        btDevice.remoteId,
        btDevice.name,
        '127.0.0.1',
      );
      wifiConnectStatus = QkWifiConnectStatus.success;
      notifyListeners();
      return;
    }

    // Save WiFi configuration to device
    await bt.writeCharacteristic(btDevice, QUOKKA_SVC_UUID,
        QUOKKA_WIFI_CONFIG_UUID, jsonEncode(wifiData));

    // wait 5 seconds for device to connect to new WiFi
    await Future.delayed(const Duration(seconds: 5));

    final readWifiConfig = await bt.readCharacteristic(
          btDevice,
          QUOKKA_SVC_UUID,
          QUOKKA_WIFI_CONFIG_UUID,
        ) ??
        '';

    // TODO: remove debug
    printDebug('WiFi SSID: $readWifiConfig');
    if (readWifiConfig.isEmpty || readWifiConfig != ssid) {
      wifiConnectStatus = QkWifiConnectStatus.error;
      notifyListeners();
      return;
    }

    await Future.delayed(const Duration(seconds: 8));

    final readIPAddress = await bt.readCharacteristic(
          btDevice,
          QUOKKA_SVC_UUID,
          QUOKKA_IP_ADDR_CONFIG_UUID,
        ) ??
        '';

    Future.delayed(const Duration(seconds: 1), () {});

    // TODO: remove debug
    printDebug('Network IP: $readIPAddress');

    if (readIPAddress.isEmpty || readIPAddress == "Unknown") {
      wifiConnectStatus = QkWifiConnectStatus.error;
      notifyListeners();
      return;
    }

    // Add device to local storage list
    saveDevice(btDevice.remoteId, btDevice.name, readIPAddress);
    btDevice.device.disconnect();

    wifiConnectStatus = QkWifiConnectStatus.success;
    notifyListeners();
  }

  void clearDevices() {
    qkDevices.clear();
    notifyListeners();
  }

  void onBoardDevice(QkDeviceModel device) {
    // DC: For MVP, just a single device is supported.
    // Remove qkDevices to allow multiple devices
    // DC: Don't add device if it's already in the list, but remove it
    if (qkDevices.isNotEmpty ||
        qkDevices.any((element) => element.deviceId == device.deviceId)) {
      qkDevices.removeWhere((element) => element.deviceId == device.deviceId);
      notifyListeners();
      return;
    }

    qkDevices.add(QkDeviceModel(
      deviceId: device.deviceId,
      deviceName: device.deviceName,
      isPaired: false,
      isPairing: false,
      wifiSettings: QkWifiNetworkModel(),
      btSettings: device.btSettings,
    ));
    notifyListeners();
  }

  void onPairDevice(
      QkDeviceModel qkDevice, BuildContext context, QkBLE bt) async {
    final deviceId = qkDevice.deviceId;

    final lang = AppLocalizations.of(context)!;
    // Updating pairing state
    final foundDevice =
        qkDevices.firstWhere((element) => element.deviceId == deviceId);
    foundDevice.isPairing = true;
    notifyListeners();

    bool isPaired = false;

    // fake pairing if debug mode or mock Bluetooth enabled
    if (shouldSkipDeviceIO()) {
      await Future.delayed(const Duration(seconds: 3));
      isPaired = true;
    } else {
      isPaired = await bt.pair(qkDevice.btSettings!);
    }

    Future.delayed(const Duration(seconds: 1), () {
      foundDevice.isPaired = isPaired;
      foundDevice.isPairing = false;
      notifyListeners();

      showSnackbar(
        context,
        title:
            lang.t(isPaired ? "pairing_success_title" : "pairing_error_title"),
        type: isPaired ? QkSnakBarType.success : QkSnakBarType.error,
      );
    });
  }

  void onUnpairDevice(String deviceId) {
    // Todo: Implement bluetooth unpairing
    final device = qkDevices.firstWhere(
      (element) => element.deviceId == deviceId,
    );
    device.isPaired = false;
    device.isPairing = false;
    notifyListeners();
  }
}
