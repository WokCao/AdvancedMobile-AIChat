import 'package:flutter/material.dart';

// A generic item for the selector menu
class SelectorItem<T> {
  final String title;
  final Widget? leading;
  final String? subtitle;
  final String? trailing;
  final T? value;
  final String? id;

  const SelectorItem({
    required this.title,
    this.leading,
    this.subtitle,
    this.trailing,
    this.value,
    this.id
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SelectorItem<T> &&
              runtimeType == other.runtimeType &&
              title == other.title &&
              id == other.id;

  @override
  int get hashCode => title.hashCode ^ id.hashCode;
}

// A menu item that shows subtitle and trailing on hover
class _HoverMenuItem<T> extends StatefulWidget {
  final SelectorItem<T> item;
  final bool isSelected;
  final VoidCallback onTap;

  const _HoverMenuItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_HoverMenuItem<T>> createState() => _HoverMenuItemState<T>();
}

class _HoverMenuItemState<T> extends State<_HoverMenuItem<T>> {
  bool _isHovering = false;
  bool _isHolding = false;

  bool get _shouldShowSubtitle => _isHovering || _isHolding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) => setState(() => _isHolding = true),
      onLongPressEnd: (_) => setState(() => _isHolding = false),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: InkWell(
          onTap: widget.onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: widget.isSelected ? Colors.blue.withValues(alpha: 0.1) : null,
            ),
            child: Row(
              children: [
                if (widget.item.leading != null) ...[
                  widget.item.leading!,
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // Only show subtitle and trailing when hovering/holding
                      AnimatedCrossFade(
                        firstChild: const SizedBox(height: 0),
                        secondChild: _buildSubtitleAndTrailing(),
                        crossFadeState: _shouldShowSubtitle
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 200),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubtitleAndTrailing() {
    if (widget.item.subtitle == null && widget.item.trailing == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 12, height: 1.3, color: Colors.grey[600]),
          children: [
            if (widget.item.subtitle != null)
              TextSpan(text: widget.item.subtitle!),
            if (widget.item.subtitle != null && widget.item.trailing != null)
              const TextSpan(text: '\n'),
            if (widget.item.trailing != null)
              TextSpan(
                text: widget.item.trailing!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}

// A generic selector menu that can be used with any type of items
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

                    return _HoverMenuItem<T>(
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

// A helper class to show the selector menu as a popup
// class SelectorMenuHelper {
//   // Shows the selector menu as a popup
//   static Future<T?> showMenu<T>({
//     required BuildContext context,
//     required List<SelectorItem<T>> items,
//     required T? selectedValue,
//     required Function(T) onItemSelected,
//     Future<List<SelectorItem<T>>> Function()? onLoadMore,
//     String? title,
//     double width = 300,
//     double? maxHeight,
//     Offset? offset,
//     bool useRootNavigator = true,
//     ScrollController? scrollController,
//   }) async {
//     Set<SelectorItem<T>> internalItems = Set.from(items);
//     bool isLoadingMore = false;
//
//     final Widget menuWidget = StatefulBuilder(
//       builder: (context, setState) {
//         scrollController?.addListener(() async {
//           if (scrollController.position.pixels >=
//               scrollController.position.maxScrollExtent) {
//             setState(() => isLoadingMore = true);
//             if (onLoadMore != null) {
//               final newItems = await onLoadMore();
//               setState(() {
//                 internalItems.addAll(newItems);
//                 isLoadingMore = false;
//               });
//             } else {
//               setState(() => isLoadingMore = false);
//             }
//           }
//         });
//
//         return SelectorMenu<T>(
//           items: internalItems,
//           selectedValue: selectedValue,
//           onItemSelected: onItemSelected,
//           title: title,
//           width: width,
//           maxHeight: maxHeight,
//           scrollController: scrollController,
//           bottomWidget:
//               isLoadingMore
//                   ? Padding(
//                     padding: const EdgeInsets.all(8),
//                     child: Center(child: CircularProgressIndicator(color: Colors.purple.shade200,)),
//                   )
//                   : null,
//         );
//       },
//     );
//
//     // If offset is not provided, show in the center of the screen
//     if (offset == null) {
//       return showDialog<T>(
//         context: context,
//         useRootNavigator: useRootNavigator,
//         builder: (BuildContext context) {
//           return Dialog(
//             insetPadding: EdgeInsets.zero,
//             backgroundColor: Colors.transparent,
//             elevation: 0,
//             child: menuWidget,
//           );
//         },
//       );
//     }
//
//     // If offset is provided, show at that position
//     return showDialog<T>(
//       context: context,
//       useRootNavigator: useRootNavigator,
//       barrierColor: Colors.transparent,
//       builder: (BuildContext context) {
//         return Stack(
//           children: [
//             GestureDetector(
//               onTap: () => Navigator.of(context).pop(),
//               child: Container(
//                 color: Colors.transparent,
//                 width: double.infinity,
//                 height: double.infinity,
//               ),
//             ),
//             Positioned(left: offset.dx, top: offset.dy, child: menuWidget),
//           ],
//         );
//       },
//     );
//   }
// }
