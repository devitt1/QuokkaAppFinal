import 'package:flutter/material.dart';
import 'package:quokka_mobile_app/app_localizations.dart';
import 'package:quokka_mobile_app/components/page_layout.dart';
import 'package:quokka_mobile_app/components/qk_button.dart';
import 'package:quokka_mobile_app/components/qk_circle_animation.dart';
import 'package:quokka_mobile_app/components/qk_helper_text.dart';
import 'package:quokka_mobile_app/components/qk_option_picker.dart';
import 'package:quokka_mobile_app/components/spacer.dart';
import 'package:quokka_mobile_app/pages/step3_pairing_page/step3_pairing_page.dart';
import 'package:quokka_mobile_app/services/qk_ble.dart';
import 'package:quokka_mobile_app/theme/text_styles.dart';
import 'package:quokka_mobile_app/theme/theme_colors.dart';
import 'package:quokka_mobile_app/theme/theme_icons.dart';
import 'package:quokka_mobile_app/utils/measures.dart';

class Step2PrepairingPage extends StatefulWidget {
  static const String route = '/pairing_screen';
  const Step2PrepairingPage({super.key});

  @override
  State<Step2PrepairingPage> createState() => _Step2PrepairingPageState();
}

class _Step2PrepairingPageState extends State<Step2PrepairingPage> {
  late final AppLifecycleListener _listener;
  late AppLocalizations lang;
  late Measures measures;
  int _selectedStep = 1;
  final bt = QkBLE();
  bool isBtEnabled = false;
  bool isBtSupported = false;
  bool isBluetoothValidated = false;

  void _onPageEnter() async {
    await _handleBluetoothStatus();
  }

  void _onResumed() async {
    await _handleBluetoothStatus();
  }

  Future<void> _handleBluetoothStatus() async {
    bool isSupported = await bt.isSupported();
    if (!isSupported) {
      setState(() {
        isBtSupported = false;
        isBluetoothValidated = true;
      });
      return;
    }

    final isEnabled = await bt.isEnabled();
    // TODO: Show a modal to ask user to enable bluetooth
    setState(() {
      isBtEnabled = isEnabled;
      isBtSupported = true;
      isBluetoothValidated = true;
      if (isEnabled) _selectedStep = 2;
    });

    // if (mounted) Navigator.pushNamed(context, Step3PairingPage.route);
  }

