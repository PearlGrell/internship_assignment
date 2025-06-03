import 'package:hive_ce/hive.dart';
import 'package:internship_assignment/blocs/create_post_bloc/create_post_state.dart';
import 'package:internship_assignment/models/post/post_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internship_assignment/services/user_details_service.dart';

/// CreatePostCubit is responsible for managing the state of post creation.
/// It uses the UserDetailsService to create a new post and stores it in a Hive box.
/// /// The cubit handles the creation of a post by emitting different states:
/// /// - CreatePostInitialState: The initial state when the cubit is created.
/// /// - CreatePostLoadingState: The state when the post creation is in progress.
/// /// - CreatePostSuccessState: The state when the post has been successfully created.
/// /// - CreatePostErrorState: The state when there is an error during post creation.
/// /// The cubit takes a Hive box as a dependency to store the created post.
/// /// The [createPost] method is used to create a new post with the provided title, body, and user ID.
/// /// It generates a unique ID for the post based on the current timestamp.
/// /// The cubit emits the appropriate state based on the success or failure of the post creation process.

class CreatePostCubit extends Cubit<CreatePostState> {
  final Box postBox;

  CreatePostCubit(this.postBox) : super(CreatePostInitialState());

  void createPost(String title, String body, int id) async {
    emit(CreatePostLoadingState());
    try {
      final post = Post(
        title: title,
        body: body,
        userId: id,
        id: DateTime.now().millisecondsSinceEpoch,
      );

      await UserDetailsService().createPost(post);
      await postBox.put(post.id.toString(), post);

      emit(CreatePostSuccessState(post));
    } catch (e) {
      emit(CreatePostErrorState(e.toString()));
    }
  }
}