import 'package:internship_assignment/models/post/post_model.dart';

// CreatePostState defines the different states of the post creation process
abstract class CreatePostState {}

// CreatePostInitialState is the initial state when the post creation process starts
class CreatePostInitialState extends CreatePostState {}

// CreatePostLoadingState is the state when the post creation is in progress
class CreatePostLoadingState extends CreatePostState {}

// CreatePostSuccessState is the state when the post has been successfully created
class CreatePostSuccessState extends CreatePostState {
  final Post post;

  CreatePostSuccessState(this.post);
}

// CreatePostErrorState is the state when there is an error during post creation
class CreatePostErrorState extends CreatePostState {
  final String error;

  CreatePostErrorState(this.error);
}