import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quokka_mobile_app/app_localizations.dart';
import 'package:quokka_mobile_app/components/page_layout.dart';
import 'package:quokka_mobile_app/components/qk_accordion_item.dart';
import 'package:quokka_mobile_app/components/qk_bottom_sheet.dart';
import 'package:quokka_mobile_app/components/qk_button.dart';
import 'package:quokka_mobile_app/components/spacer.dart';
import 'package:quokka_mobile_app/constants.dart';
import 'package:quokka_mobile_app/controllers/app_provider.dart';
import 'package:quokka_mobile_app/models/qk_device_model.dart';
import 'package:quokka_mobile_app/pages/step1_landing_page/step1_landing_page.dart';
import 'package:quokka_mobile_app/pages/test_page.dart';
import 'package:quokka_mobile_app/services/storage.dart';
import 'package:quokka_mobile_app/theme/text_styles.dart';
import 'package:quokka_mobile_app/theme/theme_colors.dart';
import 'package:quokka_mobile_app/utils/debug.dart';
import 'package:quokka_mobile_app/utils/measures.dart';
import 'package:quokka_mobile_app/utils/quokka.dart';

// ignore: constant_identifier_names
const UPDATE_INTERVAL_SECONDS = 5;

class MyQuokkasPage extends StatefulWidget {
  static const route = '/my-quokkas';
  const MyQuokkasPage({super.key});

  @override
  State<MyQuokkasPage> createState() => _MyQuokkasPageState();
}

class _MyQuokkasPageState extends State<MyQuokkasPage> {
  late AppLocalizations lang;
  List<QkDeviceModel> deviceList = [];
  int tapCount = 0;
  bool isRefreshing = false;
  Timer? _myTimer;

  // Read list of known devices from local storage and optionally
  // check if they are online if mobile connected to same WiFi network
  Future<List<QkDeviceModel>> getDevices({bool checkOnline = false}) async {
    final knownQuokkas = await storageGet(KNOWN_QUOKKAS_KEY);

    if (knownQuokkas == null || knownQuokkas.length < 3) return [];

    printDebug('knownQuokkas:\n$knownQuokkas');

    List<QkDeviceModel> updatedList = [];

    final localDeviceList = knownQuokkas.split('\n');

    for (String deviceInstance in localDeviceList) {
      final deviceInfo = deviceInstance.split('\t');

      final deviceUnique = deviceInfo[1].replaceFirst(BLUETOOTH_PREFIX, '');
      final ipAddress = deviceInfo[2];
      bool onlinePrivate = false;
      bool onlinePublic = false;

      // Check if device is online privately and publicly simultaneously
      if (checkOnline) {
        List<bool> result = await Future.wait([
          isOnline(ipAddress, isPublic: false),
          isOnline(deviceUnique, isPublic: true)
        ]);
        onlinePrivate = result[0];
        onlinePublic = result[1];
      }

      printDebug(
          '${deviceInfo[1]} - $checkOnline - $onlinePrivate - $onlinePublic');

      updatedList.add(
        QkDeviceModel(
          deviceId: deviceInfo[0],
          deviceName: deviceInfo[1],
          deviceIp: ipAddress,
          privateAddress:
              PUBLIC_DOMAIN.replaceFirst(DOMAIN_VARIABLE, deviceUnique),
          isOnlinePrivate: onlinePrivate,
          isOnlinePublic: onlinePublic,
        ),
      );
    }

    return updatedList;
  }

  void _onUnpair() async {
    if (!mounted) return;
    await storageSet(KNOWN_QUOKKAS_KEY, '');

    // ignore: use_build_context_synchronously
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.clearDevices();

    // ignore: use_build_context_synchronously
    Navigator.pushReplacementNamed(context, Step1LandingPage.route);
  }

  void _onUnpairQuokkaPressed() async {
    openBottomSheet(
      context: context,
      isDismissible: true,
      scrollable: true,
      enableDrag: true,
      hasDragIndicator: true,
      sheetSize: 0.7,
      dragColor: ThemeColors.secondaryBackground,
      backgroundColor: ThemeColors.cards,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: _AddQuokkaConfirmation(
        showUnpairText: true,
        onContinue: _onUnpair,
        onCancel: () => {Navigator.of(context).pop()},
      ),
    );
  }

  void _onAddQuokkaPressed() async {
    openBottomSheet(
      context: context,
      isDismissible: true,
      scrollable: true,
      enableDrag: true,
      hasDragIndicator: true,
      sheetSize: 0.7,
      dragColor: ThemeColors.secondaryBackground,
      backgroundColor: ThemeColors.cards,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: _AddQuokkaConfirmation(
        showUnpairText: false,
        onContinue: _onUnpair,
        onCancel: () => {Navigator.of(context).pop()},
      ),
    );
  }

