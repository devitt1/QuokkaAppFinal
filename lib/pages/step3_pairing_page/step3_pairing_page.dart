import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quokka_mobile_app/app_localizations.dart';
import 'package:quokka_mobile_app/components/page_layout.dart';
import 'package:quokka_mobile_app/components/qk_bottom_sheet.dart';
import 'package:quokka_mobile_app/components/qk_button.dart';
import 'package:quokka_mobile_app/components/qk_device_list.dart';
import 'package:quokka_mobile_app/components/qk_onboarded_devices.dart';
import 'package:quokka_mobile_app/components/qk_option_picker.dart';
import 'package:quokka_mobile_app/components/spacer.dart';
import 'package:quokka_mobile_app/pages/step4_wifi_setup_page/step4_wifi_setup_page.dart';
import 'package:quokka_mobile_app/controllers/app_provider.dart';
import 'package:quokka_mobile_app/theme/text_styles.dart';
import 'package:quokka_mobile_app/theme/theme_colors.dart';
import 'package:quokka_mobile_app/utils/measures.dart';

class Step3PairingPage extends StatefulWidget {
  static const String route = '/onboard_quokka_page';
  const Step3PairingPage({super.key});

  @override
  State<Step3PairingPage> createState() => _Step3PairingPageState();
}

class _Step3PairingPageState extends State<Step3PairingPage> {
  late AppProvider appProvider;
  late AppLocalizations lang;
  late Measures measures;

  void _onQuokkaOptionPressed() {
    openBottomSheet(
      context: context,
      isDismissible: true,
      scrollable: true,
      enableDrag: true,
      hasDragIndicator: true,
      maxHeight: 80,
      headerTitle: lang.t('choose_quokka'),
      sheetSize: 1,
      dragColor: ThemeColors.secondaryBackground,
      backgroundColor: ThemeColors.cards,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: const QkBluetoothScanner(),
    );
  }

  Widget _renderBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 49,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              lang.t('pairing'),
              style: TextStyles.satoshiTextMd40Bold,
            ),
          ),
          Separator(
            size: Size(0, Measures.separator16),
          ),
          Text(
            lang.t('choose_the_quokka_to_onboard_and_pair'),
            style: TextStyles.roobertTextMd16.copyWith(
              color: ThemeColors.subText,
            ),
          ),
          Separator(
            size: Size(0, Measures.separator32),
          ),
          QkOptionPicker(
            title: lang.t('choose_quokka'),
            hintText: lang.t('choose_the_quokka_to_onboard'),
            withBorder: true,
            onPickerPressed: _onQuokkaOptionPressed,
          ),
          const QkOnboardedDevices(),
        ],
      ),
    );
  }

  void _onWifiNetworkPressed() =>
      Navigator.pushNamed(context, Step4WifiSetupPage.route);

  Widget _renderBottom() {
    final devices = appProvider.qkDevices;
    final atLeastOneDeviceIsPaired = devices.any((element) => element.isPaired);

    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 31,
        horizontal: 16,
      ),
      child: QkButton(
        title: lang.t('next'),
        disabled: devices.isEmpty || !atLeastOneDeviceIsPaired,
        onPressed: _onWifiNetworkPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    appProvider = Provider.of<AppProvider>(context, listen: true);
    lang = AppLocalizations.of(context)!;
    measures = Measures(context);

    return PageLayout(
      body: _renderBody(),
      bottom: _renderBottom(),
    );
  }
}
