import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quokka_mobile_app/app_localizations.dart';
import 'package:quokka_mobile_app/components/qk_button.dart';
import 'package:quokka_mobile_app/components/qk_card.dart';
import 'package:quokka_mobile_app/components/qk_helper_text.dart';
import 'package:quokka_mobile_app/components/page_layout.dart';
import 'package:quokka_mobile_app/components/spacer.dart';
import 'package:quokka_mobile_app/components/qk_switch.dart';
import 'package:quokka_mobile_app/components/qk_text_input.dart';
import 'package:quokka_mobile_app/constants.dart';
import 'package:quokka_mobile_app/models/qk_device_model.dart';
import 'package:quokka_mobile_app/theme/text_styles.dart';
import 'package:quokka_mobile_app/theme/theme_colors.dart';
import 'package:quokka_mobile_app/utils/measures.dart';

class StepXGiveYourQuokkaPage extends StatefulWidget {
  static const String route = '/step1_give_your_quokka_page';
  const StepXGiveYourQuokkaPage({super.key});

  @override
  State<StepXGiveYourQuokkaPage> createState() =>
      _StepXGiveYourQuokkaPageState();
}

class _StepXGiveYourQuokkaPageState extends State<StepXGiveYourQuokkaPage> {
  late AppLocalizations lang;
  late Measures measures;
  final TextEditingController _quokkaNameController = TextEditingController();

  void _onEnterScreen() {
    final selectedDevice =
        ModalRoute.of(context)!.settings.arguments as QkDeviceModel?;

    String deviceUnique =
        (selectedDevice?.deviceName ?? '').replaceFirst(BLUETOOTH_PREFIX, '');

    _quokkaNameController.text =
        PUBLIC_DOMAIN.replaceFirst(DOMAIN_VARIABLE, deviceUnique);
  }

  // DC: TODO: Implement this
  void _onSubmitPressed() {}

  Widget _renderSwitchOnPublic() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 31),
      child: QkCard(
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
                    lang.t('switch_on_public'),
                    style: TextStyles.roobertTextMd16Bold.copyWith(
                      color: ThemeColors.disabledStatus,
                    ),
                  ),
                  Separator(size: Size(0, Measures.separator10)),
                  Text(
                    lang.t('addressability_for_all_quokkas_by_default'),
                    style: TextStyles.roobertTextSm14.copyWith(
                      color: ThemeColors.disabledStatus,
                    ),
                  ),
                ],
              ),
            ),
            Separator(size: Size(Measures.separator64, 0)),
            const Align(
              alignment: AlignmentDirectional.topEnd,
              heightFactor: 0.5,
              child: QkSwitch(value: false),
            ),
          ],
        ),
      ),
    );
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
            child: Text(
              lang.t('give_your___quokka_a_home'),
              style: TextStyles.satoshiTextMd40Bold,
            ),
          ),
          Separator(
            size: Size(0, Measures.separator8),
          ),
          Text(
            lang.t(
                'your_quokka_can_be_configured_to_allow_accessibility_over_the_internet'),
            style: TextStyles.roobertTextMd16.copyWith(
              color: ThemeColors.subText,
            ),
          ),
          Separator(
            size: Size(0, Measures.separator32),
          ),
          QkTextInput(
            title: lang.t('choose_your_organization_name_or_quokka_subdomain'),
            controller: _quokkaNameController,
            disabled: true,
            fontSize: 14,
          ),
          Separator(
            size: Size(0, Measures.separator32),
          ),
          QkButton(
            title: lang.t("submit"),
            onPressed: _onSubmitPressed,
          ),
          Separator(
            size: Size(0, Measures.separator16),
          ),
          QkHelperText(
            title: lang.t('individual_quokkas_with_the_same_subdomain'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    lang = AppLocalizations.of(context)!;
    measures = Measures(context);
    return PageLayout(
      onEnterScreen: _onEnterScreen,
      body: _renderBody(),
      bottom: _renderSwitchOnPublic(),
    );
  }
}
