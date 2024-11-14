import 'package:flutter/widgets.dart';

class ListItemData {
  final String title;
  final String? subtitle;
  final List<ListItemData>? children;
  final Widget? prefix;
  final Widget? suffix;
  final VoidCallback? onTap;

  ListItemData({
    required this.title,
    this.subtitle,
    this.children,
    this.prefix,
    this.suffix,
    this.onTap,
  });
}
