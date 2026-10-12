// Copyright © App Verse Games. All rights reserved.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/embed_provider.dart';
import 'core/web/embed_bridge.dart';
import 'features/home/presentation/pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/nunito/OFL.txt');
    yield LicenseEntryWithLineBreaks(['Nunito'], license);
  });
  runApp(const ProviderScope(child: MathdokuApp()));
}

class MathdokuApp extends ConsumerStatefulWidget {
  const MathdokuApp({super.key});

  @override
  ConsumerState<MathdokuApp> createState() => _MathdokuAppState();
}

class _MathdokuAppState extends ConsumerState<MathdokuApp>
    with WidgetsBindingObserver {
  late final _EmbedNavObserver _navObserver;

  @override
  void initState() {
    super.initState();
    _navObserver = _EmbedNavObserver(onRoute: _postHeight);
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _postHeight());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() => _postHeight();

  void _postHeight() {
    if (!ref.read(isEmbeddedProvider)) return;
    final views = WidgetsBinding.instance.platformDispatcher.views;
    if (views.isEmpty) return;
    final view = views.first;
    postParentResizeMessage(view.physicalSize.height / view.devicePixelRatio);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mathdoku',
      theme: kidsTheme,
      debugShowCheckedModeBanner: false,
      navigatorObservers: [_navObserver],
      home: const HomePage(),
    );
  }
}

class _EmbedNavObserver extends NavigatorObserver {
  final VoidCallback onRoute;
  _EmbedNavObserver({required this.onRoute});

  @override
  void didPush(Route route, Route? previousRoute) {
    WidgetsBinding.instance.addPostFrameCallback((_) => onRoute());
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    WidgetsBinding.instance.addPostFrameCallback((_) => onRoute());
  }
}
