import 'package:flutter/material.dart';

/// A generic item for the selector menu
class SelectorItem<T> {
  final String title;
  final Widget? leading;
  final String? subtitle;
  final String? trailing;
  final T value;

  const SelectorItem({
    required this.title,
    this.leading,
    this.subtitle,
    this.trailing,
    required this.value,
  });
}

/// A generic selector menu that can be used with any type of items
class SelectorMenu<T> extends StatelessWidget {
  final List<SelectorItem<T>> items;
  final T selectedValue;
  final Function(T) onItemSelected;
  final String? title;
  final double width;
  final double? maxHeight;

  const SelectorMenu({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onItemSelected,
    this.title,
    this.width = 300,
    this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(8),
      color: Colors.white,
      child: Container(
        width: width,
        constraints: BoxConstraints(
          maxHeight: maxHeight ?? 400,
        ),
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
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isSelected = item.value == selectedValue;

                  return InkWell(
                    onTap: () {
                      onItemSelected(item.value);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue.withOpacity(0.1) : null,
                      ),
                      child: Row(
                        children: [
                          if (item.leading != null) ...[
                            item.leading!,
                            const SizedBox(width: 12),
                          ],
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (item.subtitle != null)
                                  Text(
                                    item.subtitle!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (item.trailing != null)
                            Text(
                              item.trailing!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A helper class to show the selector menu as a popup
class SelectorMenuHelper {
  /// Shows the selector menu as a popup
  static Future<T?> showMenu<T>({
    required BuildContext context,
    required List<SelectorItem<T>> items,
    required T selectedValue,
    required Function(T) onItemSelected,
    String? title,
    double width = 300,
    double? maxHeight,
    Offset? offset,
    bool useRootNavigator = true,
  }) async {
    // If offset is not provided, show in the center of the screen
    if (offset == null) {
      return showDialog<T>(
        context: context,
        useRootNavigator: useRootNavigator,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: SelectorMenu<T>(
              items: items,
              selectedValue: selectedValue,
              onItemSelected: onItemSelected,
              title: title,
              width: width,
              maxHeight: maxHeight,
            ),
          );
        },
      );
    }

    // If offset is provided, show at that position
    return showDialog<T>(
      context: context,
      useRootNavigator: useRootNavigator,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                color: Colors.transparent,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Positioned(
              left: offset.dx,
              top: offset.dy,
              child: SelectorMenu<T>(
                items: items,
                selectedValue: selectedValue,
                onItemSelected: onItemSelected,
                title: title,
                width: width,
                maxHeight: maxHeight,
              ),
            ),
          ],
        );
      },
    );
  }
}