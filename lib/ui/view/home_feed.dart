import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flippo/core/enums/view_state.dart';
import 'package:flippo/core/model/post.dart';
import 'package:flippo/core/provider/image_upload_provider.dart';
import 'package:flippo/ui/shared/constant.dart';
import 'package:flippo/ui/shared/widgets/story_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  ImageUploadProvider _imageUploadProvider = ImageUploadProvider();
  final CollectionReference _postCollection = _firestore.collection("post");
  static final Firestore _firestore = Firestore.instance;
  bool isLiked = false;

  final String noImageAvailable =
      "https://www.esm.rochester.edu/uploads/NoPhotoAvailable.jpg";

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return StreamBuilder(
        stream:
            _postCollection.orderBy("timestamp", descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (_imageUploadProvider.getViewState == ViewState.LOADING) {
            return LinearProgressIndicator();
          }
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) => index == 0
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: SizedBox(
                      height: deviceSize.height * 0.10,
                      child: StoryView(),
                    ),
                  )
                : feed(snapshot.data.documents[index], context),
          );
        });
  }

  Widget feed(DocumentSnapshot snapshot, BuildContext context) {
    Post post = Post.fromMap(snapshot.data);
    var deviceSize = MediaQuery.of(context).size;

    return Container(
      color: Color(0xffF0F2FF),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      height: 40.0,
                      width: 40.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(post.profilePhoto),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      post.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () => showSnackbar(context, 'More'),
                )
              ],
            ),
          ),
          Stack(
            children: <Widget>[
              CachedNetworkImage(
                width: double.infinity,
                height: deviceSize.height * 0.4,
                imageUrl: post.photoUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: Shimmer.fromColors(
                    child: Icon(
                      Icons.image,
                      color: Colors.white38,
                      size: 250.0,
                    ),
                    baseColor: Colors.white,
                    highlightColor: Colors.grey,
                  ),
                ),
                errorWidget: (context, url, error) =>
                    Image.network(noImageAvailable, fit: BoxFit.cover),
              ),
              Positioned(
                bottom: deviceSize.height * 0.19,
                right: deviceSize.width * 0.02,
                child: IconButton(
                  icon: !isLiked
                      ? Icon(
                          FontAwesomeIcons.heart,
                          color: Colors.white,
                          size: 35.0,
                        )
                      : Icon(
                          FontAwesomeIcons.solidHeart,
                          color: Colors.red,
                          size: 35.0,
                        ),
                  onPressed: () {
                    toggleLike(post);
                  },
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.comment,
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                    Icon(FontAwesomeIcons.paperPlane),
                  ],
                ),
                Icon(FontAwesomeIcons.bookmark)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Liked by ${post.likes} people",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(post.profilePhoto)),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Add a comment...",
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0),
        ],
      ),
    );
  }

  void showSnackbar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: Text(
          text,
          style: TextStyle(color: kPrimaryColor),
        ),
        duration: Duration(seconds: 1),
      ),
    );
  }

  toggleLike(Post post) {
    if (!isLiked) {
      setState(() {
        _postCollection
            .document(post.postId)
            .updateData({"likes": ++post.likes});
        isLiked = true;
      });
    } else {
      setState(() {
        _postCollection
            .document(post.postId)
            .updateData({"likes": --post.likes});
        isLiked = false;
      });
    }
  }
}
