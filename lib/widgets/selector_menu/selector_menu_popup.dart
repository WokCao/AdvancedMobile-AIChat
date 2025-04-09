import 'package:ai_chat/widgets/selector_menu/selector_item.dart';
import 'package:ai_chat/widgets/selector_menu/selector_menu.dart';
import 'package:flutter/material.dart';

class SelectorMenuPopup<T> extends StatefulWidget {
  final Set<SelectorItem<T>> items;
  final T? selectedValue;
  final Function(T) onItemSelected;
  final Future<List<SelectorItem<T>>> Function()? onLoadMore;
  final String? title;
  final double width;
  final double? maxHeight;
  final ScrollController? scrollController;

  const SelectorMenuPopup({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onItemSelected,
    this.onLoadMore,
    this.title,
    this.width = 300,
    this.maxHeight,
    this.scrollController,
  });

  @override
  State<SelectorMenuPopup<T>> createState() => _SelectorMenuPopupState<T>();
}

class _SelectorMenuPopupState<T> extends State<SelectorMenuPopup<T>> {
  late Set<SelectorItem<T>> internalItems;
  late ScrollController controller;
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    internalItems = Set.from(widget.items);
    controller = widget.scrollController ?? ScrollController();
    controller.addListener(_onScroll);
  }

  void _onScroll() async {
    if (controller.position.pixels >= controller.position.maxScrollExtent &&
        !isLoadingMore &&
        widget.onLoadMore != null) {
      setState(() => isLoadingMore = true);
      final newItems = await widget.onLoadMore!();
      setState(() {
        internalItems.addAll(newItems);
        isLoadingMore = false;
      });
    }
  }

  @override
  void dispose() {
    controller.removeListener(_onScroll);
    if (widget.scrollController == null) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SelectorMenu<T>(
      items: internalItems,
      selectedValue: widget.selectedValue,
      onItemSelected: widget.onItemSelected,
      title: widget.title,
      width: widget.width,
      maxHeight: widget.maxHeight,
      scrollController: controller,
      bottomWidget:
          isLoadingMore
              ? Padding(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.purple.shade200,
                  ),
                ),
              )
              : null,
    );
  }
}
