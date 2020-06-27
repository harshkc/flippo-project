import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Post {
  String postId;
  String userId;
  Timestamp timeStamp;
  int likes;
  String photoUrl;
  String name;
  String profilePhoto;

  Post({
    @required this.postId,
    @required this.userId,
    @required this.photoUrl,
    @required this.profilePhoto,
    @required this.name,
    @required this.likes,
    @required this.timeStamp,
  });

  //for mapping image
  Map toMap() {
    var map = Map<String, dynamic>();
    map['postId'] = this.postId;
    map['userId'] = this.userId;
    map['profilePhoto'] = this.profilePhoto;
    map['name'] = this.name;
    map['likes'] = this.likes;
    map['timestamp'] = this.timeStamp;
    map['photoUrl'] = this.photoUrl;
    return map;
  }

  //Named constructor
  Post.fromMap(Map<String, dynamic> map) {
    this.postId = map['postId'];
    this.userId = map['userId'];
    this.profilePhoto = map['profilePhoto'];
    this.name = map['name'];
    this.timeStamp = map['timestamp'];
    this.photoUrl = map['photoUrl'];
    this.likes = map['likes'];
  }
}
