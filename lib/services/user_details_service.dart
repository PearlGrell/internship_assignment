import 'package:internship_assignment/models/post/post_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:internship_assignment/models/todo/todo_model.dart';


/// UserDetailsService is responsible for fetching user-related data such as posts and todos.
/// It uses Dio for making HTTP requests to a dummy JSON API.
/// /// The service handles network errors and provides methods to fetch user posts and todos,
/// /// as well as to create a new post.
/// /// The service is initialized with a Dio instance configured with a base URL and timeout settings.
/// /// The [fetchUserPosts] method retrieves posts for a specific user by their ID.
/// /// The [fetchUserTodos] method retrieves todos for a specific user by their ID.
/// /// The [createPost] method allows creating a new post by sending a POST request with the post data.
/// /// The service also includes error handling for network issues and unexpected responses.
/// /// The service is designed to be reusable and can be injected into other parts of the application
/// /// where user-related data is needed.
class UserDetailsService {
  final Dio _dio; 

  /// Creates an instance of UserDetailsService with a Dio client configured for the dummy JSON API.
  /// /// The Dio client is set up with a base URL and timeout settings for network requests.
  /// /// The service also adds an interceptor to handle network errors gracefully,
  /// /// ensuring that any DioException related to network issues is caught and handled appropriately.
  UserDetailsService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: "https://dummyjson.com/",
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ),
        ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, handler) {
          if (e.error.toString().contains("Failed")) {
            handler.reject(
              DioException(
                requestOptions: e.requestOptions,
                message:
                    "Network error. Please check your internet connection.",
                type: DioExceptionType.connectionError,
              ),
            );
          } else {
            handler.next(e);
          }
        },
      ),
    );
  }

  /// Fetches posts for a specific user by their ID.
  /// The method sends a GET request to the API endpoint for user posts.
  /// /// If the request is successful, it returns a list of Post objects.
  /// /// If the request fails, it throws an exception with an error message.
  Future<List<Post>> fetchUserPosts({required int userId}) { 
    final response = _dio.get("users/$userId/posts");

    return response
        .then((res) { 
          if (res.statusCode == 200) { 
            final data = res.data['posts'] as List; 
            return data.map((post) => Post.fromJson(post)).toList();
          } else {
            throw Exception("Failed to load posts");
          }
        })
        .catchError((err, stackTrace) {
          debugPrintStack(
            label: "Error fetching user posts: $err",
            stackTrace: stackTrace,
          );
          throw Exception("Failed to fetch user posts");
        });
  }

  /// Fetches todos for a specific user by their ID.
  /// The method sends a GET request to the API endpoint for user todos.
  /// /// If the request is successful, it returns a list of Todo objects.
  /// If the request fails, it throws an exception with an error message.
  Future<List<Todo>> fetchUserTodos({required int userId}) {
    final response = _dio.get("users/$userId/todos");

    return response
        .then((res) {
          if (res.statusCode == 200) {
            final data = res.data['todos'] as List;
            return data.map((todo) => Todo.fromJson(todo)).toList();
          } else {
            throw Exception("Failed to load todos");
          }
        })
        .catchError((err, stackTrace) {
          debugPrintStack(
            label: "Error fetching user todos: $err",
            stackTrace: stackTrace,
          );
          throw Exception("Failed to fetch user todos");
        });
  }

  /// Creates a new post by sending a POST request with the post data.
  /// /// The method takes a Post object, converts it to JSON, and sends it to the API.
  /// /// If the request is successful, it returns a Future that completes without any value.
  /// /// If the request fails, it throws an exception with an error message.
  Future<void> createPost(Post post) {
    return _dio
        .post("posts/add", data: post.toJson())
        .then((res) {
          if (res.statusCode != 201) {
            throw Exception("Failed to create post");
          }
        })
        .catchError((err) {
          debugPrintStack(label: "Error creating post: $err");
          throw Exception("Failed to create post");
        });
  }
}