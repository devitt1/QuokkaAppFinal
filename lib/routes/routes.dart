// global RouteObserver
import 'package:flutter/material.dart';
import 'package:quokka_mobile_app/pages/step4_wifi_setup_page/step4_wifi_setup_page.dart';
import 'package:quokka_mobile_app/pages/step1_landing_page/step1_landing_page.dart';
import 'package:quokka_mobile_app/pages/my_quokkas_page/my_quokkas_page.dart';
import 'package:quokka_mobile_app/pages/step3_pairing_page/step3_pairing_page.dart';
import 'package:quokka_mobile_app/pages/step2_prepairing_page/step2_prepairing_page.dart';
import 'package:quokka_mobile_app/pages/stepx_start_page/stepx_start_page.dart';
import 'package:quokka_mobile_app/pages/stepx_give_your_quokka_page/stepx_give_your_quokka_page.dart';
import 'package:quokka_mobile_app/pages/test_page.dart';

final RouteObserver<ModalRoute> mainRouteObserver = RouteObserver<ModalRoute>();
// needed for navigation without using BuildContext
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case TestPage.route:
      return MaterialPageRoute(
        settings: const RouteSettings(name: TestPage.route),
        builder: (context) => const TestPage(),
      );
    case Step1LandingPage.route:
      return MaterialPageRoute(
        settings: const RouteSettings(name: Step1LandingPage.route),
        builder: (context) => const Step1LandingPage(),
      );
    case StepXStartPage.route:
      return MaterialPageRoute(
        settings: const RouteSettings(name: StepXStartPage.route),
        builder: (context) => const StepXStartPage(),
      );
    case StepXGiveYourQuokkaPage.route:
      return MaterialPageRoute(
        settings: RouteSettings(
            name: StepXGiveYourQuokkaPage.route, arguments: settings.arguments),
        builder: (context) => const StepXGiveYourQuokkaPage(),
      );
    case Step2PrepairingPage.route:
      return MaterialPageRoute(
        settings: const RouteSettings(name: Step2PrepairingPage.route),
        builder: (context) => const Step2PrepairingPage(),
      );
    case Step3PairingPage.route:
      return MaterialPageRoute(
        settings: const RouteSettings(name: Step3PairingPage.route),
        builder: (context) => const Step3PairingPage(),
      );
    case Step4WifiSetupPage.route:
      return MaterialPageRoute(
        settings: const RouteSettings(name: Step4WifiSetupPage.route),
        builder: (context) => const Step4WifiSetupPage(),
      );
    case MyQuokkasPage.route:
      return MaterialPageRoute(
        settings: const RouteSettings(name: MyQuokkasPage.route),
        builder: (context) => const MyQuokkasPage(),
      );
  }

  // default is always the Landing page
  return MaterialPageRoute(
    settings: const RouteSettings(name: Step1LandingPage.route),
    builder: (context) => const Step1LandingPage(),
  );

  // return MaterialPageRoute(
  //   settings: const RouteSettings(name: '/unknown'),
  //   builder: (context) => const _RouteErrorPage(
  //     title: 'Oops, something went wrong!',
  //     description: 'Maybe you forgot to register the route in router.dart?',
  //   ),
  // );
}

/*
class _RouteErrorPage extends StatelessWidget {
  /// The major text to be displayed in the page.
  final String title;

  /// Further description for the possible exception.
  final String? description;

  const _RouteErrorPage({
    required this.title,
    this.description,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
              ),
              if (description != null)
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: Text(
                    description!,
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      );
}
*/
