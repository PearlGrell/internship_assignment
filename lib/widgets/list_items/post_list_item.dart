import 'package:flutter/material.dart';
import 'package:internship_assignment/models/post/post_model.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// This widget displays a list item for a post, showing its title and body.
/// When tapped, it opens a dialog displaying the full post details.
/// /// The [PostListItem] widget is a stateless widget that takes a [Post] object as a parameter.
/// /// It uses a [ListTile] to display the post's title and body in a compact format.
/// /// The title is displayed in bold and truncated to one line if it exceeds the available space.
/// /// The body is also truncated to one line.
/// /// When the list item is tapped, it shows an [AlertDialog] with the full post details,
/// /// including the title and body.
/// /// The widget uses a [CircleAvatar] with an icon to represent the post visually.
/// /// This widget is useful for displaying a list of posts in a user interface,
/// /// allowing users to quickly view and interact with individual posts.
/// 
class PostListItem extends StatelessWidget {
  final Post post;
  const PostListItem({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: const Icon(LucideIcons.fileText)),
      title: Text(
        post.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(post.body, maxLines: 1, overflow: TextOverflow.ellipsis),
      onTap: (){
        showDialog(context: context, builder: (context) {
          return AlertDialog(
            title: Text(post.title),
            content: Text(post.body),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Close"),
              ),
            ],
          );
        });
      },
    );
  }
}
