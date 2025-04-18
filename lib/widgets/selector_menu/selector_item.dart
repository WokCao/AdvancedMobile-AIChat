import 'package:flutter/material.dart';

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