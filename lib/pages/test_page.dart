// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quokka_mobile_app/app_localizations.dart';
import 'package:quokka_mobile_app/components/page_layout.dart';
import 'package:quokka_mobile_app/controllers/app_provider.dart';
import 'package:quokka_mobile_app/services/qk_ble.dart';

import 'step1_landing_page/step1_landing_page.dart';

const NUMBER_BUTTONS_HEIGHT = 5;
const STATUS_BAR_HEIGHT = 64;
const SCAN_WINDOW_HEIGHT = 150;
const OUTPUT_HEIGHT = 150;
const INPUT_HEIGHT = 64;
const BOTTOM_HEIGHT = 48 * NUMBER_BUTTONS_HEIGHT;

class TestPage extends StatefulWidget {
  static const String route = '/test_page';
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  bool isBusy = false;
  List<QkBLEDevice> btDevices = [];
  QkBLEDevice? selectedDevice;
  String output = '';
  final bt = QkBLE();
  late AppLocalizations lang;

  TextEditingController inputSSID = TextEditingController();
  TextEditingController inputPass = TextEditingController();

  void printOut(String text) => setState(() => output = text);

  void handleBluetoothError(BuildContext context, String errorMessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Alert"),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        });
  }

  void setBusy(bool isBusyStatus) {
    setState(() => isBusy = isBusyStatus);
  }

  void setDevices(List<QkBLEDevice> foundDevices) {
    setState(() => btDevices = foundDevices);
  }

  void startScan(BuildContext context) async {
    await bt.startScan(
        context, lang, true, handleBluetoothError, setBusy, setDevices);
  }

  void stopScan(BuildContext context) async {
    await bt.stopScan();
    setBusy(false);
  }

  void pairDevice(BuildContext context, QkBLEDevice bleDevice) async {
    if (mounted) stopScan(context);
    printOut('Pairing, please wait');

    // ignore: unused_local_variable
    final pairResult = await bt.pair(bleDevice);

    if (pairResult) {
      setState(() => output = 'Selected device: ${bleDevice.name}');
    }

    String out = 'This device has following services:\n';
    for (var service in bleDevice.device.servicesList) {
      out += ('${service.serviceUuid} - ${service.isPrimary}\n');
    }

    printOut(out);

    selectedDevice = bleDevice;
  }

  void setDeviceLED(String newState) async {
    if (selectedDevice == null) {
      printOut('No device selected to set LED');
      return;
    }

    await bt.writeCharacteristic(
        selectedDevice!, QUOKKA_SVC_UUID, QUOKKA_LED_ON_UUID, newState);
    printOut('LED set to $newState');
  }

  void readConfigs(BuildContext context) async {
    if (selectedDevice == null) {
      printOut('No device selected for read');
      return;
    }

    final ledConfig = await bt.readCharacteristic(
            selectedDevice!, QUOKKA_SVC_UUID, QUOKKA_LED_ON_UUID) ??
        '';
    final wifiConfig = await bt.readCharacteristic(
            selectedDevice!, QUOKKA_SVC_UUID, QUOKKA_WIFI_CONFIG_UUID) ??
        '';
    final networkConfig = await bt.readCharacteristic(
            selectedDevice!, QUOKKA_SVC_UUID, QUOKKA_IP_ADDR_CONFIG_UUID) ??
        '';
    final test = await bt.readCharacteristic(selectedDevice!, QUOKKA_SVC_UUID,
            '12345678-1234-5678-1234-56789abcdef4') ??
        '';

    final status =
        'LED status: $ledConfig\nWifiConfig: $wifiConfig\nnetConfig: $networkConfig\ntest: $test';
    printOut(status);
  }

  void writeWiFiConfig() async {
    if (selectedDevice == null) {
      printOut('No device selected for write');
      return;
    }

    Map<String, String> wifiData = {
      "ssid": inputSSID.text,
      "password": inputPass.text
    };

    await bt.writeCharacteristic(selectedDevice!, QUOKKA_SVC_UUID,
        QUOKKA_WIFI_CONFIG_UUID, jsonEncode(wifiData));

    printOut(
        'Written new Wifi config to ${selectedDevice?.name}\n${jsonEncode(wifiData)}');
  }

