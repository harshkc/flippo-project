import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flippo/core/model/post.dart';

class PostService {
  static final Firestore _firestore = Firestore.instance;
  Post _post;
  final CollectionReference _postCollection = _firestore.collection("post");

  Future<void> addPost(String postId, String url, String userId, int likes,
      String name, String profilePhoto) async {
    //named constructor is called for registering values
    _post = Post(
      postId: postId,
      userId: userId,
      photoUrl: url,
      timeStamp: Timestamp.now(),
      likes: likes,
      name: name,
      profilePhoto: profilePhoto,
    );

    //creating imagemap through named image constructor
    var map = _post.toMap(); //map = Map<String,dynamic>();

    await _postCollection.document(postId).setData(map);
  }
}
