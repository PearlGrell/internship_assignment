import 'package:internship_assignment/models/user/user_model.dart';

// Bloc imports
// UserState defines the different states of the user-related operations
abstract class UserState {} // This is the base class for all user states

class UserInitial extends UserState {} // Initial state when the UserBloc is created

class UserLoading extends UserState {} // State when users are being loaded

class UserRefreshing extends UserState {} // State when users are being refreshed

class UserLoaded extends UserState { // State when users are successfully loaded
  final List<User> users; // List of loaded users
  final bool hasReachedMax; // Flag to indicate if the maximum number of users has been reached

  UserLoaded({ // Constructor for UserLoaded state
    required this.users, 
    required this.hasReachedMax,
  });
}

class UserPaginationLoading extends UserLoaded { // State for pagination loading, extends UserLoaded
  UserPaginationLoading({ // Constructor for UserPaginationLoading state
    required super.users, // List of users
    required super.hasReachedMax, // Flag to indicate if the maximum number of users has been reached
  });
}

class UserSearching extends UserState { // State when users are being searched
  final List<User> searchedUsers; // List of users that match the search query
  final String query; // The search query used to filter users

  UserSearching({ // Constructor for UserSearching state
    required this.searchedUsers,
    required this.query,
  });
}

class UserError extends UserState { // State when there is an error fetching users
  final String message; // Error message describing the issue
  UserError(this.message); // Constructor for UserError state
}
