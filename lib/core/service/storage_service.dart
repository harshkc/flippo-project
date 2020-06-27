import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flippo/core/provider/image_upload_provider.dart';
import 'package:flippo/core/service/post_service.dart';
import 'package:flutter/material.dart';

class StorageService {
  static final Firestore firestore = Firestore.instance;
  PostService _postService = PostService();

  StorageReference _storageReference;

  //driver function to get url and add image msg as document in msg collection
  void uploadImage({
    @required String postId,
    @required File imageFile,
    @required String userId,
    @required String name,
    @required String profilePhoto,
    @required ImageUploadProvider imageUploadProvider,
    @required int likes,
  }) async {
    //While image is being added to storage set the imageUploadProvider to loading
    //which is reflected on chatScreen through provider
    imageUploadProvider.setToLoading();
    //Fetch the url after image is stored
    String url = await uploadImageToStorage(imageFile);
    //set the loading to idle and show on chatScreen
    _postService.addPost(postId, url, userId, likes, name, profilePhoto);
    imageUploadProvider.setToIdle();
    //Now this can be added in msg collection as document and shown on chatScreen
  }

  //To store image in firebase storage
  Future<String> uploadImageToStorage(File imageFile) async {
    try {
      _storageReference = FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}');
      StorageUploadTask storageUploadTask =
          _storageReference.putFile(imageFile);
      var url = await (await storageUploadTask.onComplete).ref.getDownloadURL();
      // print(url);
      return url;
    } catch (e) {
      return null;
    }
  }
}
