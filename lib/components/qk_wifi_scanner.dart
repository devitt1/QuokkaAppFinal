import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quokka_mobile_app/app_localizations.dart';
import 'package:quokka_mobile_app/components/qk_error_message.dart';
import 'package:quokka_mobile_app/components/spacer.dart';
import 'package:quokka_mobile_app/components/qk_button.dart';
import 'package:quokka_mobile_app/components/qk_text_input.dart';
import 'package:quokka_mobile_app/services/qk_wifi.dart';
import 'package:quokka_mobile_app/controllers/app_provider.dart';
import 'package:quokka_mobile_app/theme/text_styles.dart';
import 'package:quokka_mobile_app/theme/theme_colors.dart';
import 'package:quokka_mobile_app/utils/debug.dart';
import 'package:quokka_mobile_app/utils/measures.dart';
import 'package:wifi_scan/wifi_scan.dart';

class QkWifiScanner extends StatefulWidget {
  const QkWifiScanner({
    super.key,
  });

  @override
  State<QkWifiScanner> createState() => _QkWifiScannerState();
}

class _QkWifiScannerState extends State<QkWifiScanner> {
  late AppProvider appProvider;
  late AppLocalizations lang;
  late Measures measures;
  final wifi = QkWifiScan();
  bool isScanning = false;
  List<WiFiAccessPoint> foundNetworks = [];
  bool _isWifiScanSupported = false;
  bool _isWifiEnabled = false;
  bool _isWifiValidated = false;
  final TextEditingController _ssidController = TextEditingController();

  bool checkSSID(String ssid, List<String> wifiList) {
    if (ssid.isEmpty) return false;
    if (wifiList.contains(ssid)) return false;

    wifiList.add(ssid);
    return true;
  }

  // Removes duplicate and empty ssid names
  List<WiFiAccessPoint> sanitizeNetworks(List<WiFiAccessPoint> rawList) {
    List<String> foundAlready = [];
    return rawList
        .where((wifiAP) => checkSSID(wifiAP.ssid, foundAlready))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    if (!mounted) return;

    _ssidController.addListener(() {
      if (mounted) setState(() {});
    });

    // TODO: Implement blueetooth scanner and fill devices lists with found devices
    Future.delayed(Duration.zero, () async {
      if (!mounted) return;

      bool isSupported = await wifi.isScanSupported();
      if (!isSupported) {
        debugPrint('WiFi Scan Not Supported - Prompt for SSID');
        setState(() {
          _isWifiScanSupported = false;
          _isWifiEnabled = false;
          _isWifiValidated = true; // show manual SSID entry instead of spinner
        });
        return;
      }

      final isEnabled = await wifi.isEnabled();
      // TODO: Show a modal to ask user to enable wifi
      setState(() {
        _isWifiEnabled = isEnabled;
        _isWifiScanSupported = true;
        _isWifiValidated = true;
      });

      setState(() => isScanning = true);

      printDebug('WiFi scanning started');
      final scannedNetworks = await wifi.startScan();
      setState(() {
        isScanning = false;
        foundNetworks = sanitizeNetworks(scannedNetworks);
      });
    });
  }

  void _onWifiPressed(WiFiAccessPoint network) {
    appProvider.onWifiNetworkSelected(network.ssid);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _ssidController.dispose();
    super.dispose();
  }

  Widget _renderBottomSheetBody() {
    if (!_isWifiValidated) {
      return SizedBox(
        height: measures.height(50),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_isWifiScanSupported) {
      return SizedBox(
        height: measures.height(50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              lang.t('wifi_scanning_not_supported_title'),
              style: TextStyles.roobertTextMd16Bold,
            ),
            Separator(size: Size(0, Measures.separator8)),
            Text(
              lang.t('wifi_scanning_not_supported_description'),
              style: TextStyles.roobertTextSm14,
            ),
            Separator(size: Size(0, Measures.separator16)),
            QkTextInput(
              title: lang.t('choose_wifi_network_page_wifi_network'),
              controller: _ssidController,
              placeholder: lang.t('wifi_ssid_placeholder'),
            ),
            const Spacer(),
            SafeArea(
              child: QkButton(
                title: lang.t('continue'),
                disabled: _ssidController.text.trim().isEmpty,
                onPressed: () {
                  final ssid = _ssidController.text.trim();
                  if (ssid.isEmpty) return;
                  appProvider.onWifiNetworkSelected(ssid);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      );
    }

    if (!_isWifiEnabled) {
      return SizedBox(
        height: measures.height(50),
        child: QkErrorMessage(
          title: lang.t('wifi_not_enabled'),
          message: lang.t('wifi_not_enabled_description'),
        ),
      );
    }

    if (isScanning) {
      return SizedBox(
        height: measures.height(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(), // TODO: Implement figma spinner
            Separator(size: Size(0, Measures.separator8)),
            Text(
              lang.t("wifi_scanning_title"),
              style: TextStyles.roobertTextSm14,
            )
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: foundNetworks.length,
      itemBuilder: (_, index) {
        final network = foundNetworks[index];
        return ListTile(
          leading: const Icon(Icons.wifi, color: ThemeColors.button),
          title: Text(network.ssid, style: TextStyles.roobertTextMd16),
          onTap: () => _onWifiPressed(network),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
    );
  }

  @override
  Widget build(BuildContext context) {
    lang = AppLocalizations.of(context)!;
    measures = Measures(context);
    appProvider = Provider.of<AppProvider>(context, listen: true);

    return _renderBottomSheetBody();
  }
}
