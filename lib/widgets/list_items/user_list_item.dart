import 'package:flutter/material.dart';
import 'package:internship_assignment/models/user/user_model.dart';

/// This widget displays a list item for a user, showing their name and email.
/// When tapped, it navigates to a user details page with the user's information.
/// /// The [UserListItem] widget is a stateless widget that takes a [User] object as a parameter.
/// /// It uses a [ListTile] to display the user's name and email in a compact format.
/// /// The user's name is displayed in bold, and their email is shown below it.
/// /// The widget uses a [CircleAvatar] to display the user's profile image.
/// /// When the list item is tapped, it navigates to a user details page using the [Navigator.pushNamed] method,
/// /// passing the [User] object as an argument.
/// /// This widget is useful for displaying a list of users in a user interface,
/// /// allowing users to quickly view and interact with individual user profiles.
/// /// The [UserListItem] widget is designed to be reusable and can be used in various parts of the application
/// /// where user-related data is needed.
/// /// The widget is designed to be lightweight and efficient, making it suitable for displaying a large number of users in a list.
class UserListItem extends StatelessWidget {
  final User user;
  const UserListItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.image),
        backgroundColor: Colors.grey.shade300,
        radius: 28,
      ),
      title: Text(
        '${user.firstName} ${user.lastName}',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(user.email),
      onTap: () {
        Navigator.pushNamed(
          context,
          '/user-details',
          arguments: user,
        );
      },
    );
  }
}
