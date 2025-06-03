import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:internship_assignment/blocs/create_post_bloc/create_post_cubit.dart';
import 'package:internship_assignment/blocs/theme_cubits.dart/theme_cubit.dart';
import 'package:internship_assignment/models/post/post_model.dart';
import 'package:internship_assignment/themes/app_theme.dart';
import 'package:internship_assignment/screens/user_list/user_list_screen.dart';
import 'package:internship_assignment/screens/user_details/user_details_screen.dart';
import 'package:internship_assignment/screens/create_post/create_posts_screen.dart';
import 'package:internship_assignment/models/user/user_model.dart';

/// The main entry point of the Flutter application.
/// It initializes Hive for local storage,
/// opens necessary boxes,
/// registers adapters for models,
/// and runs the main app widget.
/// 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('settings');
  Hive.registerAdapter(PostAdapter());
  await Hive.openBox('posts');
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  /// The build method of the MainApp widget.
  /// It uses MultiBlocProvider to provide ThemeCubit and CreatePostCubit to the widget tree.
  /// /// The MaterialApp is configured with light and dark themes,
  /// /// and it defines routes for the user list, user details, and create posts screens.
  /// /// The initial route is set to the user list screen,
  /// /// and the user details and create posts screens are set up to receive a User object as an argument.
  /// 
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(Hive.box('settings')),
        ),
        BlocProvider<CreatePostCubit>(
          create: (context) => CreatePostCubit(Hive.box('posts')),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            initialRoute: '/',
            routes: {
              '/': (context) => const UserListScreen(),
              '/user-details': (context) {
                final user = ModalRoute.of(context)!.settings.arguments as User;
                return UserDetailsScreen(user: user);
              },
              '/create-posts': (context) {
                final user = ModalRoute.of(context)!.settings.arguments as User;
                return CreatePostsScreen(user: user);
              },
            },
          );
        },
      ),
    );
  }
}
