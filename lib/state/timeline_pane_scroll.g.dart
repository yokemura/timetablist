// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_pane_scroll.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Bumped to ask the timeline pane to jump so the earliest timeline start
/// is at the top of the pane (after import or initial timeline creation).

@ProviderFor(TimelinePaneScrollCue)
final timelinePaneScrollCueProvider = TimelinePaneScrollCueProvider._();

/// Bumped to ask the timeline pane to jump so the earliest timeline start
/// is at the top of the pane (after import or initial timeline creation).
final class TimelinePaneScrollCueProvider
    extends $NotifierProvider<TimelinePaneScrollCue, int> {
  /// Bumped to ask the timeline pane to jump so the earliest timeline start
  /// is at the top of the pane (after import or initial timeline creation).
  TimelinePaneScrollCueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'timelinePaneScrollCueProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$timelinePaneScrollCueHash();

  @$internal
  @override
  TimelinePaneScrollCue create() => TimelinePaneScrollCue();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$timelinePaneScrollCueHash() =>
    r'67e93ed64be6a743d6b5b75df9890941a15bc179';

/// Bumped to ask the timeline pane to jump so the earliest timeline start
/// is at the top of the pane (after import or initial timeline creation).

abstract class _$TimelinePaneScrollCue extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
