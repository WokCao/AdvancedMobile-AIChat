import 'package:flutter/material.dart';
import 'package:ai_chat/widgets/selector_menu/selector_item.dart';


class HoverMenuItem<T> extends StatefulWidget {
  final SelectorItem<T> item;
  final bool isSelected;
  final VoidCallback onTap;

  const HoverMenuItem({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<HoverMenuItem<T>> createState() => HoverMenuItemState<T>();
}

class HoverMenuItemState<T> extends State<HoverMenuItem<T>> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color:
            widget.isSelected ? Colors.blue.withValues(alpha: 0.1) : null,
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
                    // Only show subtitle and trailing when hovering
                    AnimatedCrossFade(
                      firstChild: const SizedBox(height: 0),
                      secondChild: _buildSubtitleAndTrailing(),
                      crossFadeState:
                      _isHovering
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