import 'dart:async';
import 'dart:io';

import 'package:alchemist/alchemist.dart';

/// Wraps every test with the Alchemist VRT configuration.
///
/// Platform goldens (real fonts, per-OS) run locally only; CI goldens (Ahem
/// font, platform-independent) always run. Update files with
/// `flutter test --update-goldens`.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  final isCi = Platform.environment.containsKey('CI');
  return AlchemistConfig.runWithConfig(
    config: AlchemistConfig(
      platformGoldensConfig: PlatformGoldensConfig(enabled: !isCi),
    ),
    run: testMain,
  );
}
