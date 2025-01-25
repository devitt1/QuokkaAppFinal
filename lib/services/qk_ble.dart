// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:quokka_mobile_app/app_localizations.dart';

import '../constants.dart';

/*
Needs following permissions in AndroidManifest.xml
<uses-permission android:name="android.permission.BLUETOOTH" android:maxSdkVersion="30" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" android:usesPermissionFlags="neverForLocation" />
<uses-feature android:name="android.hardware.bluetooth_le" android:required="true"/>
*/

// ignore: non_constant_identifier_names
String QUOKKA_SVC_UUID = '12345678-1234-5678-1234-56789abcdef0';
// ignore: non_constant_identifier_names
String QUOKKA_LED_ON_UUID = '12345678-1234-5678-1234-56789abcdef1';
// ignore: non_constant_identifier_names
String QUOKKA_WIFI_CONFIG_UUID = '12345678-1234-5678-1234-56789abcdef2';
// ignore: non_constant_identifier_names
String QUOKKA_IP_ADDR_CONFIG_UUID = '12345678-1234-5678-1234-56789abcdef3';

// A class to hold everything we need about the bluetooth device for this application
class QkBLEDevice {
  String name = '';
  String remoteId = '';
  BluetoothDevice device;

  QkBLEDevice({
    required this.remoteId,
    required this.name,
    required this.device,
  });
}

class QkBLE {
  // Checks if bluetooth is supported
  Future<bool> isSupported() async {
    return await FlutterBluePlus.isSupported;
  }