  Widget renderInputForm(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: INPUT_HEIGHT.toDouble(),
      width: double.infinity,
      child: Row(children: [
        SizedBox(
          width: screenWidth / 2 - 5,
          child: TextField(
            controller: inputSSID,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'SSID',
            ),
          ),
        ),
        SizedBox(
          width: screenWidth / 2 - 5,
          child: TextField(
            controller: inputPass,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Password',
            ),
          ),
        ),
      ]),
    );
  }

  Widget renderBottomSection(
      BuildContext context, AppProvider appProvider, bool isDebugMode) {
    return Container(
        height: BOTTOM_HEIGHT.toDouble(),
        width: double.infinity,
        margin: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Text('LED'),
                ElevatedButton(
                  onPressed: () => setDeviceLED('ON'),
                  child: const Text('ON'),
                ),
                ElevatedButton(
                  onPressed: () => setDeviceLED('OFF'),
                  child: const Text('OFF'),
                ),
              ],
            ),
            Row(children: [
              ElevatedButton(
                onPressed: () => setDeviceLED('BLE_CONN'),
                child: const Text('BLE_CONN'),
              ),
              ElevatedButton(
                onPressed: () => setDeviceLED('WIFI_CONN'),
                child: const Text('WIFI_CONN'),
              ),
            ]),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => readConfigs(context),
                  child: const Text('Read Config'),
                ),
                ElevatedButton(
                  onPressed: () => writeWiFiConfig(),
                  child: const Text('Write Wifi Config'),
                ),
              ],
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => appProvider.setDebugMode(!isDebugMode),
                  child: const Text('Toggle Debug Mode'),
                ),
                const SizedBox(width: 15),
                Text(isDebugMode ? 'Debug mode is: ON' : 'Debug mode is: OFF'),
              ],
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => startScan(context),
                  child: const Text('Start scan'),
                ),
                ElevatedButton(
                  onPressed: () => stopScan(context),
                  child: const Text('Stop scan'),
                ),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, Step1LandingPage.route),
                  child: const Text('Close page'),
                ),
              ],
            )
          ],
        ));
  }

  Widget renderBody() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    AppProvider appProvider = Provider.of<AppProvider>(context, listen: true);
    bool isDebugMode = appProvider.isDebugMode();

    // print('>> screenHeight: $screenHeight');

    return Container(
      height: screenHeight,
      width: screenWidth,
      color: Colors.white,
      child: Column(
        children: [
          Container(height: STATUS_BAR_HEIGHT.toDouble(), color: Colors.blue),
          isBusy
              ? const CircularProgressIndicator()
              : const Text('DEBUG SCREEN'),
          // Scan result box
          Container(
              height: screenHeight -
                  (STATUS_BAR_HEIGHT +
                      SCAN_WINDOW_HEIGHT +
                      OUTPUT_HEIGHT +
                      INPUT_HEIGHT +
                      BOTTOM_HEIGHT),
              width: screenWidth,
              color: Colors.lightBlueAccent,
              child: SizedBox(
                height: SCAN_WINDOW_HEIGHT.toDouble(),
                child: ListView.builder(
                    itemCount: btDevices.length,
                    itemBuilder: (BuildContext context, int index) {
                      final thisDevice = btDevices[index];
                      final deviceText =
                          '${thisDevice.remoteId} - ${thisDevice.name}';
                      return ListTile(
                        title: Text(deviceText),
                        onTap: () => pairDevice(context, thisDevice),
                      );
                    }),
              )),
          // action output box
          Container(
            height: OUTPUT_HEIGHT.toDouble(),
            width: screenWidth,
            color: Colors.lightGreenAccent,
            child: Text(output),
          ),
          renderInputForm(context),
          // action buttons
          renderBottomSection(context, appProvider, isDebugMode)
        ],
      ),
    );
  }

  @override
  void dispose() {
    inputSSID.dispose();
    inputPass.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    lang = AppLocalizations.of(context)!;
    return PageLayout(body: renderBody());
  }
}
