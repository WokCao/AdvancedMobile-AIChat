import 'package:ai_chat/widgets/selector_menu/selector_menu.dart';
import 'package:ai_chat/widgets/selector_menu/selector_menu_popup.dart';
import 'package:flutter/material.dart';
import 'package:ai_chat/widgets/selector_menu/selector_item.dart';

class SelectorMenuHelper {
  // Shows the selector menu as a popup
  static Future<T?> showMenu<T>({
    required BuildContext context,
    required List<SelectorItem<T>> items,
    required T? selectedValue,
    required Function(T) onItemSelected,
    Future<List<SelectorItem<T>>> Function()? onLoadMore,
    String? title,
    double width = 300,
    double? maxHeight,
    Offset? offset,
    bool useRootNavigator = true,
    ScrollController? scrollController,
  }) async {
    Set<SelectorItem<T>> internalItems = Set.from(items);
    bool isLoadingMore = false;

    final Widget menuWidget = SelectorMenuPopup<T>(
      items: internalItems,
      selectedValue: selectedValue,
      onItemSelected: onItemSelected,
      onLoadMore: onLoadMore,
      title: title,
      width: width,
      maxHeight: maxHeight,
      scrollController: scrollController,
    );

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
            child: menuWidget,
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
            Positioned(left: offset.dx, top: offset.dy, child: menuWidget),
          ],
        );
      },
    );
  }
}
