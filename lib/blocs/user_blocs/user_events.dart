
// This file defines the events for the UserBloc in a Flutter application.

abstract class UserEvent {}

/// Event to fetch users, can be triggered with a refresh option.
class FetchUsersEvent extends UserEvent {
  final bool isRefresh; // Indicates if the fetch is a refresh operation

  FetchUsersEvent({this.isRefresh = false}); // Constructor with optional refresh flag
}

class LoadMoreUsersEvent extends UserEvent {} // Event to load more users, typically used for pagination

class SearchUsersEvent extends UserEvent {
  final String query; // The search query to filter users

  SearchUsersEvent(this.query); // Constructor to initialize the search query
}