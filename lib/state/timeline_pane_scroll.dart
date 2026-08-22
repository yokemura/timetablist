import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'timeline_pane_scroll.g.dart';

/// Bumped to ask the timeline pane to jump so the earliest timeline start
/// is at the top of the pane (after import or initial timeline creation).
@Riverpod(keepAlive: true)
class TimelinePaneScrollCue extends _$TimelinePaneScrollCue {
  @override
  int build() => 0;

  void request() => state++;
}
