import 'package:flutter/material.dart';
import 'package:quokka_mobile_app/app_localizations.dart';
import 'package:quokka_mobile_app/components/qk_button.dart';
import 'package:quokka_mobile_app/components/qk_option_picker.dart';
import 'package:quokka_mobile_app/components/page_layout.dart';
import 'package:quokka_mobile_app/components/spacer.dart';
import 'package:quokka_mobile_app/pages/stepx_give_your_quokka_page/stepx_give_your_quokka_page.dart';
import 'package:quokka_mobile_app/theme/text_styles.dart';
import 'package:quokka_mobile_app/theme/theme_colors.dart';
import 'package:quokka_mobile_app/utils/measures.dart';

class StepXStartPage extends StatefulWidget {
  static const String route = '/start_device_pairing_page';
  const StepXStartPage({super.key});

  @override
  State<StepXStartPage> createState() => _StepXStartPageState();
}

class _StepXStartPageState extends State<StepXStartPage> {
  late AppLocalizations lang;
  late Measures measures;

  // DC: TODO: Implement design here
  void _onChooseQuokkaPressed() {
    showModalBottomSheet(
      backgroundColor: ThemeColors.cards,
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(maxHeight: measures.height(65)),
      scrollControlDisabledMaxHeightRatio: 1,
      builder: (context) {
        return const SizedBox.shrink();
      },
    );
  }

  void _onAddDevicePressed() =>
      Navigator.pushNamed(context, StepXGiveYourQuokkaPage.route);

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
              lang.t('start_device_pairing'),
              style: TextStyles.satoshiTextMd40Bold,
            ),
          ),
          Separator(
            size: Size(0, Measures.separator8),
          ),
          Text(
            lang.t('start_device_pairing_page_description'),
            style: TextStyles.roobertTextMd16.copyWith(
              color: ThemeColors.subText,
            ),
          ),
          Separator(
            size: Size(0, Measures.separator32),
          ),
          QkOptionPicker(
            title: lang.t('choose_your_quokka'),
            hintText: lang.t('select_your_quokka'),
            withBorder: true,
            onPickerPressed: _onChooseQuokkaPressed,
          ),
          Separator(
            size: Size(0, Measures.separator32),
          ),
          QkButton(
            title: lang.t("add_device"),
            onPressed: _onAddDevicePressed,
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
      body: _renderBody(),
    );
  }
}
