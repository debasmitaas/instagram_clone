import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/config/app_theme.dart';
import 'domain/repositories/post_repository.dart';
import 'presentation/bloc/feed_bloc.dart';
import 'presentation/bloc/feed_event.dart';
import 'presentation/screens/feed_screen.dart';

void main() {
  runApp(const InstaCloneApp());
}

class InstaCloneApp extends StatelessWidget {
  const InstaCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Instagram Clone',
      theme: AppTheme.darkTheme, // Use the dark theme defined in AppTheme)
      home: BlocProvider(
        create: (_) => FeedBloc(PostRepository())..add(LoadInitialFeed()),
        child: const FeedScreen(),
      ),
    );
  }
}