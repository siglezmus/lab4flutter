import 'package:flutter/material.dart';
import 'package:lab4/models/SavedPostsModel.dart';
import 'package:provider/provider.dart';
import 'package:lab4/layouts/MainFeed.dart';
import 'package:lab4/layouts/SavedFeed.dart';
import 'package:lab4/models/PostsModel.dart';
import 'package:lab4/models/ThemeNotifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SharedPreferences.setMockInitialValues({});
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeNotifier(),
        ),
        ChangeNotifierProvider(create: (context) => PostsModel()),
        ChangeNotifierProxyProvider<PostsModel, SavedPostsModel>(
          create: (context) => SavedPostsModel(),
          update: (context, posts, savedPosts) {
            savedPosts.posts = posts;
            return savedPosts;
          },
        ),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier notifier, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Provider Demo',
            theme: notifier.isDarkTheme ? dark : light,
            initialRoute: '/mainFeed',
            routes: {
              '/mainFeed': (context) => MainFeed(),
              '/savedFeed': (context) => SavedFeed(),
            },
          );
        },
      ),
    );
  }
}
