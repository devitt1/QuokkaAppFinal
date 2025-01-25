import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quokka_mobile_app/app_localizations.dart';
import 'package:quokka_mobile_app/components/qk_button.dart';
import 'package:quokka_mobile_app/components/qk_error_message.dart';
import 'package:quokka_mobile_app/components/qk_item.dart';
import 'package:quokka_mobile_app/components/spacer.dart';
import 'package:quokka_mobile_app/models/qk_device_model.dart';
import 'package:quokka_mobile_app/services/qk_ble.dart';
import 'package:quokka_mobile_app/controllers/app_provider.dart';
import 'package:quokka_mobile_app/theme/text_styles.dart';
import 'package:quokka_mobile_app/utils/debug.dart';
import 'package:quokka_mobile_app/utils/measures.dart';

class QkBluetoothScanner extends StatefulWidget {
  const QkBluetoothScanner({
    super.key,
  });

  @override
  State<QkBluetoothScanner> createState() => _QkBluetoothScannerState();
}

class _QkBluetoothScannerState extends State<QkBluetoothScanner> {
  late AppProvider appProvider;
  late AppLocalizations lang;
  late Measures measures;
  List<QkBLEDevice> btDevices = [];
  bool isScanning = false;
  bool isBtSupported = false;
  bool isBtEnabled = false;
  bool hasBtError = false;
  String btErrorMessage = '';
  final bt = QkBLE();

  void startBluetoothScan() async {
    if (!mounted) return;

    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    bool isDebugMode = appProvider.isDebugMode();

    final qkDevicelist = appProvider.qkDevices;
    if (qkDevicelist.isNotEmpty && qkDevicelist.first.btSettings != null) {
      final btDevice = qkDevicelist.first.btSettings!;
      btDevice.device.disconnect();
    }

    await bt.startScan(
        context, lang, isDebugMode, errorUIFunction, updateBusyUI, setDevices);
  }

  void restartScan() {
    setState(() {
      hasBtError = false;
      btErrorMessage = '';
      isScanning = false;
    });
    startBluetoothScan();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, startBluetoothScan);
  }

  @override
  void dispose() {
    bt.stopScan();

    super.dispose();
  }

  void errorUIFunction(BuildContext context, String errorMessage) {
    if (!mounted) return;
    setState(() {
      hasBtError = true;
      btErrorMessage = errorMessage;
    });
  }

  void updateBusyUI(bool isBusyStatus) {
    if (!mounted) return;
    setState(() {
      isScanning = isBusyStatus;
    });
  }

  void setDevices(List<QkBLEDevice> foundDevices) {
    if (!mounted) return;
    setState(() {
      btDevices = foundDevices;
    });
  }

  void pairDevice(QkBLEDevice bleDevice) async {
    // ignore: unused_local_variable
    final pairResult = await bt.pair(bleDevice);
  }

  Widget _renderErrorBody() {
    final errorTitle =
        btErrorMessage == 'NOT_FOUND' ? lang.t('no_quokka_found') : "Error";
    final errorMessage = btErrorMessage == 'NOT_FOUND'
        ? lang.t('make_sure_your_quokka_connected_to_power_bluetooth_on')
        : btErrorMessage;

    return SizedBox(
      height: measures.height(70),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 100, height: 0),
          Expanded(
            child: QkErrorMessage(
              title: errorTitle,
              message: errorMessage,
            ),
          ),
          QkButton(
            title: lang.t('try_again'),
            disabled: isScanning,
            onPressed: restartScan,
          )
        ],
      ),
    );
  }

  Widget _renderBody() {
    if (hasBtError) return _renderErrorBody();

    final devices = appProvider.qkDevices;

    return SizedBox(
      height: measures.height(70),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              isScanning
                  ? const CircularProgressIndicator()
                  : const SizedBox(height: 0), // TODO: Implement figma spinner
              Separator(size: Size(0, Measures.separator8)),
              Text(
                lang.t("searching_for_quokkas"),
                style: TextStyles.roobertTextSm14,
              ),
              Separator(size: Size(0, Measures.separator16)),
            ],
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: btDevices.length,
              itemBuilder: (_, index) {
                final device = btDevices[index];
                final quokkaDevice = QkDeviceModel(
                  deviceId: device.remoteId,
                  deviceName: device.name,
                  btSettings: device,
                );

                bool isSelected = devices.any(
                    (element) => element.deviceId == quokkaDevice.deviceId);
                return SizedBox(
                  width: measures.width(100),
                  child: QkItem(
                    title: quokkaDevice.deviceName,
                    description: quokkaDevice.deviceId,
                    selected: isSelected,
                    onPressed: () {
                      printDebug('${device.device}');
                      appProvider.onBoardDevice(quokkaDevice);
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 16),
            ),
          ),
          QkButton(
            title: lang.t('next'),
            disabled: btDevices.isEmpty,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    lang = AppLocalizations.of(context)!;
    measures = Measures(context);
    appProvider = Provider.of<AppProvider>(context, listen: true);

    return _renderBody();
  }
}
