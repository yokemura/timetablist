import '../models/models.dart';

/// Localized CSV header labels. Slot type, performer, and timeline *values*
/// are taken from the document as stored and are not translated.
class DocumentCsvLabels {
  const DocumentCsvLabels({
    required this.timeline,
    required this.start,
    required this.end,
    required this.duration,
    required this.slotType,
    required this.performer,
  });

  final String timeline;
  final String start;
  final String end;
  final String duration;
  final String slotType;
  final String performer;
}

/// Encodes [document] as a UTF-8 BOM CSV (CRLF, RFC 4180 quoting).
String encodeDocumentCsv(Document document, DocumentCsvLabels labels) {
  final includeTimeline = document.timelines.length >= 2;
  final rows = <List<String>>[
    [
      if (includeTimeline) labels.timeline,
      labels.start,
      labels.end,
      labels.duration,
      labels.slotType,
      labels.performer,
    ],
  ];

  for (final timeline in document.timelines) {
    for (final placed in document.placedSlotsOf(timeline)) {
      final performer = placed.category.isPerformanceSlot
          ? (placed.participant?.name ?? '')
          : '';
      rows.add([
        if (includeTimeline) timeline.name,
        placed.startTime.toDisplayString(),
        placed.endTime.toDisplayString(),
        '${placed.durationMinutes}',
        placed.category.name,
        performer,
      ]);
    }
  }

  final body = rows
      .map((row) => row.map(escapeCsvField).join(','))
      .join('\r\n');
  return '\uFEFF$body\r\n';
}

String escapeCsvField(String value) {
  if (value.contains(',') ||
      value.contains('"') ||
      value.contains('\r') ||
      value.contains('\n')) {
    return '"${value.replaceAll('"', '""')}"';
  }
  return value;
}
