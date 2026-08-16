import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/s.dart';
import '../../../models/models.dart';
import '../../../state/state.dart';
import '../../dialogs/app_dialogs.dart';
import '../../widgets/commit_int_field.dart';
import '../../widgets/commit_text_field.dart';
import 'property_scaffold.dart';

class SlotCategoryPropertyView extends ConsumerWidget {
  const SlotCategoryPropertyView({required this.categoryId, super.key});

  final String categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final document = ref.watch(documentProvider);
    final category = document.slotCategoryById(categoryId);
    if (category == null) return const SizedBox.shrink();

    final editor = ref.read(documentEditorProvider.notifier);

    return PropertyScaffold(
      children: [
        CommitTextField(
          value: category.name,
          label: s.fieldName,
          validator: (name) {
            if (document.isSlotCategoryNameTaken(name, exceptId: category.id)) {
              return s.errorDuplicateCategoryName;
            }
            return null;
          },
          onCommit: (name) {
            try {
              editor.updateSlotCategory(category.copyWith(name: name));
            } on ArgumentError catch (error) {
              showErrorDialog(context, editorErrorMessage(s, error));
            }
          },
        ),
        CommitIntField(
          value: category.durationMinutes,
          label: s.fieldDurationMinutes,
          min: 1,
          max: TimelineLimits.maxSlotDurationMinutes,
          onCommit: (minutes) async {
            try {
              editor.updateSlotCategoryDuration(category.id, minutes);
            } on ArgumentError catch (error) {
              await showErrorDialog(context, editorErrorMessage(s, error));
            }
          },
        ),
        ReadOnlyField(
          label: s.fieldPerformanceAttribute,
          value: category.isPerformanceSlot
              ? s.performanceAttributeLabel
              : '—',
        ),
        FilledButton.tonal(
          onPressed: () async {
            final confirmed = await showConfirmDialog(
              context,
              message: s.confirmDeleteSlotCategory,
            );
            if (confirmed != true || !context.mounted) return;
            editor.deleteSlotCategory(category.id);
            ref.read(selectionProvider.notifier).reset();
          },
          child: Text(s.actionDelete),
        ),
      ],
    );
  }
}
