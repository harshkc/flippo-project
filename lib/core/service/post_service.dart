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

  // toMap(String userId) {
  //   var likeDetails = Map();
  //   likeDetails['uid'] = userId;
  //   likeDetails['timestamp'] = DateTime.now();
  //   return likeDetails;
  // }

  // incrementLikes(String postId, String userId) async {
  //   var querySnapshot = await _postCollection
  //       .document(postId)
  //       .collection("likes")
  //       .getDocuments();
  //   for (var i = 0; i < querySnapshot.documents.length; i++) {
  //     //checking the userId of the user
  //     if (querySnapshot.documents[i].documentID != userId) {
  //       await _postCollection
  //           .document(postId)
  //           .collection("likes")
  //           .document(userId)
  //           .setData(toMap(userId));
  //     }
  //   }
  // }

  // Future<bool> checkIfLiked(String postId, String userId) async {
  //   var querySnapshot = await _postCollection
  //       .document(postId)
  //       .collection("likes")
  //       .getDocuments();
  //   for (var i = 0; i < querySnapshot.documents.length; i++) {
  //     //eliminating the userId of the user
  //     if (querySnapshot.documents[i].documentID == userId) {
  //       return true;
  //     }
  //   }
  //   return false;
  // }

  // getLikesCount(String postId) {
  //   var querySnapshot =
  //       _postCollection.document(postId).collection("likes").snapshots();
  //   return querySnapshot.length;
  // }
}
