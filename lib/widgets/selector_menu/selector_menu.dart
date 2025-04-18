import 'package:ai_chat/widgets/selector_menu/hover_menu_item.dart';
import 'package:ai_chat/widgets/selector_menu/selector_item.dart';
import 'package:flutter/material.dart';

class SelectorMenu<T> extends StatelessWidget {
  final Set<SelectorItem<T>> items;
  final T? selectedValue;
  final Function(T) onItemSelected;
  final String? title;
  final double width;
  final double? maxHeight;
  final ScrollController? scrollController;
  final Widget? bottomWidget;

  const SelectorMenu({
    super.key,
    required this.items,
    this.selectedValue,
    required this.onItemSelected,
    this.title,
    this.width = 300,
    this.maxHeight,
    this.scrollController,
    this.bottomWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(8),
      color: Colors.white,
      child: Container(
        width: width,
        constraints: BoxConstraints(maxHeight: maxHeight ?? 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header (optional)
            if (title != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  title!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            // Item List
            Flexible(
              child: ListView.builder(
                controller: scrollController,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: items.length + (bottomWidget != null ? 1 : 0),
                itemBuilder: (context, index) {
                  final itemList = items.toList();
                  if (index < items.length) {
                    final item = itemList[index];
                    final isSelected = item.value == selectedValue;

                    return HoverMenuItem<T>(
                      item: item,
                      isSelected: isSelected,
                      onTap: () {
                        onItemSelected(item.value as T);
                        Navigator.pop(context);
                      },
                    );
                  } else {
                    // Render bottom widget (e.g., loading indicator)
                    return bottomWidget!;
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}