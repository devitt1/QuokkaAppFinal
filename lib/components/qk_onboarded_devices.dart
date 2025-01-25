import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quokka_mobile_app/app_localizations.dart';
import 'package:quokka_mobile_app/components/qk_ready_to_pair_device.dart';
import 'package:quokka_mobile_app/services/qk_ble.dart';
import 'package:quokka_mobile_app/controllers/app_provider.dart';
import 'package:quokka_mobile_app/utils/ui_utils.dart';

import '../models/qk_device_model.dart';

class QkOnboardedDevices extends StatefulWidget {
  const QkOnboardedDevices({super.key});

  @override
  State<QkOnboardedDevices> createState() => _QkOnboardedDevicesState();
}

class _QkOnboardedDevicesState extends State<QkOnboardedDevices> {
  late AppProvider appProvider;
  late AppLocalizations lang;
  final bt = QkBLE();

  void onPairDevice(QkDeviceModel qkDevice) async {
    if (!mounted) return;

    if (await bt.isEnabled()) {
      // ignore: use_build_context_synchronously
      appProvider.onPairDevice(qkDevice, context, bt);
    } else {
      showSnackbar(
        // ignore: use_build_context_synchronously
        context,
        title: lang.t("pairing_error_title"),
        type: QkSnakBarType.error,
      );
    }
  }

  void onUnpairDevice(QkDeviceModel qkDevice) async {
    // await bt.pair(qkDevice.btDevice);
  } //appProvider.onUnpairDevice(deviceId);

  QkReadyToPairDeviceState getDeviceState(String deviceId) {
    final device = appProvider.qkDevices.firstWhere(
      (element) => element.deviceId == deviceId,
    );

    if (device.isPaired) return QkReadyToPairDeviceState.paired;
    if (device.isPairing) return QkReadyToPairDeviceState.pairing;
    return QkReadyToPairDeviceState.ready;
  }

  Widget _renderBody() {
    final devices = appProvider.qkDevices;

    if (devices.isNotEmpty) {
      return SingleChildScrollView(
        child: ListView.builder(
          itemCount: appProvider.qkDevices.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final device = appProvider.qkDevices[index];
            return QkReadyToPairDevice(
              title: device.deviceName,
              action: getDeviceState(device.deviceId),
              onPair: () => onPairDevice(device),
              onUnpair: () => onUnpairDevice(device),
            );
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    lang = AppLocalizations.of(context)!;
    appProvider = Provider.of<AppProvider>(context, listen: true);

    return _renderBody();
  }
}
