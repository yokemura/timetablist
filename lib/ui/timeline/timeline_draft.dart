import '../../models/models.dart';

/// In-progress choice of a slot category: an existing one, or a new one
/// being typed (used by the slot property pane's category picker).
class CategoryDraft {
  const CategoryDraft({
    this.existing,
    this.newName = '',
    this.newDurationText = '',
    required this.isPerformanceSlot,
  });

  final SlotCategory? existing;
  final String newName;
  final String newDurationText;
  final bool isPerformanceSlot;

  bool get isNew => existing == null;

  String get name => existing?.name ?? newName.trim();

  int? get durationMinutes {
    if (existing != null) return existing!.durationMinutes;
    final value = int.tryParse(newDurationText.trim());
    if (value == null ||
        value < 1 ||
        value > TimelineLimits.maxSlotDurationMinutes) {
      return null;
    }
    return value;
  }

  CategoryDraft copyWith({
    SlotCategory? existing,
    bool clearExisting = false,
    String? newName,
    String? newDurationText,
  }) {
    return CategoryDraft(
      existing: clearExisting ? null : (existing ?? this.existing),
      newName: newName ?? this.newName,
      newDurationText: newDurationText ?? this.newDurationText,
      isPerformanceSlot: isPerformanceSlot,
    );
  }
}
