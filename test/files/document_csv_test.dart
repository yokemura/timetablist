import 'package:flutter_test/flutter_test.dart';
import 'package:timetablist/files/document_csv.dart';
import 'package:timetablist/files/download_file_name.dart';
import 'package:timetablist/models/models.dart';

const _jaLabels = DocumentCsvLabels(
  timeline: 'タイムライン名',
  start: '開始時刻',
  end: '終了時刻',
  duration: '時間長',
  slotType: '枠タイプ名',
  performer: '演者名',
);

const _performance = SlotCategory(
  id: 'perf',
  name: '出演',
  durationMinutes: 30,
  isPerformanceSlot: true,
);

const _changeover = SlotCategory(
  id: 'gap',
  name: '転換',
  durationMinutes: 10,
  isPerformanceSlot: false,
);

const _alice = Participant(id: 'alice', name: 'Alice');

Timeline _timeline({
  required String id,
  required String name,
  required List<Slot> slots,
}) {
  return Timeline(
    id: id,
    name: name,
    startTime: TimelineTime.fromHoursAndMinutes(hour: 10, minute: 0),
    slots: slots,
  );
}

String _withoutBom(String csv) {
  expect(csv.startsWith('\uFEFF'), isTrue);
  return csv.substring(1);
}

void main() {
  group('downloadFileName', () {
    test('uses the document name and extension', () {
      expect(downloadFileName('マイタイムテーブル', 'csv'), 'マイタイムテーブル.csv');
    });

    test('strips illegal characters and falls back when empty', () {
      expect(downloadFileName(r'a/b:c*', 'json'), 'abc.json');
      expect(downloadFileName('   ', 'csv'), 'timetable.csv');
      expect(downloadFileName('...', 'csv'), 'timetable.csv');
    });
  });

  group('encodeDocumentCsv', () {
    test(
      'writes a BOM, CRLF rows, and header only when there are no timelines',
      () {
        final csv = encodeDocumentCsv(
          Document.empty(name: 'タイムテーブル'),
          _jaLabels,
        );
        expect(_withoutBom(csv), '開始時刻,終了時刻,時間長,枠タイプ名,演者名\r\n');
      },
    );

    test('omits the timeline column when there is one timeline', () {
      final document = Document(
        name: 'タイムテーブル',
        timelines: [
          _timeline(
            id: 'day1',
            name: '１日目',
            slots: const [
              Slot(id: 's1', categoryId: 'perf', participantId: 'alice'),
              Slot(id: 's2', categoryId: 'gap'),
              Slot(id: 's3', categoryId: 'perf'),
            ],
          ),
        ],
        slotCategories: const [_performance, _changeover],
        participants: const [_alice],
      );

      expect(
        _withoutBom(encodeDocumentCsv(document, _jaLabels)),
        '開始時刻,終了時刻,時間長,枠タイプ名,演者名\r\n'
        '10:00,10:30,30,出演,Alice\r\n'
        '10:30,10:40,10,転換,\r\n'
        '10:40,11:10,30,出演,\r\n',
      );
    });

    test('prefixes a timeline column when there are two or more timelines', () {
      final document = Document(
        name: 'タイムテーブル',
        timelines: [
          _timeline(
            id: 'a',
            name: '会場A',
            slots: const [
              Slot(id: 's1', categoryId: 'perf', participantId: 'alice'),
            ],
          ),
          _timeline(
            id: 'b',
            name: '会場B',
            slots: const [Slot(id: 's2', categoryId: 'gap')],
          ),
        ],
        slotCategories: const [_performance, _changeover],
        participants: const [_alice],
      );

      expect(
        _withoutBom(encodeDocumentCsv(document, _jaLabels)),
        'タイムライン名,開始時刻,終了時刻,時間長,枠タイプ名,演者名\r\n'
        '会場A,10:00,10:30,30,出演,Alice\r\n'
        '会場B,10:00,10:10,10,転換,\r\n',
      );
    });

    test('quotes fields that contain commas, quotes, or newlines', () {
      expect(escapeCsvField('a,b'), '"a,b"');
      expect(escapeCsvField('say "hi"'), '"say ""hi"""');
      expect(escapeCsvField('line\nbreak'), '"line\nbreak"');
    });
  });
}