  void refreshDeviceStatus() async {
    if (!isRefreshing) {
      printDebug('Refreshing ${DateTime.now()}');

      setState(() => isRefreshing = true);
      final onlineDevices = await getDevices(checkOnline: true);
      setState(() => deviceList = onlineDevices);
      setState(() => isRefreshing = false);
    }
  }

  void _enterScreen() {
    (() async {
      final knownDevices = await getDevices(checkOnline: false);
      setState(() => deviceList = knownDevices);

      // Wait 1 second before checking if devices are online
      Future.delayed(const Duration(seconds: 1), () {});

      refreshDeviceStatus();

      _myTimer = Timer.periodic(
          const Duration(seconds: UPDATE_INTERVAL_SECONDS), (timer) {
        refreshDeviceStatus();
      });
    })();
  }

  void _exitScreen() {
    _myTimer?.cancel();
  }

  Widget _renderBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 49,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.fitWidth,
            child: GestureDetector(
              child: Text(
                lang.t('my_quokkas'),
                style: TextStyles.satoshiTextMd40Bold,
              ),
              onTap: () {
                refreshDeviceStatus();

                tapCount++;
                if (tapCount == 6) {
                  tapCount = 0;
                  Navigator.pushNamed(context, TestPage.route);
                }
              },
            ),
          ),
          Container(
            height: 32,
            alignment: Alignment.center,
            child: isRefreshing
                ? const CircularProgressIndicator()
                : const SizedBox(height: 0),
          ),
          Separator(
            size: Size(0, Measures.separator16),
          ),
          ListView.separated(
            shrinkWrap: true,
            itemCount: deviceList.length,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemBuilder: (_, index) {
              final deviceInfo = deviceList[index];

              return QkAccordionItem(
                  device: deviceInfo, unpairAction: _onUnpairQuokkaPressed);
            },
            separatorBuilder: (context, index) =>
                Separator(size: Size(0, Measures.separator16)),
          ),
        ],
      ),
    );
  }

  Widget _renderBottomButton() => Container(
        margin: const EdgeInsets.symmetric(
          vertical: 31,
          horizontal: 16,
        ),
        child: QkButton(
          title: lang.t('add_quokka'),
          onPressed: _onAddQuokkaPressed,
        ),
      );

  @override
  void dispose() {
    // TODO: implement initState
    _myTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    lang = AppLocalizations.of(context)!;
    return PageLayout(
      onEnterScreen: _enterScreen,
      onExitScreen: _exitScreen,
      body: _renderBody(),
      bottom: _renderBottomButton(),
    );
  }
}

class _AddQuokkaConfirmation extends StatelessWidget {
  const _AddQuokkaConfirmation({
    required this.onContinue,
    required this.onCancel,
    required this.showUnpairText,
  });

  final dynamic Function()? onContinue;
  final dynamic Function()? onCancel;
  final bool showUnpairText;

  @override
  Widget build(BuildContext context) {
    final measures = Measures(context);
    final lang = AppLocalizations.of(context)!;

    return Column(
      children: [
        Image.asset(
          showUnpairText
              ? 'lib/assets/images/unpair_quokka.png'
              : 'lib/assets/images/add_quokka.png',
          width: measures.width(15),
        ),
        const SizedBox(height: 10),
        Text(
          style: TextStyles.roobertTextLg20Bold,
          lang.t(showUnpairText
              ? 'you_are_unpairing_the_quokka_device'
              : 'you_are_adding_a_new_device'),
        ),
        const SizedBox(height: 5),
        Text(
          style: TextStyles.roobertTextMd16,
          textAlign: TextAlign.center,
          lang.t(showUnpairText
              ? 'the_previously_paired_quokka_device_will_be_unpaired'
              : 'adding_a_new_quokka_device_will_unpair_the_quokka'),
        ),
        const SizedBox(height: 5),
        Text(
          style: TextStyles.roobertTextMd16,
          textAlign: TextAlign.center,
          lang.t('would_you_like_to_proceed'),
        ),
        const SizedBox(height: 20),
        SizedBox(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            SizedBox(
              width: measures.deviceWidth / 2 - 20,
              child: QkButton(
                title: lang.t('cancel'),
                type: QkButtonType.secondary,
                onPressed: onCancel,
              ),
            ),
            SizedBox(
              width: measures.deviceWidth / 2 - 20,
              child: QkButton(
                title: lang.t('continue'),
                type: QkButtonType.primary,
                onPressed: onContinue,
              ),
            ),
          ]),
        )
      ],
    );
  }
}
