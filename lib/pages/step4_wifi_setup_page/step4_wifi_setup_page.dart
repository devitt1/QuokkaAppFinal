import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:quokka_mobile_app/app_localizations.dart';
import 'package:quokka_mobile_app/components/page_layout.dart';
import 'package:quokka_mobile_app/components/qk_bottom_sheet.dart';
import 'package:quokka_mobile_app/components/qk_button.dart';
import 'package:quokka_mobile_app/components/qk_option_picker.dart';
import 'package:quokka_mobile_app/components/qk_text_input.dart';
import 'package:quokka_mobile_app/components/qk_wifi_scanner.dart';
import 'package:quokka_mobile_app/components/spacer.dart';
import 'package:quokka_mobile_app/components/wifi_connecting_modal.dart';
import 'package:quokka_mobile_app/constants.dart';
import 'package:quokka_mobile_app/services/qk_ble.dart';
import 'package:quokka_mobile_app/controllers/app_provider.dart';
import 'package:quokka_mobile_app/theme/text_styles.dart';
import 'package:quokka_mobile_app/theme/theme_colors.dart';
import 'package:quokka_mobile_app/theme/theme_icons.dart';
import 'package:quokka_mobile_app/utils/debug.dart';
import 'package:quokka_mobile_app/utils/measures.dart';

class Step4WifiSetupPage extends StatefulWidget {
  static const String route = '/choose_wifi_network_page';
  const Step4WifiSetupPage({super.key});

  @override
  State<Step4WifiSetupPage> createState() => _Step4WifiSetupPageState();
}

class _Step4WifiSetupPageState extends State<Step4WifiSetupPage> {
  late AppLocalizations lang;
  late AppProvider appProvider;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _qkNameController = TextEditingController();
  bool _isPasswordHidden = true;
  QkBLE bt = QkBLE();

  void _togglePasswordVisibility() =>
      setState(() => _isPasswordHidden = !_isPasswordHidden);

  void _onSubmitPressed() async {
    printDebug('Setting device Wifi');

    if (!mounted) return;

    appProvider.tryWifiConnection(
        context, appProvider.selectedWifiNetwork, _passwordController.text, bt);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          QkWifiConnectionModal(type: appProvider.wifiConnectStatus),
    );
  }

  void _showWifiNetworks() {
    openBottomSheet(
      context: context,
      isDismissible: true,
      scrollable: true,
      enableDrag: true,
      hasDragIndicator: true,
      headerTitle: lang.t('wifi_network_scanner_title'),
      sheetSize: 1,
      dragColor: ThemeColors.secondaryBackground,
      backgroundColor: ThemeColors.cards,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: const QkWifiScanner(),
    );
  }

// DC: post MVP validate quokka name field
  bool isValidForm() =>
      _passwordController.text.isNotEmpty &&
      appProvider.selectedWifiNetwork.isNotEmpty;

  Widget _renderBottom() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 31,
        horizontal: Measures.separator16,
      ),
      child: QkButton(
        title: lang.t("submit"),
        onPressed: _onSubmitPressed,
        disabled: !isValidForm(),
      ),
    );
  }

  Widget _renderBody() {
    final deviceUnique =
        appProvider.qkDevices.first.deviceName.replaceAll(BLUETOOTH_PREFIX, '');

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: Measures.separator16,
        vertical: 49,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              lang.t("choose_wifi_network_page_title"),
              style: TextStyles.satoshiTextMd40Bold,
            ),
          ),
          Separator(
            size: Size(0, Measures.separator16),
          ),
          QkOptionPicker(
            title: lang.t("choose_wifi_network_page_wifi_network"),
            hintText: appProvider.selectedWifiNetwork.isNotEmpty
                ? appProvider.selectedWifiNetwork
                : lang.t("choose_wifi_network_page_wifi_network_placeholder"),
            withBorder: true,
            onPickerPressed: _showWifiNetworks,
          ),
          Separator(
            size: Size(0, Measures.separator16),
          ),
          QkTextInput(
            title: lang.t("password"),
            controller: _passwordController,
            obscureText: _isPasswordHidden,
            keyboardType: TextInputType.visiblePassword,
            placeholder: lang.t("enter_password"),
            suffixIcon: IconButton(
              icon: const Icon(
                ThemeIcons.eye,
                color: ThemeColors.button,
              ),
              onPressed: _togglePasswordVisibility,
            ),
          ),
          Separator(
            size: Size(0, Measures.separator16),
          ),
          QkTextInput(
            title: lang.t("choose_wifi_network_page_quokka_name"),
            controller: _qkNameController,
            placeholder:
                PUBLIC_DOMAIN.replaceFirst(DOMAIN_VARIABLE, deviceUnique),
            disabled: true,
            fontSize: 14,
          ),
          const Separator(
            size: Size(0, 150),
          ),
        ],
      ),
    );
  }

  void _closeKeyboard() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    lang = AppLocalizations.of(context)!;
    appProvider = Provider.of<AppProvider>(context);

    return GestureDetector(
      onTap: _closeKeyboard,
      child: PageLayout(
        body: _renderBody(),
        bottom: _renderBottom(),
      ),
    );
  }
}
