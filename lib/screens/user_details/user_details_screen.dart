import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internship_assignment/blocs/user_details_blocs/user_details_bloc.dart';
import 'package:internship_assignment/blocs/user_details_blocs/user_details_event.dart';
import 'package:internship_assignment/blocs/user_details_blocs/user_details_state.dart';
import 'package:internship_assignment/blocs/create_post_bloc/create_post_cubit.dart';
import 'package:internship_assignment/blocs/theme_cubits.dart/theme_cubit.dart';
import 'package:internship_assignment/models/user/user_model.dart';
import 'package:internship_assignment/services/user_details_service.dart';
import 'package:internship_assignment/widgets/list_items/post_list_item.dart';
import 'package:internship_assignment/widgets/list_items/todo_list_item.dart';
import 'package:internship_assignment/widgets/skeletons/post_list_item_skeleton.dart';
import 'package:internship_assignment/widgets/skeletons/todo_list_item_skeleton.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';


/// The UserDetailsScreen widget displays detailed information about a user,
/// including their contact details, posts, and todos.
/// /// It uses the UserDetailsBloc to manage the state and fetch user data.
/// /// The screen includes a floating action button to create new posts,
/// /// and it allows users to refresh the data by pulling down on the screen.
/// /// The user details are displayed in a scrollable view with sections for contact details,
/// /// posts, and todos.
/// /// The screen is designed to be user-friendly, with a clean layout and responsive design.
/// /// The UserDetailsScreen takes a User object as an argument,
/// /// allowing it to display the specific user's information.
/// 
class UserDetailsScreen extends StatefulWidget {
  final User user;
  const UserDetailsScreen({super.key, required this.user});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

/// The state class for UserDetailsScreen, which initializes the UserDetailsBloc
/// and manages the user details state.
/// /// It listens for state changes in the UserDetailsBloc and rebuilds the UI accordingly.
/// /// The state class also handles the initialization of the bloc,
/// /// fetching user details when the screen is first loaded,
/// /// and providing a refresh mechanism through the RefreshIndicator widget.
/// 
class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late UserDetailsBloc _userDetailsBloc;


  /// The initState method initializes the UserDetailsBloc with the user and services,
  /// and triggers the initial fetch of user details.
  /// /// It sets up the bloc to listen for events related to user details,
  /// /// such as fetching user details and refreshing the data.
  @override
  void initState() {
    _userDetailsBloc = UserDetailsBloc(
      user: widget.user,
      userDetailsService: UserDetailsService(),
      postBox: context.read<CreatePostCubit>().postBox,
    );
    _userDetailsBloc.add(UserDetailsFetchEvent(userId: widget.user.id));
    super.initState();
  }


