import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'l10n/generated/s.dart';
import 'models/models.dart';
import 'state/state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = SharedPreferencesDocumentStore();

  Document? saved;
  try {
    saved = await store.load();
  } catch (_) {
    saved = null; // Unreadable saved data: start with a fresh document.
  }

  // The default document name is localized once at creation and then stored
  // as-is (never retranslated), so resolve the OS locale here.
  final locale = basicLocaleListResolution(
    WidgetsBinding.instance.platformDispatcher.locales,
    S.supportedLocales,
  );
  final document =
      saved ?? Document.empty(name: lookupS(locale).defaultDocumentName);

  runApp(
    ProviderScope(
      overrides: [
        documentStoreProvider.overrideWithValue(store),
        initialDocumentProvider.overrideWithValue(document),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => S.of(context).appTitle,
      localizationsDelegates: S.localizationsDelegates,
      supportedLocales: S.supportedLocales,
      home: const HomePage(),
    );
  }
}

/// Placeholder home screen; replaced by the real shell in the next step.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final document = ref.watch(documentProvider);
    return Scaffold(body: Center(child: Text(document.name)));
  }
}
