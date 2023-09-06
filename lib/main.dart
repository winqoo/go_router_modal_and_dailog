import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) => const MyHomePage(),
      routes: <RouteBase>[
        GoRoute(
          path: 'license',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return DialogPage(builder: (_) => const AboutDialog());
          },
        ),
        GoRoute(
          path: 'sheet',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return CupertinoModalPopupPage(
              ///The builder can return any widget we want, so we have full control over
              ///the height and shape
                builder: (_) => Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  color: Colors.white,
                  child: const CupertinoActionSheet(
                        title: Text("Dummy Title"),
                        message: FlutterLogo(),
                      ),
                ));
          },
        ),
        GoRoute(
            path: 'bottom-sheet',
            pageBuilder: (context, state) => ModalBottomSheetRoutePage(builder: (_) => const BottomSheetPage())),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Navigator playground',
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Super important  screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () => context.go('/license'),
              child: const Text("See licenses"),
            ),
            OutlinedButton(
              onPressed: () => context.go('/sheet'),
              child: const Text("See sheet"),
            ),
            ElevatedButton(
              child: const Text('Show BottomModalSheet'),
              onPressed: () {
                // Navigate to the bottom sheet route
                GoRouter.of(context).go('/bottom-sheet');
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// A dialog page with Material entrance and exit animations, modal barrier color,
/// and modal barrier behavior (dialog is dismissible with a tap on the barrier).
class DialogPage<T> extends Page<T> {
  final Offset? anchorPoint;
  final Color? barrierColor;
  final bool barrierDismissible;
  final String? barrierLabel;
  final bool useSafeArea;
  final CapturedThemes? themes;
  final WidgetBuilder builder;

  const DialogPage({
    required this.builder,
    this.anchorPoint,
    this.barrierColor = Colors.black54,
    this.barrierDismissible = true,
    this.barrierLabel,
    this.useSafeArea = true,
    this.themes,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  @override
  Route<T> createRoute(BuildContext context) => DialogRoute<T>(
      context: context,
      settings: this,
      builder: builder,
      anchorPoint: anchorPoint,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      themes: themes);
}

class CupertinoModalPopupPage<T> extends Page<T> {
  final Offset? anchorPoint;
  final Color? barrierColor;
  final bool barrierDismissible;
  final String barrierLabel;
  final bool semanticsDismissible;
  final WidgetBuilder builder;
  final ImageFilter? filter;

  const CupertinoModalPopupPage(
      {required this.builder,
      this.anchorPoint,
      this.barrierColor = kCupertinoModalBarrierColor,
      this.barrierDismissible = true,
      this.barrierLabel = "Dismiss",
      this.semanticsDismissible = true,
      this.filter,
      super.key});

  @override
  Route<T> createRoute(BuildContext context) => CupertinoModalPopupRoute<T>(
      builder: builder,
      barrierDismissible: barrierDismissible,
      anchorPoint: anchorPoint,
      barrierLabel: barrierLabel,
      barrierColor: barrierColor,
      filter: filter,
      semanticsDismissible: semanticsDismissible,
      settings: this);
}

class ModalBottomSheetRoutePage<T> extends Page<T> {
  final Offset? anchorPoint;
  final Color? barrierColor;
  final bool barrierDismissible;
  final String barrierLabel;
  final bool semanticsDismissible;
  final WidgetBuilder builder;
  final ImageFilter? filter;

  const ModalBottomSheetRoutePage(
      {required this.builder,
      this.anchorPoint,
      this.barrierColor = kCupertinoModalBarrierColor,
      this.barrierDismissible = true,
      this.barrierLabel = "Dismiss",
      this.semanticsDismissible = true,
      this.filter,
      super.key});

  @override
  Route<T> createRoute(BuildContext context) => ModalBottomSheetRoute<T>(
      builder: builder,
      anchorPoint: anchorPoint,
      barrierLabel: barrierLabel,
      settings: this,
      isScrollControlled: false);
}

class BottomSheetPage extends StatelessWidget {
  const BottomSheetPage({super.key});

  @override
  Widget build(BuildContext context) {
    ///The size of the container is fixed
    return Container(
      color: Colors.yellow,
      child: Center(
        child: ElevatedButton(
          child: const Text('Go Back'),
          onPressed: () {
            // Navigate back to home
            GoRouter.of(context).go('/');
          },
        ),
      ),
    );
  }
}
