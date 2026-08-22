/// Stem used when the document name is empty or only illegal characters.
const defaultDownloadStem = 'timetable';

/// Builds `{sanitizedName}.{extension}`, dropping characters that cannot
/// appear in a file name. Falls back to [defaultDownloadStem] if nothing
/// usable remains.
String downloadFileName(String documentName, String extension) {
  var stem = documentName.trim().replaceAll(
    RegExp(r'[\\/:*?"<>|\x00-\x1F]'),
    '',
  );
  stem = stem.replaceAll(RegExp(r'\.+$'), '');
  if (stem.isEmpty) stem = defaultDownloadStem;
  return '$stem.$extension';
}
