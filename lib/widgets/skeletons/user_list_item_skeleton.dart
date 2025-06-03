import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// This widget provides a skeleton loading state for a user list item,
/// typically used while user data is being fetched.
/// /// The `UserListItemSkeleton` widget displays a placeholder for a user profile,
/// /// including a circular avatar, a title, and a subtitle.
/// /// It uses the `Shimmer` package to create a shimmering effect,
/// /// giving users a visual indication that content is loading.
/// 
class UserListItemSkeleton extends StatelessWidget {
  const UserListItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;
    final highlightColor = isDark ? Colors.grey.shade700 : Colors.grey.shade100;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: baseColor,
          radius: 28,
        ),
        title: Container(
          width: 120,
          height: 16,
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        subtitle: Container(
          width: 80,
          height: 12,
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
