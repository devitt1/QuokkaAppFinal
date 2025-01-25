import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:quokka_mobile_app/app_localizations.dart';
import 'package:quokka_mobile_app/app_localizations_delegate.dart';
import 'package:quokka_mobile_app/pages/step1_landing_page/step1_landing_page.dart';
import 'package:quokka_mobile_app/routes/routes.dart';
import 'package:quokka_mobile_app/controllers/app_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
      ),
    );
    return MaterialApp(
      title: 'Quokka',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roobert',
        useMaterial3: true,
      ),
      locale: appProvider.lang,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizationsDelegate.supportedLocales,
      initialRoute: Step1LandingPage.route,
      navigatorObservers: [mainRouteObserver],
      onGenerateRoute: onGenerateRoute,
      navigatorKey: navigatorKey,
    );
  }
}
