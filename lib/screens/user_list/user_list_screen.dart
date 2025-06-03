import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internship_assignment/blocs/user_blocs/user_bloc.dart';
import 'package:internship_assignment/blocs/user_blocs/user_events.dart';
import 'package:internship_assignment/blocs/user_blocs/user_state.dart';
import 'package:internship_assignment/services/user_service.dart';
import 'package:internship_assignment/widgets/search_bar.dart';
import 'package:internship_assignment/widgets/skeletons/user_list_item_skeleton.dart';
import 'package:internship_assignment/widgets/list_items/user_list_item.dart';

/// This screen displays a list of users with search functionality.
/// It uses the UserBloc to manage the state of the user list,
/// including fetching, searching, and pagination.
/// /// The screen features a search bar at the top,
/// /// allowing users to filter the list of users by name.
/// /// The user list is displayed in a scrollable view,
/// /// with pagination implemented to load more users as the user scrolls down.
/// /// The screen also includes a refresh indicator to reload the user list.
/// /// The UserListScreen widget is a StatefulWidget that manages the user list state
class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

/// The state class for UserListScreen, which manages the user list and handles user interactions.
/// /// It initializes the UserBloc, listens for scroll events to implement pagination,
/// /// and provides methods for searching and refreshing the user list.
/// /// The state class also builds the UI for the user list,
/// /// including the search bar, user list items, and loading/error states.
/// /// The UserListScreenState class extends State<UserListScreen>
/// /// and is responsible for managing the state of the user list screen.
/// /// It uses a TextEditingController for the search bar,
/// /// a ScrollController for pagination, and a Timer for debouncing search input.
/// /// The state class listens for changes in the search bar input,
/// /// handles scroll events to load more users when the user scrolls near the bottom of the list,
/// /// and builds the UI based on the current state of the UserBloc.
class _UserListScreenState extends State<UserListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final UserBloc _userBloc;
  Timer? _debounce;

  /// Initializes the UserBloc and sets up the scroll listener for pagination.
  /// /// The UserBloc is used to manage the state of the user list,
  /// /// including fetching users, searching, and handling pagination.
  /// /// The scroll listener checks if the user has scrolled near the bottom of the list,
  /// /// and if so, it triggers the loading of more users.
  @override
  void initState() {
    super.initState();
    _userBloc = UserBloc(userService: UserService())..add(FetchUsersEvent());
    _scrollController.addListener(_handleScroll);
  }
  
  /// Disposes of the controllers and closes the UserBloc when the widget is removed from the widget tree.
  /// /// This is important to free up resources and prevent memory leaks.
  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    _userBloc.close();
    super.dispose();
  }

  /// Handles the scroll event to implement pagination.
  /// /// It checks if the user has scrolled near the bottom of the list,
  /// /// and if so, it triggers the loading of more users by dispatching the LoadMoreUsersEvent.
  void _handleScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      final state = _userBloc.state;
      final shouldPaginate = state is UserLoaded && !state.hasReachedMax;
      if (shouldPaginate) _userBloc.add(LoadMoreUsersEvent());
    }
  }

  /// Handles the search input changes.
  /// /// It uses a Timer to debounce the search input,
  /// /// which means it waits for a short period (300 milliseconds) after the user stops typing
  /// /// before triggering the search.
  void _onSearchChanged(String query) {
  if (_debounce?.isActive ?? false) _debounce!.cancel();

  _debounce = Timer(const Duration(milliseconds: 300), () {
    _userBloc.add(SearchUsersEvent(query));
  });
}

  /// Refreshes the user list when the user pulls down to refresh.
  /// /// It dispatches a FetchUsersEvent with isRefresh set to true to the UserBloc,
  /// which triggers a refresh of the user list.
  Future<void> _onRefresh() async {
    _userBloc.add(FetchUsersEvent(isRefresh: true));
  }

  /// Builds the UI for the UserListScreen.
  /// /// It uses a BlocProvider to provide the UserBloc to the widget tree,
  /// /// and a Scaffold to structure the screen with an AppBar and body.
  /// /// The body contains a RefreshIndicator for pull-to-refresh functionality,
  /// /// a Scrollbar for better visibility of the scroll position,
  /// /// and a CustomScrollView to display the user list.
  /// /// The UI includes a SliverAppBar for the header and search bar,
  /// /// and a BlocBuilder to rebuild the user list based on the current state of the UserBloc.
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _userBloc,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: AppBar(),
        ),
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: Scrollbar(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                _buildSliverHeader(),
                BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) => _buildUserList(state),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the header for the user list screen, including the title and search bar.
  /// /// The header is implemented as a SliverAppBar,
  /// /// which allows for a flexible and scrollable header that can expand and collapse.
  /// /// The title is displayed prominently, and the search bar is placed at the bottom of the header.
  /// /// The search bar uses a CustomSearchBar widget that takes a TextEditingController
  /// /// and a callback function to handle search input changes.
  Widget _buildSliverHeader() {
    return SliverAppBar(
      pinned: true,
      title: const Text(
        "Users",
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 28),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: CustomSearchBar(
            controller: _searchController,
            onChanged: _onSearchChanged,
          ),
        ),
      ),
    );
  }

  /// Builds the user list based on the current state of the UserBloc.
  /// /// It checks the state of the UserBloc and builds the appropriate UI:
  /// /// - If the state is UserInitial, UserLoading, or UserRefreshing, it shows a skeleton list.
  /// - If the state is UserLoaded or UserPaginationLoading, it displays the loaded users.
  /// /// - If the state is UserSearching, it shows the searched users.
  /// /// - If the state is UserError, it displays an error message with a retry button.
  /// /// The method returns a SliverList with the appropriate content based on the state.
  Widget _buildUserList(UserState state) {
    if (state is UserInitial ||
        state is UserLoading ||
        state is UserRefreshing) {
      return _buildSkeletonList();
    } else if (state is UserLoaded || state is UserPaginationLoading) {
      final users =
          state is UserLoaded
              ? state.users
              : (state as UserPaginationLoading).users;
      final hasReachedMax =
          state is UserLoaded
              ? state.hasReachedMax
              : (state as UserPaginationLoading).hasReachedMax;
      return _buildLoadedList(users, hasReachedMax);
    } else if (state is UserSearching) {
      return _buildSearchedList(state);
    } else if (state is UserError) {
      return _buildError(state);
    } else {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
  }

  /// Builds a skeleton list to show while the user data is being loaded.
  /// /// The skeleton list consists of multiple UserListItemSkeleton widgets,
  /// /// which are placeholders that mimic the appearance of user list items.
  /// /// This provides a better user experience by indicating that content is loading,
  /// /// preventing abrupt layout shifts when the actual content is displayed.
  /// /// The skeleton list is implemented as a SliverList with a SliverChildBuilderDelegate
  /// /// that generates a fixed number of skeleton items.
  Widget _buildSkeletonList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => const UserListItemSkeleton(),
        childCount: 15,
      ),
    );
  }

  /// Builds the loaded user list when users are successfully fetched.
  /// /// It displays a list of UserListItem widgets for each user,
  /// /// and shows a loading indicator at the end if there are more users to load.
  /// /// The method checks if the list has reached its maximum length,
  /// /// and if not, it adds a loading indicator at the end of the list.
  /// /// The user list is implemented as a SliverList with a SliverChildBuilderDelegate
  /// /// that generates UserListItem widgets for each user.
  /// /// The method takes a list of users and a boolean indicating if the maximum has been reached,
  /// /// and returns a SliverList widget.
  Widget _buildLoadedList(List users, bool hasReachedMax) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        if (index < users.length) {
          return UserListItem(user: users[index]);
        } else {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
      }, childCount: hasReachedMax ? users.length : users.length + 1),
    );
  }

  /// Builds the searched user list when a search query is executed.
  /// /// It displays a list of UserListItem widgets for the searched users.
  /// /// If no users are found, it shows a message indicating that no users were found.
  /// /// The method checks if the searched users list is empty,
  /// /// and if so, it displays a message in the center of the screen.
  /// /// If there are searched users, it generates a SliverList with UserListItem widgets for each user.
  /// /// The method takes a UserSearching state and returns a SliverList widget.
  Widget _buildSearchedList(UserSearching state) {
    if (state.searchedUsers.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("No users found."),
          ),
        ),
      );
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return UserListItem(user: state.searchedUsers[index]);
      },
      childCount: state.searchedUsers.length
      ),
    );
  }

  /// Builds the error message when an error occurs while fetching users.
  /// /// It displays an error icon, a message indicating the error,
  /// /// and a retry button to fetch users again.
  /// /// The error message is extracted from the UserError state,
  /// /// and if the message is empty, a default message is shown.
  /// /// The method returns a SliverToBoxAdapter containing a centered error message
  /// /// with an icon and a retry button.
  Widget _buildError(UserError state) {
    final message = state.message.split(": ").last.trim();
    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 20),
              Text(
                message.isEmpty ? "Something went wrong." : message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed:
                    () => _userBloc.add(FetchUsersEvent(isRefresh: true)),
                icon: const Icon(Icons.refresh),
                label: const Text("Retry"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}