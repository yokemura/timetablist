import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/s.dart';
import '../../state/state.dart';
import '../sheets/slot_category_create_sheet.dart';
import '../timeline/drag_data.dart';
import '../widgets/drag_ghosts.dart';
import '../widgets/slot_category_list_item.dart';

/// Top-left pane: scrollable slot category list plus a creation button.
/// Shows nothing but the button while the list is empty.
class SlotCategoryPane extends ConsumerWidget {
  const SlotCategoryPane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final document = ref.watch(documentProvider);
    final selection = ref.watch(effectiveSelectionProvider);

    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              // Clicking empty space selects the document.
              onTap: () => ref.read(selectionProvider.notifier).reset(),
              child: ListView.builder(
                itemCount: document.slotCategories.length,
                itemBuilder: (context, index) {
                  final category = document.slotCategories[index];
                  final item = SlotCategoryListItem(
                    category: category,
                    selected:
                        selection ==
                        Selection.slotCategory(slotCategoryId: category.id),
                    onTap: () => ref
                        .read(selectionProvider.notifier)
                        .select(
                          Selection.slotCategory(slotCategoryId: category.id),
                        ),
                  );
                  return Draggable<SlotCategoryDragData>(
                    data: SlotCategoryDragData(category),
                    dragAnchorStrategy: pointerDragAnchorStrategy,
                    feedback: SlotCategoryDragGhost(category: category),
                    child: item,
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: FilledButton.tonalIcon(
              onPressed: () => showSlotCategoryCreateSheet(context),
              icon: const Icon(Icons.add),
              label: Text(s.createSlotCategoryButton),
            ),
          ),
        ],
      ),
    );
  }
}
