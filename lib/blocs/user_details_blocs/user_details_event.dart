abstract class UserDetailsEvent {}

// Event to fetch user details, typically triggered when the user details screen is opened.
class UserDetailsFetchEvent extends UserDetailsEvent { 
  final int userId;
  UserDetailsFetchEvent({required this.userId});
}

// Event to refresh user details, typically triggered when the user pulls to refresh the screen.
class UserDetailsRefreshEvent extends UserDetailsEvent {
  final int userId;
  UserDetailsRefreshEvent({required this.userId});
}