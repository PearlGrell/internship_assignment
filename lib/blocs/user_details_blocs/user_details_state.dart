import 'package:internship_assignment/models/post/post_model.dart';
import 'package:internship_assignment/models/todo/todo_model.dart';

/// Base class for user details state
abstract class UserDetailsState {}

/// Initial state of the user details, typically when the screen is first opened.
class UserDetailsInitialState extends UserDetailsState {}

/// State representing that user details are currently being loaded.
class UserDetailsLoadingState extends UserDetailsState {}

/// State representing that user details have been successfully loaded.
class UserDetailsLoadedState extends UserDetailsState {
  List<Post> posts; // List of posts related to the user
  List<Todo> todos; // List of todos related to the user

  UserDetailsLoadedState({
    required this.posts,
    required this.todos,
  });
}

/// State representing an error occurred while fetching user details.
class UserDetailsErrorState extends UserDetailsState {
  String error;
  UserDetailsErrorState({required this.error});
}