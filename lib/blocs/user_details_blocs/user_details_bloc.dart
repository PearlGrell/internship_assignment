import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';
import 'package:internship_assignment/blocs/user_details_blocs/user_details_event.dart';
import 'package:internship_assignment/blocs/user_details_blocs/user_details_state.dart';
import 'package:internship_assignment/models/post/post_model.dart';
import 'package:internship_assignment/models/todo/todo_model.dart';
import 'package:internship_assignment/models/user/user_model.dart';
import 'package:internship_assignment/services/user_details_service.dart';

/// UserDetailsBloc is responsible for managing the state of user details,
/// including fetching user posts and todos.
/// /// It uses the UserDetailsService to interact with the backend and fetch user data.
/// /// The bloc handles events like UserDetailsFetchEvent and UserDetailsRefreshEvent,
/// /// updating the state accordingly.
/// /// The bloc maintains a boolean [isFetching] to prevent multiple simultaneous fetches.
/// /// The bloc emits different states such as UserDetailsInitialState, UserDetailsLoadingState,
/// /// UserDetailsLoadedState, and UserDetailsErrorState to reflect the current status of user details fetching.
/// /// The bloc also uses a Hive box to cache posts related to the user,
/// /// allowing it to combine fetched posts with cached posts for better performance.
///
//// The bloc is initialized with a [user], [userDetailsService], and a [postBox] to store posts.
////// The [user] is the user for whom details are being fetched.
///// The [userDetailsService] is the service used to fetch user posts and todos.
////// The [postBox] is a Hive box that stores posts related to the user,
////// allowing the bloc to combine fetched posts with cached posts for better performance.
///
class UserDetailsBloc extends Bloc<UserDetailsEvent, UserDetailsState> { 
  final UserDetailsService userDetailsService; 
  final User user;
  final Box postBox;
  bool isFetching = false;

  /// Constructor for UserDetailsBloc
  /// Initializes the bloc with a UserDetailsService instance, a User object,
  /// and a Hive box for posts.
  /// /// The bloc sets the initial state to UserDetailsInitialState.
  /// /// It listens for UserDetailsFetchEvent and UserDetailsRefreshEvent,
  /// /// calling the refresh method to fetch user details when these events are triggered.
  /// 
  UserDetailsBloc({ 
    required this.user,
    required this.userDetailsService,
    required this.postBox,
  }) : super(UserDetailsInitialState()) {
    on<UserDetailsFetchEvent>((event, emit) async {
      await refresh(emit);
    });

    on<UserDetailsRefreshEvent>((event, emit) async {
      await refresh(emit);
    });
  }

  /// Refreshes the user details by fetching posts and todos for the user.
  /// /// It emits UserDetailsLoadingState while fetching data,
  /// /// and UserDetailsLoadedState with the fetched posts and todos upon success.
  /// /// If an error occurs, it emits UserDetailsErrorState with the error message.
  /// The method combines fetched posts with cached posts from the Hive box,
  /// ensuring that the latest posts are displayed without duplicates.
  Future<void> refresh(Emitter<UserDetailsState> emit) async {
    if (isFetching) return;
    isFetching = true; 

    emit(UserDetailsLoadingState()); 

    try {
      final List<Post> posts = await userDetailsService.fetchUserPosts(userId: user.id); 
      final List<Todo> todos = await userDetailsService.fetchUserTodos(userId: user.id);

      List<Post> combinedPosts = List.from(posts);

      if (postBox.isNotEmpty) {
        final cachedPosts = postBox.values
            .where((post) => post is Post && post.userId == user.id)
            .cast<Post>()
            .toList();

        final cachedPostsToAdd = cachedPosts.where(
          (cachedPost) => !combinedPosts.any((post) => post.id == cachedPost.id), 
        );

        combinedPosts.addAll(cachedPostsToAdd);
      }

      emit(UserDetailsLoadedState(posts: combinedPosts, todos: todos));
    } catch (e) {
      emit(UserDetailsErrorState(error: e.toString()));
    } finally {
      isFetching = false;
    }
  }
}