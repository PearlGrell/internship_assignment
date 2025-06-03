import 'package:flutter/material.dart';

/// This file defines the app's theme data for light and dark modes.
/// It uses Material 3 design principles and a blue color scheme.
/// /// The [PostListItemSkeleton] widget provides a skeleton loading state
/// /// for a post list item, typically used while data is being fetched.
/// /// It includes a circular avatar, a title, and a subtitle,
/// /// all styled to match the app's theme.
/// /// The skeleton is designed to give users a visual indication
/// /// that content is loading, improving the user experience
/// /// by preventing abrupt layout shifts when the actual content is displayed.
///
class PostListItemSkeleton extends StatelessWidget {
  const PostListItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade800
            : Colors.grey.shade300,
      ),
      title: Container(
        width: 120,
        height: 16,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey.shade800
              : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      subtitle: Container(
        width: 80,
        height: 12,
        margin: const EdgeInsets.only(top: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey.shade800
              : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}