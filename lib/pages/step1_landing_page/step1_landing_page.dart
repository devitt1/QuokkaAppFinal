import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quokka_mobile_app/app_localizations.dart';
import 'package:quokka_mobile_app/components/qk_button.dart';
import 'package:quokka_mobile_app/components/page_layout.dart';
import 'package:quokka_mobile_app/constants.dart';
import 'package:quokka_mobile_app/pages/my_quokkas_page/my_quokkas_page.dart';
import 'package:quokka_mobile_app/pages/step2_prepairing_page/step2_prepairing_page.dart';
import 'package:quokka_mobile_app/services/storage.dart';
import 'package:quokka_mobile_app/controllers/app_provider.dart';
import 'package:quokka_mobile_app/utils/debug.dart';
import 'package:quokka_mobile_app/utils/measures.dart';

import '../test_page.dart';

class Step1LandingPage extends StatefulWidget {
  static const String route = '/landing_page';
  const Step1LandingPage({super.key});

  @override
  State<Step1LandingPage> createState() => _Step1LandingPageState();
}

class _Step1LandingPageState extends State<Step1LandingPage> {
  late Measures measures;
  late AppLocalizations lang;
  late AppProvider appProvider;
  int tapCount = 0;

  void _enterScreen() {
    (() async {
      printDebug('Entering page');

      // DEBUG: write a local device to skip the landing page
      // await storageSet(KNOWN_QUOKKAS_KEY, 'C4:3C:B0:AD:D9:10\ttheq-7a2a9\t192.168.43.4');
      Future.delayed(const Duration(seconds: 1), () {});

      final knownQuokkas = await storageGet(KNOWN_QUOKKAS_KEY);

      if (knownQuokkas == null || knownQuokkas.length < 3) return;

      if (mounted) Navigator.pushReplacementNamed(context, MyQuokkasPage.route);
    })();
  }

  void onDevicePairingPressed() {
    appProvider.clearDevices();
    Navigator.pushNamed(context, Step2PrepairingPage.route);
  }

  Widget _renderBody() {
    return Center(
      child: SizedBox(
        width: measures.width(35),
        height: measures.width(35),
        child: GestureDetector(
          child: Image.asset(
            'lib/assets/images/logo.png',
            fit: BoxFit.contain,
          ),
          onTap: () {
            tapCount++;
            if (tapCount == 6) {
              tapCount = 0;
              Navigator.pushNamed(context, TestPage.route);
            }
          },
        ),
      ),
    );
  }

  Widget _renderBottomButton() {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 31,
        horizontal: 16,
      ),
      child: QkButton(
        title: lang.t('start_device_pairing'),
        onPressed: onDevicePairingPressed,
      ),
    );
  }

  Future<void> onBackPressed() async => await SystemChannels.platform
      .invokeMethod<void>('SystemNavigator.pop', false);

  @override
  Widget build(BuildContext context) {
    lang = AppLocalizations.of(context)!;
    measures = Measures(context);
    appProvider = Provider.of<AppProvider>(context, listen: true);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async => await onBackPressed(),
      child: PageLayout(
        onEnterScreen: _enterScreen,
        body: _renderBody(),
        bottom: _renderBottomButton(),
      ),
    );
  }
}
