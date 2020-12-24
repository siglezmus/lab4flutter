import 'package:flutter/material.dart';
import 'package:lab4/models/ThemeNotifier.dart';
import 'package:provider/provider.dart';
import 'package:lab4/models/PostsModel.dart';
import 'package:lab4/models/SavedPostsModel.dart';
import 'dart:async';

class SavedFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //backgroundColor: Colors.cyan,
          title: Text('Saved Feed'),
          actions: [
            IconButton(
              icon: Icon(Icons.featured_play_list),
              onPressed: () => Navigator.pushNamed(context, '/mainFeed'),
            ),
          ],
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: _SavedPosts(),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: AnimatedDeleteButton(),
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
                    ))));
  }
}

class _SavedPosts extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    var savedPosts = context.watch<SavedPostsModel>();

    return ListView.separated(
      itemCount: savedPosts.savedPosts.length,
      shrinkWrap: true,
      itemBuilder: (context, index) => Column(
        children: [
          Container(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    savedPosts.savedPosts[index].title,
                    style: TextStyle(fontSize: 17),
                  ),
                  flex: 8,
                ),
                Expanded(
                  child: Icon(Icons.favorite),
                  flex: 1,
                ),
              ],
            ),
          ),
          Container(
            height: 10,
          ),
          Container(
            height: 243,
            child: Row(
              children: [
                Image.network(savedPosts.savedPosts[index].thumbnailUrl),
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

class AnimatedDeleteButton extends StatefulWidget {
  @override
    _AnimatedDeleteButtonState createState() => _AnimatedDeleteButtonState();

}

class _AnimatedDeleteButtonState extends State<AnimatedDeleteButton> with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _animateColor;
  Animation<double> _animateIcon;
  Curve _curve = Curves.easeOut;

  @override
  initState() {
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 800))
      ..addListener(() {
        setState(() {});
      });
    _animateIcon = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animateColor = ColorTween(
      begin: Colors.red,
      end: Colors.green,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: _curve,
      ),
    ));
    super.initState();
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void animation() {
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    var savedPosts = context.watch<SavedPostsModel>();
    return FloatingActionButton(
      backgroundColor: _animateColor.value,
      onPressed: (){
        animation();
        savedPosts.removeAll();
        Timer(Duration(milliseconds: 1000), () {Navigator.pop(context);});
        },
      tooltip: 'Toggle',
      child: AnimatedIcon(
        icon: AnimatedIcons.close_menu,
        progress: _animateIcon,
      ),
    );
  }

}