  void _onStateChanged(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _onResumed();
      default:
      // DC: Silence is golden
    }
  }

  void _handleFirstStepPressed() => setState(() => _selectedStep = 2);

  void _handleSecondStepPressed() =>
      Navigator.pushNamed(context, Step3PairingPage.route);

  Widget _statusPill(String pillText) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: ThemeColors.disabledStatus,
        borderRadius: BorderRadius.circular(
            20), // adjust this value to change pill roundness
      ),
      child: Text(
        pillText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _renderBody() {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Positioned.fill(
          top: -measures.height(45),
          left: 0,
          right: 0,
          child: const QKCircleAnimation(),
        ),
        Positioned.fill(
          top: -measures.height(40),
          left: 0,
          right: 0,
          child: Image.asset(
            'lib/assets/images/device_white.png',
            fit: BoxFit.fitWidth,
          ),
        ),
      ],
    );
  }

  Widget _renderTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: measures.width(Measures.separator8),
          height: 4,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(2),
            ),
            color: ThemeColors.secondaryBackground,
          ),
        ),
        Separator(
          size: Size(0, Measures.separator22),
        ),
        Text(
          lang.t('pairing'),
          style: TextStyles.satoshiTextMd32Bold,
          textAlign: TextAlign.center,
        ),
        Separator(
          size: Size(0, Measures.separator8),
        ),
        _selectedStep == 1
            ? Text(
                lang.t('make_sure_your_quokka_is_connected_to_power'),
                style: TextStyles.roobertTextMd16.copyWith(
                  color: ThemeColors.subText,
                ),
                textAlign: TextAlign.center,
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  Widget _renderStep1() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            _renderTitle(),
            Separator(size: Size(0, Measures.separator32)),
            Container(
              padding: EdgeInsets.all(Measures.separator16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: ThemeColors.lines,
                  width: 1,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Measures.separator8),
                  topRight: Radius.circular(Measures.separator8),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          lang.t('bluetooth'),
                          style: TextStyles.roobertTextMd16Bold,
                        ),
                        Separator(size: Size(0, Measures.separator8)),
                        Text(
                          lang.t('make_sure_your_bluetooth_is_switched_on'),
                          style: TextStyles.roobertTextSm14.copyWith(
                            color: ThemeColors.subText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Separator(size: Size(Measures.separator64, 0)),
                  Align(
                    alignment: AlignmentDirectional.topEnd,
                    heightFactor: 0.5,
                    child: _statusPill(lang.t('off')),
                  ),
                ],
              ),
            ),
          ],
        ),
        QkButton(
          title: lang.t('next'),
          onPressed: _handleFirstStepPressed,
          disabled: !isBtSupported || !isBluetoothValidated || !isBtEnabled,
        ),
      ],
    );
  }

  Widget _renderStep2() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            _renderTitle(),
            Separator(size: Size(0, Measures.separator32)),
            QkOptionPicker(
              title: lang.t('how_many_quokkas_do_you_wish_to_onboard'),
              titleColor: ThemeColors.title,
              hintText: "",
              defaultValue: "1",
              onPickerPressed: () {},
              withBorder: true,
              disabled: true,
            ),
            Separator(size: Size(0, Measures.separator8)),
            QkHelperText(
              title: lang.t(
                  'make_sure_the_quokkas_you_wish_to_onboard_are_currently_powered'),
              showIcon: false,
            ),
          ],
        ),
        QkButton(
          title: lang.t('next'),
          onPressed: _handleSecondStepPressed,
        ),
      ],
    );
  }

  void handleNextPressed() {
    if (_selectedStep == 1) {
      setState(() => _selectedStep = 2);
      return;
    }

    Navigator.pushNamed(context, Step3PairingPage.route);
  }

  Widget _renderNotSupported() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Separator(size: Size(0, Measures.separator8)),
            const Icon(
              ThemeIcons.warning,
              color: ThemeColors.errorStatus,
            ),
            Separator(size: Size(0, Measures.separator8)),
            Text(
              lang.t("bluetooth_not_supported"),
              style: TextStyles.roobertTextLg20Bold,
              textAlign: TextAlign.center,
            ),
            Separator(size: Size(0, Measures.separator8)),
            Text(
              lang.t("bluetooth_not_supported_description"),
              style: TextStyles.roobertTextMd16,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }

  Widget _renderBottomContent() {
    if (!isBluetoothValidated) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (!isBtSupported) {
      return _renderNotSupported();
    }

    if (_selectedStep == 1) {
      return _renderStep1();
    }

    return _renderStep2();
  }

  Widget _renderBottom() {
    return Container(
      padding: EdgeInsets.only(
        top: 13,
        bottom: 31,
        left: Measures.separator16,
        right: Measures.separator16,
      ),
      height: measures.height(53),
      decoration: const BoxDecoration(
        color: ThemeColors.cards,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: _renderBottomContent(),
    );
  }

  void onBackButtonPressed() async {
    if (_selectedStep == 2) {
      // setState(() => _selectedStep = 1);
      Navigator.pop(context);
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      _listener = AppLifecycleListener(
        onStateChange: _onStateChanged,
      );
    });
  }

  @override
  void dispose() {
    // Do not forget to dispose the listener
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    lang = AppLocalizations.of(context)!;
    measures = Measures(context);
    return PopScope(
      canPop: _selectedStep == 1,
      onPopInvoked: (didPop) => onBackButtonPressed(),
      child: PageLayout(
        onEnterScreen: _onPageEnter,
        body: _renderBody(),
        bottom: _renderBottom(),
      ),
    );
  }
}
