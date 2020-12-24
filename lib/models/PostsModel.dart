import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


Future<List<Post>> fetchPosts(http.Client client) async {
  final response =
  await client.get('https://picsum.photos/v2/list?limit=15');

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parsePosts, response.body);
}

List<Post> parsePosts(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Post>((json) => Post.fromJson(json)).toList();
}

class Post {
  final int id;
  final String title;
  final String thumbnailUrl;

  Post({this.id, this.title, this.thumbnailUrl});

  factory Post.fromJson(Map<String, dynamic> json) {
    int id = int.parse(json['id']);
    return Post(
      id: id as int,
      title: json['author'] as String,
      thumbnailUrl: json['download_url'] as String,
    );
  }

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is Post && other.id == id;
}

class PostsModel extends ChangeNotifier{
  List<Post> posts = [];

  void fillPosts() async{
    posts = await fetchPosts(http.Client());
  }

  Post getByPosition(int position){
    return posts.singleWhere((element) => element.id == position);
  }

  void add(int id, String title, String url) {
    posts.add(Post(id: id, title: title, thumbnailUrl: url));
    notifyListeners();
  }
}