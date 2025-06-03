import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internship_assignment/blocs/create_post_bloc/create_post_cubit.dart';
import 'package:internship_assignment/blocs/create_post_bloc/create_post_state.dart';
import 'package:internship_assignment/models/user/user_model.dart';

/// The CreatePostsScreen widget allows users to create a new post.
/// It provides a form with fields for the post title and body,
/// and uses the CreatePostCubit to handle the post creation logic.
/// /// The screen displays a loading indicator while the post is being created,
/// /// and shows success or error messages based on the outcome of the post creation.
/// /// The user who is creating the post is passed as an argument to the screen,
/// allowing the post to be associated with that user.
/// /// The screen is designed to be user-friendly, with input validation and a responsive layout.
/// 
class CreatePostsScreen extends StatefulWidget {
  final User user;
  const CreatePostsScreen({super.key, required this.user});

  @override
  State<CreatePostsScreen> createState() => _CreatePostsScreenState();
}

/// The state class for CreatePostsScreen, which manages the form state and handles user interactions.
/// /// It includes a form with text fields for the post title and body,
/// /// and uses a GlobalKey to validate the form inputs.
/// /// The state class also listens for changes in the CreatePostCubit,
/// /// displaying appropriate messages based on the success or failure of the post creation.
/// 
class _CreatePostsScreenState extends State<CreatePostsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Post",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<CreatePostCubit, CreatePostState>(
        listener: (context, state) {
          if (state is CreatePostSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Post created successfully!")),
            );
            Navigator.of(context).pop("refresh");
          } else if (state is CreatePostErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: ${state.error.split("Exception: ").last}")),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is CreatePostLoadingState;
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildInputField(_titleController, "Title"),
                      const SizedBox(height: 16),
                      _buildInputField(_bodyController, "Body", maxLines: 5),
                      Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: FilledButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<CreatePostCubit>().createPost(
                                          _titleController.text.trim(),
                                          _bodyController.text.trim(),
                                          widget.user.id,
                                        );
                                  }
                                },
                          child: const Text("Create Post"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isLoading)
                const Opacity(
                  opacity: 0.6,
                  child: ModalBarrier(dismissible: false, color: Colors.black),
                ),
              if (isLoading)
                const Center(child: CircularProgressIndicator()),
            ],
          );
        },
      ),
    );
  }

  /// Builds a reusable input field with validation.
  /// The field is wrapped in a container with padding and border styling.
  /// The validator checks if the input is empty and returns an error message if it is.
  /// /// [controller] is the TextEditingController for the input field,
  /// [hintText] is the placeholder text for the field,
  /// and [maxLines] specifies the maximum number of lines for the input.
  /// 
  Widget _buildInputField(
    TextEditingController controller,
    String hintText, {
    int maxLines = 1,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration.collapsed(hintText: hintText),
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Please enter ${hintText.toLowerCase()}";
          }
          return null;
        },
      ),
    );
  }
}