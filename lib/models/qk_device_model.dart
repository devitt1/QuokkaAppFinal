import 'package:quokka_mobile_app/models/qk_wifi_network_model.dart';
import 'package:quokka_mobile_app/services/qk_ble.dart';

class QkDeviceModel {
  String deviceId = "";
  String deviceName = "";
  String deviceIp = "";
  String privateAddress = "";
  bool isPaired = false;
  bool isPairing = false;
  bool isOnlinePrivate = false;
  bool isOnlinePublic = false;
  QkWifiNetworkModel? wifiSettings = QkWifiNetworkModel();
  QkBLEDevice? btSettings;

  QkDeviceModel({
    required this.deviceId,
    required this.deviceName,
    this.isPaired = false,
    this.isPairing = false,
    this.deviceIp = "",
    this.privateAddress = "",
    this.isOnlinePrivate = false,
    this.isOnlinePublic = false,
    this.wifiSettings,
    this.btSettings,
  });
}
