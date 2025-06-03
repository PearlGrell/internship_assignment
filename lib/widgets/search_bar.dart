import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// This widget provides a custom search bar with a text field and an icon.
/// It allows users to input search queries and triggers a callback function
/// when the text changes.
/// /// The [CustomSearchBar] widget is a stateless widget that takes a callback function
/// /// [onChanged] and a [TextEditingController] [controller] as parameters.
/// /// The [onChanged] function is called whenever the text in the search bar changes,
/// /// allowing the parent widget to respond to search queries.
/// /// The [controller] is used to manage the text input in the search bar.
/// /// The search bar is styled with a rounded container, an icon, and a text field.
/// /// The icon is displayed on the left side of the search bar, and the text field
/// /// is expanded to fill the remaining space.
/// /// This widget is useful for implementing search functionality in an application,
/// allowing users to enter search terms and triggering actions based on their input.
/// /// The search bar is designed to be visually appealing and user-friendly,
/// /// with a consistent design that fits well within the app's theme.
/// 
class CustomSearchBar extends StatelessWidget {
  final Function(String) onChanged;
  final TextEditingController controller;
  const CustomSearchBar({
    super.key,
    required this.onChanged,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withAlpha(150),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 16),
          Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: Icon(
              LucideIcons.search,
              color: Theme.of(
                context,
              ).colorScheme.onPrimaryContainer.withAlpha(150),
              size: 18,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              cursorHeight: 20,
              cursorRadius: const Radius.circular(12),
              decoration: InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
                isCollapsed: true,
                hintStyle: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onPrimaryContainer.withAlpha(150),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