  /// The build method returns a BlocProvider that provides the UserDetailsBloc
  /// to the widget tree.
  /// /// It uses a BlocBuilder to listen for state changes in the UserDetailsBloc
  /// /// and rebuilds the UI based on the current state.
  /// /// The UI includes an app bar, user information, contact details,
  /// /// posts, and todos sections.
  /// /// It also includes a floating action button for creating new posts,
  /// /// and a refresh indicator to allow users to refresh the data by pulling down on the screen.
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _userDetailsBloc,
      child: Scaffold(
        body: BlocBuilder<UserDetailsBloc, UserDetailsState>(
          builder: (context, state) {
            if (state is UserDetailsErrorState) {
              return _buildErrorState();
            }

            return RefreshIndicator(
              onRefresh: () async {
                _userDetailsBloc.add(
                  UserDetailsRefreshEvent(userId: widget.user.id),
                );
              },
              child: CustomScrollView(
                slivers: [
                  _buildAppBar(context),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _buildUserInfo(),
                        const SizedBox(height: 24),
                        _buildSectionTitle("Contact Details"),
                        const SizedBox(height: 6),
                        ..._buildContactRows(),
                        const SizedBox(height: 24),
                        _buildSectionTitle("Posts"),
                      ]),
                    ),
                  ),
                  if (state is UserDetailsLoadingState)
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, __) => const PostListItemSkeleton(),
                        childCount: 3,
                      ),
                    ),
                  if (state is UserDetailsLoadedState) _buildPostList(state),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _buildSectionTitle("Todos"),
                      ]),
                    ),
                  ),
                  if (state is UserDetailsLoadingState)
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, __) => const TodoListItemSkeleton(),
                        childCount: 3,
                      ),
                    ),
                  if (state is UserDetailsLoadedState) _buildTodoList(state),
                  const SliverToBoxAdapter(child: SizedBox(height: 32)),
                ],
              ),
            );
          },
        ),
        floatingActionButton: BlocBuilder<UserDetailsBloc, UserDetailsState>(
          builder: (context, state) {
            if (state is UserDetailsErrorState) {
              return FloatingActionButton(
                backgroundColor: ColorScheme.of(context).errorContainer,
                onPressed: () {
                  _userDetailsBloc.add(
                    UserDetailsRefreshEvent(userId: widget.user.id),
                  );
                },
                tooltip: "Retry",
                child: Icon(
                  Icons.refresh,
                  color: ColorScheme.of(context).onErrorContainer,
                ),
              );
            }
            return FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.pushNamed(
                  context,
                  '/create-posts',
                  arguments: widget.user,
                );
                if (result == "refresh") {
                  _userDetailsBloc.add(
                    UserDetailsRefreshEvent(userId: widget.user.id),
                  );
                }
              },
              tooltip: "Create Post",
              child: const Icon(LucideIcons.plus),
            );
          },
        ),
      ),
    );
  }

  /// Builds the error state widget to display when an error occurs.
  /// /// It shows an error icon and a message indicating that something went wrong.
  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
            const SizedBox(height: 20),
            const Text(
              "Something went wrong.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the app bar for the user details screen.
  /// /// It includes a title, a theme toggle button,
  /// /// and a floating action button for creating new posts.
  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      pinned: true,
      centerTitle: true,
      title: const Text(
        "User Details",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          icon: Icon(
            context.read<ThemeCubit>().state == ThemeMode.dark
                ? Icons.light_mode
                : Icons.dark_mode,
          ),
          onPressed: () => context.read<ThemeCubit>().toggleTheme(),
        ),
      ],
    );
  }

  /// Builds the user information section, including the user's avatar,
  /// name, and username.
  /// /// It displays the user's profile picture, full name, and username
  /// /// in a row layout.
  Widget _buildUserInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage(widget.user.image),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.user.firstName} ${widget.user.lastName}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                "@${widget.user.username}",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the section title widget for different sections of the user details screen.
  /// /// It displays the title in a bold style with a larger font size.
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  /// Builds the post list widget, displaying a list of posts for the user.
  /// /// If there are no posts, it shows a message indicating that no posts are available.
  SliverList _buildPostList(UserDetailsLoadedState state) {
    if (state.posts.isEmpty) {
      return SliverList(
        delegate: SliverChildListDelegate([
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                "No posts available.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ),
        ]),
      );
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => PostListItem(post: state.posts[index]),
        childCount: state.posts.length,
      ),
    );
  }

  /// Builds the todo list widget, displaying a list of todos for the user.
  /// /// If there are no todos, it shows a message indicating that no todos are available.
  SliverList _buildTodoList(UserDetailsLoadedState state) {
    if (state.todos.isEmpty) {
      return SliverList(
        delegate: SliverChildListDelegate([
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                "No todos available.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ),
        ]),
      );
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final todo = state.todos[index];
        return TodoListItem(todo: todo);
      }, childCount: state.todos.length),
    );
  }

  /// Formats the date string into a more readable format.
  /// It converts the date from "yyyy-MM-dd" format to "MMM dd, yyyy".
  String _formatDate(String date) {
    final splitDate = date.split('-');
    final parsed = DateTime(
      int.parse(splitDate[0]),
      int.parse(splitDate[1]),
      int.parse(splitDate[2]),
    );
    return DateFormat('MMM dd, yyyy').format(parsed);
  }

  List<Widget> _buildContactRows() {
    final contactItems = [
      (LucideIcons.phone, widget.user.phone),
      (LucideIcons.mail, widget.user.email),
      (
        LucideIcons.mapPin,
        "${widget.user.address.city}, ${widget.user.address.country}",
      ),
      (LucideIcons.cake, _formatDate(widget.user.birthDate)),
    ];

    return contactItems.map((item) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Icon(item.$1, size: 18, color: Colors.grey[500]),
            const SizedBox(width: 12),
            Text(item.$2, style: const TextStyle(fontSize: 14)),
          ],
        ),
      );
    }).toList();
  }
}