import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:timetablist/models/models.dart';
import 'package:timetablist/state/state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  test('load returns null when nothing has been saved', () async {
    final store = SharedPreferencesDocumentStore();
    expect(await store.load(), isNull);
  });

  test('round-trips a document through JSON', () async {
    final store = SharedPreferencesDocumentStore();
    final document = Document(
      name: 'タイムテーブル',
      slotCategories: const [
        SlotCategory(
          id: 'perf',
          name: '出演枠',
          durationMinutes: 30,
          isPerformanceSlot: true,
        ),
      ],
      participants: const [Participant(id: 'alice', name: 'Alice')],
      timelines: [
        Timeline(
          id: 'day1',
          name: '１日目',
          startTime: TimelineTime.fromHoursAndMinutes(hour: 10, minute: 0),
          slots: const [
            Slot(id: 's1', categoryId: 'perf', participantId: 'alice'),
          ],
        ),
      ],
    );

    await store.save(document);
    expect(await store.load(), document);
  });
}
