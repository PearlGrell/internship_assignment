import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internship_assignment/models/user/user_model.dart';
import 'package:internship_assignment/blocs/user_blocs/user_events.dart';
import 'package:internship_assignment/blocs/user_blocs/user_state.dart';
import 'package:internship_assignment/services/user_service.dart';


//// UserBloc is responsible for managing the state of user-related operations
/// such as fetching users, loading more users, and searching for users.
/// 
/// It uses the UserService to interact with the backend and fetch user data.
/// The bloc handles different events like FetchUsersEvent, LoadMoreUsersEvent,
/// and SearchUsersEvent, updating the state accordingly.
/// 
/// The bloc maintains pagination state with [limit] and [skip] variables,
/// and a [searchQuery] to handle user searches.
/// 
/// 
/// The bloc emits different states such as UserInitial, UserLoading,
/// UserLoaded, UserError, UserRefreshing, UserSearching, and UserPaginationLoading
/// to reflect the current status of user data fetching and searching.
/// 
/// The bloc also manages a boolean [isFetching] to prevent multiple simultaneous fetches.

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserService userService; // Service to fetch user data
  // Pagination variables
  int limit = 15;
  int skip = 0;
  // Flag to prevent multiple simultaneous fetches
  bool isFetching = false;
  // Search query for user search functionality
  String searchQuery = '';

  // Variables to hold state before search
  List<User> _usersBeforeSearch = [];
  int _skipBeforeSearch = 0;
  bool _hasReachedMaxBeforeSearch = false;

  /// Constructor for UserBloc
  /// Initializes the bloc with a UserService instance and sets the initial state.
  UserBloc({required this.userService}) : super(UserInitial()) {
    on<FetchUsersEvent>(_onFetchUsers);
    on<LoadMoreUsersEvent>(_onLoadMoreUsers);
    on<SearchUsersEvent>(_onSearchUsers);
  }
  /// Handles the FetchUsersEvent to fetch users from the service.
  /// /// If the event is a refresh, it resets the pagination state.
  /// /// It emits UserRefreshing or UserLoading state based on the event type.
  /// /// After fetching, it emits UserLoaded with the fetched users and updates the pagination state.
  /// /// If an error occurs, it emits UserError with the error message.
  Future<void> _onFetchUsers(
    FetchUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    if (isFetching) return;
    isFetching = true;

    try {
      if (event.isRefresh) {
        emit(UserRefreshing());
        skip = 0;
      } else {
        emit(UserLoading());
      }

      final users = await userService.fetchUsers(limit: limit, skip: skip);
      skip += limit;
      
      emit(UserLoaded(users: users, hasReachedMax: users.length < limit));
    } catch (e) {
      emit(UserError("Failed to fetch users: ${e.toString()}"));
    } finally {
     
      isFetching = false;
    }
  }

  /// Handles the LoadMoreUsersEvent to fetch more users from the service.
  /// /// It checks if a fetch is already in progress to prevent multiple simultaneous fetches.
  /// /// It emits UserPaginationLoading state while fetching more users.
  /// /// After fetching, it updates the user list and emits UserPaginationLoading with the updated users.
  /// /// If no more users are available, it emits UserError with a message.
  Future<void> _onLoadMoreUsers(
    LoadMoreUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    if (isFetching || state is! UserLoaded) return;
    isFetching = true;

    final currentState = state as UserLoaded;

    try {
      final users = await userService.fetchUsers(limit: limit, skip: skip);
      skip += limit;
      if (users.isEmpty) {
        emit(UserError("No more users to load."));
        return;
      }

      final updatedUsers = [...currentState.users, ...users];

      emit(
        UserPaginationLoading(
          users: updatedUsers,
          hasReachedMax: users.length < limit,
        ),
      );
    } catch (e) {
      emit(UserError("Failed to load more users: ${e.toString()}"));
    } finally {
     
      isFetching = false;
    }
  }

  /// Handles the SearchUsersEvent to search for users based on the provided query.
  /// /// It checks if a fetch is already in progress to prevent multiple simultaneous fetches.
  /// /// It emits UserLoading state while searching for users.
  /// /// If the search query is empty, it triggers a refresh of the user list.
  /// /// After searching, it emits UserSearching with the searched users and the query.
  /// /// If an error occurs, it emits UserError with the error message.
  Future<void> _onSearchUsers(
    SearchUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    final newSearchQuery = event.query;

    if (newSearchQuery.isEmpty) {
      // User cleared the search query
      searchQuery = ''; // Reset the bloc's internal search query state

      // NEW: If we had a previous paginated list saved, restore it.
      if (_usersBeforeSearch.isNotEmpty) {
        skip = _skipBeforeSearch; // Restore the skip value from before search
        emit(UserLoaded(users: _usersBeforeSearch, hasReachedMax: _hasReachedMaxBeforeSearch));
        // Clear the saved state as it's now restored
        _usersBeforeSearch = [];
        _skipBeforeSearch = 0;
        _hasReachedMaxBeforeSearch = false;
      } else {
        // If no previous state was saved (e.g., search was initiated from initial state),
        // or a full refresh occurred, perform a full refresh to get the initial list.
        add(FetchUsersEvent(isRefresh: true));
      }
      return; // Handled the empty query case
    }

    // A new search query is provided and it's not empty
    if (searchQuery != newSearchQuery) {
      // This is a new search query (or a modification to an existing one).
      if (state is UserLoaded) {
        final currentState = state as UserLoaded;
        _usersBeforeSearch = List.from(currentState.users); // Save a copy of the current users
        _skipBeforeSearch = skip; // Save the current skip value
        _hasReachedMaxBeforeSearch = currentState.hasReachedMax;
      }
      searchQuery = newSearchQuery; // Update the bloc's internal search query
    }

    emit(UserLoading()); // Indicate loading for the search operation

    try {
      final users = await userService.searchUsers(username: searchQuery);
      emit(UserSearching(searchedUsers: users, query: searchQuery));
    } catch (e) {
      emit(UserError("Search failed: ${e.toString()}"));
    }
  }
}
