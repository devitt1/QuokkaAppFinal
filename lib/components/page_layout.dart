import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:quokka_mobile_app/routes/routes.dart';
import 'package:quokka_mobile_app/theme/theme_colors.dart';

class PageLayout extends StatefulWidget {
  final Widget? top;
  final Widget body;
  final Widget? bottom;
  final Color? backgroundColor;
  final Brightness? brightness;
  final Function()? onEnterScreen;
  final Function()? onExitScreen;
  final Function()? onPageRunOnce;
  final bool? resizeToAvoidBottomInset;

  /// PageLayout
  /// If `top` and `bottom` are set, then top and bottom will be fixed.
  /// If `top` is set, then the top will be fixed and `bottom` will be empty.

  const PageLayout({
    super.key,
    required this.body,
    this.top,
    this.bottom,
    this.onEnterScreen,
    this.onExitScreen,
    this.onPageRunOnce,
    this.backgroundColor,
    this.brightness,
    this.resizeToAvoidBottomInset = false,
  });

  @override
  State<PageLayout> createState() => _PageLayoutState();
}

class _PageLayoutState extends State<PageLayout> with RouteAware {
  void _onPageEnter() {
    () async {
      if (widget.onEnterScreen != null) {
        await Future.delayed(Duration.zero, () => widget.onEnterScreen!());
      }
    }();
  }

  void _onPageExit() {
    if (widget.onExitScreen != null) {
      widget.onExitScreen!();
    }
  }

  @override
  void didPush() {
    // Route was pushed onto navigator and is now topmost route.
    _onPageEnter();
    super.didPush();
  }

  @override
  void didPushNext() {
    // Covering route was popped off the navigator.
    _onPageExit();
    super.didPushNext();
  }

  @override
  void didPopNext() {
    // Covering route was popped off the navigator.
    _onPageEnter();
    super.didPopNext();
  }

  @override
  void didPop() {
    // Covering route was popped off the navigator.
    _onPageExit();
    super.didPop();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    mainRouteObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    mainRouteObserver.unsubscribe(this);
    super.dispose();
  }

  Widget _renderBottomWidget() => widget.bottom ?? const SizedBox.shrink();

  @override
  Widget build(BuildContext context) {
    //COMMENT:DC Adding support to modern Android-Q navigation bar
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: widget.brightness ?? Brightness.dark,
        statusBarIconBrightness: widget.brightness ?? Brightness.dark,
        statusBarBrightness: widget.brightness != null
            ? widget.brightness == Brightness.dark
                ? Brightness.dark
                : Brightness.light
            : Brightness.dark,
      ),
      child: Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset ?? false,
        backgroundColor: widget.backgroundColor ?? ThemeColors.background,
        body: widget.body,
        bottomNavigationBar: _renderBottomWidget(),
      ),
    );
  }
}
