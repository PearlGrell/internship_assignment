import 'package:flutter/material.dart';
import 'package:internship_assignment/models/todo/todo_model.dart';

/// This widget displays a list item for a todo, showing its title and completion status.
/// When tapped, it opens a dialog displaying the full todo details.
/// The [TodoListItem] widget is a stateless widget that takes a [Todo] object as a parameter. 
/// It uses a [ListTile] to display the todo's title and completion status in a compact format.
/// The title is displayed with an icon indicating whether the todo is completed or not.
/// When the list item is tapped, it shows an [AlertDialog] with the full todo details,
/// including the title and completion status.
/// /// This widget is useful for displaying a list of todos in a user interface,
/// allowing users to quickly view and interact with individual todos.
/// /// The widget uses an [Icon] to represent the todo's completion status visually,
/// with a check circle for completed todos and a radio button for incomplete todos.
class TodoListItem extends StatelessWidget {
  final Todo todo;
  const TodoListItem({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return ListTile(
          leading: Icon(
            todo.completed ? Icons.check_circle : Icons.radio_button_unchecked,
            color: todo.completed ? Colors.green : Colors.grey,
          ),
          title: Text(todo.todo),
        );
  }
}