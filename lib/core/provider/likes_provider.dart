import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flippo/core/model/post.dart';
import 'package:flutter/material.dart';

class LikesProvider with ChangeNotifier {
  int _likes = 0;
  bool _isLiked = false;
  int get likes => _likes;
  bool get isLiked => _isLiked;
  static final Firestore _firestore = Firestore.instance;
  final CollectionReference _postCollection = _firestore.collection("post");

  incrementLikes(Post post) {
    if (_likes > 0) {
      _likes--;
      _isLiked = false;
      _postCollection.document(post.postId).updateData({"likes": --post.likes});
      notifyListeners();
    } else {
      _likes++;
      _isLiked = true;
      _postCollection.document(post.postId).updateData({"likes": ++post.likes});
      notifyListeners();
    }
  }
}
