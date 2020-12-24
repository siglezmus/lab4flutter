import 'package:flutter/foundation.dart';
import 'package:lab4/models/PostsModel.dart';

class SavedPostsModel extends ChangeNotifier {

  PostsModel _posts;

  /// Internal, private state of the cart. Stores the ids of each item.
  final List<int> _savedPosts = [];

  /// The current catalog. Used to construct items from numeric ids.
  PostsModel get posts => _posts;

  set posts(PostsModel newPosts) {
    assert(newPosts != null);
    assert(_savedPosts.every((id) => newPosts.getByPosition(id) != null),
    'The catalog $newPosts does not have one of $_savedPosts in it.');
    _posts = newPosts;
    // Notify listeners, in case the new catalog provides information
    // different from the previous one. For example, availability of an item
    // might have changed.
    notifyListeners();
  }

  /// List of items in the cart.
  List<Post> get savedPosts => _savedPosts.map((id) => _posts.getByPosition(id)).toList();

  /// The current total price of all items.
  /// Adds [item] to cart. This is the only way to modify the cart from outside.
  void add(Post post) {
    _savedPosts.add(post.id);
    print(_posts);
    notifyListeners();
  }

  void removeAll(){
    _savedPosts.clear();
    notifyListeners();
  }
}