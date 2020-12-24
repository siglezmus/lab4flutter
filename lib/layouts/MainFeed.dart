import 'package:flutter/material.dart';
import 'package:lab4/models/ThemeNotifier.dart';
import 'package:provider/provider.dart';
import 'package:lab4/models/PostsModel.dart';
import 'package:lab4/models/SavedPostsModel.dart';

class MainFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.cyan,
        title: Text('MainFeed'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => Navigator.pushNamed(context, '/savedFeed'),
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: _MyListItem(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          child: Consumer<ThemeNotifier>(
              builder: (context, notifier, child) => SwitchListTile(
                    inactiveTrackColor: Colors.black,
                    activeTrackColor: Colors.white,
                    inactiveThumbColor: Colors.white,
                    activeColor: Colors.black,
                    title: Text("Dark Mode"),
                    onChanged: (value) {
                      notifier.toggleTheme();
                    },
                    value: notifier.isDarkTheme,
                  ))),
    );
  }
}

class _AddButton extends StatelessWidget {
  final Post post;

  const _AddButton({Key key, @required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isSaved = context.select<SavedPostsModel, bool>(
      (savedPosts) => savedPosts.savedPosts.contains(post),
    );

    return FlatButton(
      onPressed: isSaved
          ? null
          : () {
              var savedPosts = context.read<SavedPostsModel>();
              savedPosts.add(post);
              print(isSaved);
            },
      child: isSaved
          ? Icon(Icons.favorite, semanticLabel: 'Saved')
          : Icon(Icons.favorite_border, semanticLabel: 'Save'),
    );
  }
}

class _MyListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var posts = context.watch<PostsModel>();
    posts.fillPosts();
    //var textTheme = Theme.of(context).textTheme.headline6;
    return ListView.separated(
      itemCount: posts.posts.length,
      shrinkWrap: true,
      itemBuilder: (context, index) => Column(
        children: [
          Container(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    posts.posts[index].title,
                    style: TextStyle(fontSize: 17),
                  ),
                  flex: 8,
                ),
                Expanded(
                  child: _AddButton(post: posts.posts[index]),
                  flex: 1,
                ),
              ],
            ),
          ),
          Container(
            height: 0,
          ),
          Container(
            height: 237,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(posts.posts[index].thumbnailUrl),
              ]
            ),
          ),
        ],
//
      ),
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 20,
        );
      },
    );
  }
}