  // Checks if bluetooth is enabled
  Future<bool> isEnabled() async {
    Completer<bool> completer = Completer<bool>();
    StreamSubscription<BluetoothAdapterState>? subscription;

    subscription =
        FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      if (!completer.isCompleted) {
        switch (state) {
          case BluetoothAdapterState.off:
            // TODO: Remove this when needed
            print('adapterState: off');
            completer.complete(false);
            break;
          case BluetoothAdapterState.on:
            // TODO: Remove this when needed
            print('adapterState: on');
            completer.complete(true);
            break;
          case BluetoothAdapterState.unknown:
            // TODO: Remove this when needed
            print('adapterState: unknown');
            completer.complete(false);
            break;
          default:
            // TODO: Remove this when needed
            print('adapterState: default');
            completer.complete(false);
        }
        subscription
            ?.cancel(); // Cancel the subscription after receiving the first event
      }
    });
    return completer.future;
  }

  // Start scan of bluetooth devices return list of devices found or empty list
  // errorUIFunction - a function to handle errors during scan
  // updateBusyUI - a function to call when scanning is in progress (starts and stops a busy indicator)
  // updateDevices - a function to call to update the list of devices when they are found
  Future<List<QkBLEDevice>> startScan(
      BuildContext context,
      AppLocalizations lang,
      bool isDebugMode,
      void Function(BuildContext, String) errorUIFunction,
      void Function(bool) updateBusyUI,
      void Function(List<QkBLEDevice>) updateDevices) async {
    List<QkBLEDevice> scanResults = [];

    if (!(await isSupported())) {
      // ignore: use_build_context_synchronously
      errorUIFunction(context, lang.t('bluetooth_not_supported_on_device'));
      return [];
    }

    if (!(await isEnabled())) {
      errorUIFunction(
        // ignore: use_build_context_synchronously
        context,
        '${lang.t('bluetooth_not_enabled_on_device')} (1)',
      );
      return [];
    }

    // Wait for Bluetooth enabled & permission granted
    if (!(await FlutterBluePlus.adapterState.first ==
        BluetoothAdapterState.on)) {
      errorUIFunction(
        // ignore: use_build_context_synchronously
        context,
        '${lang.t('bluetooth_not_enabled_on_device')} (2)',
      );
      return [];
    }

    updateBusyUI(true);
    scanResults = [];
    updateDevices(scanResults);

    //print('scan started');
    var subscription = FlutterBluePlus.scanResults.listen(
      (results) {
        if (results.isNotEmpty) {
          ScanResult r = results.last; // the most recently found device

          final remoteId = '${r.device.remoteId}';
          QkBLEDevice foundDevice = QkBLEDevice(
            remoteId: remoteId,
            name: r.device.advName.isEmpty
                ? remoteId.replaceAll(":", "-")
                : r.device.advName,
            device: r.device,
          );

          print(
              '${foundDevice.remoteId} ${foundDevice.name} ${r.advertisementData.connectable}');

          // Only add if not a duplicate and is connectable
          final result = scanResults
              .indexWhere((item) => item.remoteId == foundDevice.remoteId);

          // TODO: for debug only add any device if list is empty or those that start with the designated prefix
          final addDevice = isDebugMode && r.advertisementData.connectable
              ? foundDevice.name.length > 1
              : foundDevice.name.startsWith(BLUETOOTH_PREFIX);

          // final addDevice = foundDevice.name.startsWith(BLUETOOTH_PREFIX);

          if (result == -1 && addDevice) {
            scanResults.add(foundDevice);
            updateDevices(scanResults);
          }
        }
      },
      onError: (e) => print(e),
    );

    FlutterBluePlus.cancelWhenScanComplete(subscription);

    await FlutterBluePlus.startScan(
      // withServices: [Guid(QUOKKA_SVC_UUID)],
      // withKeywords: [BLUETOOTH_PREFIX],
      // withNames: ["Exact name only!"],
      timeout: const Duration(seconds: BLUETOOTH_SEARCH_TIMEOUT),
    );

    // wait for scanning to stop
    await FlutterBluePlus.isScanning.where((val) => val == false).first;

    updateBusyUI(false);

    // ignore: use_build_context_synchronously
    if (scanResults.isEmpty) errorUIFunction(context, 'NOT_FOUND');

    return scanResults;
  }

  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
  }

  // Pair device - connecting is pairing for Quokka devices
  Future<bool> pair(QkBLEDevice bleDevice) async {
    final device = bleDevice.device;

    try {
      await device.connect(autoConnect: false, mtu: null);
    } catch (_) {
      return false;
    }

    // Optional check for service UUID
    List<BluetoothService> services = await device.discoverServices();
    for (BluetoothService service in services) {
      if ('${service.serviceUuid}' == QUOKKA_SVC_UUID) {
        print('Confirmed Quokka device Paired!');
        return true;
      }
    }

    return false;
  }

  Future<bool> disconnect(QkBLEDevice bleDevice) async {
    final device = bleDevice.device;
    try {
      await device.disconnect();
    } catch (_) {
      return false;
    }
    return true;
  }

  // unpair device
  Future<bool> unpair(QkBLEDevice bleDevice) async {
    return await disconnect(bleDevice);
  }

  Future<bool> connect(QkBLEDevice bleDevice) async {
    final device = bleDevice.device;
    try {
      await device.connect(autoConnect: false, mtu: null);
    } catch (_) {
      return false;
    }
    return true;
  }

  Future<List<BluetoothService>> getServices(QkBLEDevice bleDevice) async {
    final device = bleDevice.device;

    if (device.isDisconnected) await device.connect();

    print(
        'Device: ${device.advName}\nConnection State: ${device.connectionState}');
    // only try getting services if list is empty
    if (device.servicesList.isEmpty) {
      List<BluetoothService> services = await device.discoverServices();
      print('This device has ${services.length} services');
    }

    return device.servicesList;
  }

  // read data from device
  Future<String?> readCharacteristic(
      QkBLEDevice bleDevice, String serviceID, String characteristicID) async {
    String? result;

    List<BluetoothService> services = await getServices(bleDevice);

    for (BluetoothService service in services) {
      if ('${service.serviceUuid}' == serviceID) {
        // Got right service
        var characteristics = service.characteristics;
        for (BluetoothCharacteristic c in characteristics) {
          // Got right characteristic
          if ('${c.characteristicUuid}' == characteristicID) {
            if (c.properties.read) {
              try {
                List<int> charCodes = await c.read();
                result = String.fromCharCodes(charCodes);
                print(result);
              } catch (err) {
                print('>> Read error: $err');
              }
            }
          }
        }
      }
    }

    return result;
  }

  // write data to device
  Future<void> writeCharacteristic(QkBLEDevice bleDevice, String serviceID,
      String characteristicID, String newValue) async {
    List<BluetoothService> services = await getServices(bleDevice);

    for (BluetoothService service in services) {
      if ('${service.serviceUuid}' == serviceID) {
        // Got right service
        var characteristics = service.characteristics;
        for (BluetoothCharacteristic c in characteristics) {
          // Got right characteristic
          if ('${c.characteristicUuid}' == characteristicID) {
            if (c.properties.write) {
              try {
                List<int> writableValue = utf8.encode(newValue);
                await c.write(writableValue,
                    allowLongWrite: true, withoutResponse: false);
              } catch (err) {
                print('>> Write error: $err');
              }
            }
          }
        }
      }
    }
  }
}
