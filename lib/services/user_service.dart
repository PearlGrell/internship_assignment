import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:internship_assignment/models/user/user_model.dart';

/// UserService is responsible for fetching user data from a remote API.
/// /// It uses Dio for making HTTP requests to a dummy JSON API.
/// /// The service handles network errors and provides methods to fetch users and search for users.
/// /// The service is initialized with a Dio instance configured with a base URL and timeout settings.
/// /// The [fetchUsers] method retrieves a list of users with optional pagination parameters.
/// /// The [searchUsers] method allows searching for users by username.
/// /// The service also includes error handling for network issues and unexpected responses.
/// /// The service is designed to be reusable and can be injected into other parts of the application
/// /// where user-related data is needed.
/// /// The service is initialized with a Dio instance configured with a base URL and timeout settings.
/// 
class UserService {
  final Dio _dio;

  /// Creates an instance of UserService with a Dio client configured for the dummy JSON API.
  /// /// The Dio client is set up with a base URL and timeout settings for network requests.
  /// /// The service also adds an interceptor to handle network errors gracefully,
  /// /// ensuring that any DioException related to network issues is caught and handled appropriately.
  UserService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: "https://dummyjson.com/",
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      ) {
  // Adding an interceptor to handle network errors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, handler) {
          if (e.error.toString().contains("SocketException")|| 
              e.error.toString().contains("Failed host lookup")) {
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

  /// Fetches a list of users with optional pagination parameters.
  /// /// The method sends a GET request to the API endpoint for users,
  /// /// allowing for a limit on the number of users returned and an offset for pagination.
  /// /// If the request is successful, it returns a list of User objects.
  /// /// If the request fails, it throws an exception with an error message.
  Future<List<User>> fetchUsers({int limit = 10, int skip = 0}) async {
    try {
      final res = await _dio.get(
        "users",
        queryParameters: {"limit": limit, "skip": skip},
      );

      if (res.statusCode == 200 && res.data['users'] != null) {
        final data = res.data['users'] as List;
        return data.map((user) => User.fromJson(user)).toList();
      } else {
        throw Exception("Unexpected response while fetching users");
      }
    } catch (e, stackTrace) {
      debugPrintStack(label: "🚨 Error fetching users", stackTrace: stackTrace);
      throw Exception(e.toString());
    }
  }

  /// Searches for users by username.
  /// /// The method sends a GET request to the API endpoint for user search,
  /// /// allowing for a query parameter to specify the username to search for.
  /// /// If the request is successful, it returns a list of User objects that match the search criteria.
  /// /// If the request fails, it throws an exception with an error message.
  Future<List<User>> searchUsers({required String username}) async {
    try {
      final res = await _dio.get(
        "users/search",
        queryParameters: {"q": username},
      );

      if (res.statusCode == 200 && res.data['users'] != null) {
        final data = res.data['users'] as List;
        return data.map((user) => User.fromJson(user)).toList();
      } else {
        throw Exception("Unexpected response while searching users");
      }
    } catch (e, stackTrace) {
      debugPrintStack(
        label: "🚨 Error searching users",
        stackTrace: stackTrace,
      );
      throw Exception(e.toString());
    }
  }
}