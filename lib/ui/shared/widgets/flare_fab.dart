import 'dart:io';
import 'dart:math';
import 'package:flippo/core/model/user.dart';
import 'package:flippo/core/provider/image_upload_provider.dart';
import 'package:flippo/core/service/auth_service.dart';
import 'package:flippo/core/service/storage_service.dart';
import 'package:flippo/core/utilities/storage_utils.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:image_picker/image_picker.dart';

enum AnimationToPlay {
  Activate,
  Deactivate,
  CameraTapped,
  PulseTapped,
  ImageTapped
}

class SmartFlareAnimation extends StatefulWidget {
  _SmartFlareAnimationState createState() => _SmartFlareAnimationState();
}

class _SmartFlareAnimationState extends State<SmartFlareAnimation> {
  ImageUploadProvider _imageUploadProvider = ImageUploadProvider();
  StorageService _storageService = StorageService();
  AuthMethods _authMethods = AuthMethods();
  String _currentUserId;
  User user;

  @override
  void initState() {
    super.initState();
    _authMethods.getCurrentUser().then((currentUser) {
      _currentUserId = currentUser.uid;
      setState(() {
        user = User(
          uid: currentUser.uid,
          name: currentUser.displayName,
          profilePhoto: currentUser.photoUrl,
        );
      });
    });
  }

  // width and height retrieved from the artboard values in the animation
  static const double AnimationWidth = 251.0;
  static const double AnimationHeight = 211.0;

  AnimationToPlay _lastPlayedAnimation;

  // Flare animation controls
  final FlareControls animationControls = FlareControls();

  bool isOpen = false;

  void pickImage({@required ImageSource source}) async {
    File selectedImage = await FileUtils.pickImage(source: source);
    selectedImage != null
        ? _storageService.uploadImage(
            postId: user.name +
                "%${Random().nextInt(1000)}#${Random().nextInt(100)}&${Random().nextInt(1000)}",
            imageFile: selectedImage,
            userId: _currentUserId,
            name: user.name,
            profilePhoto: user.profilePhoto,
            imageUploadProvider: _imageUploadProvider,
            likes: 0,
          )
        : print("User returned");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AnimationWidth,
      height: AnimationHeight,
      child: GestureDetector(
          onTapUp: (tapInfo) {
            var localTouchPosition = (context.findRenderObject() as RenderBox)
                .globalToLocal(tapInfo.globalPosition);

            var topHalfTouched = localTouchPosition.dy < AnimationHeight / 2;

            var leftSideTouched = localTouchPosition.dx < AnimationWidth / 3;

            var rightSideTouched =
                localTouchPosition.dx > (AnimationWidth / 3) * 2;

            var middleTouched = !leftSideTouched && !rightSideTouched;

            // Call our animation in our conditional checks
            if (leftSideTouched && topHalfTouched) {
              _setAnimationToPlay(AnimationToPlay.CameraTapped);
              pickImage(source: ImageSource.camera);
            } else if (middleTouched && topHalfTouched) {
              _setAnimationToPlay(AnimationToPlay.PulseTapped);
            } else if (rightSideTouched && topHalfTouched) {
              _setAnimationToPlay(AnimationToPlay.ImageTapped);
              pickImage(source: ImageSource.gallery);
            } else {
              if (isOpen) {
                _setAnimationToPlay(AnimationToPlay.Deactivate);
              } else {
                _setAnimationToPlay(AnimationToPlay.Activate);
              }

              isOpen = !isOpen;
            }
          },
          child: FlareActor('assets/fab-button.flr',
              controller: animationControls, animation: 'deactivate')),
    );
  }

  String _getAnimationName(AnimationToPlay animationToPlay) {
    switch (animationToPlay) {
      case AnimationToPlay.Activate:
        return 'activate';
      case AnimationToPlay.Deactivate:
        return 'deactivate';
      case AnimationToPlay.CameraTapped:
        return 'camera_tapped';
      case AnimationToPlay.PulseTapped:
        return 'pulse_tapped';
      case AnimationToPlay.ImageTapped:
        return 'image_tapped';
      default:
        return 'deactivate';
    }
  }

  void _setAnimationToPlay(AnimationToPlay animation) {
    var isTappedAnimation = _getAnimationName(animation).contains("_tapped");
    if (isTappedAnimation &&
        _lastPlayedAnimation == AnimationToPlay.Deactivate) {
      return;
    }

    animationControls.play(_getAnimationName(animation));

    _lastPlayedAnimation = animation;
  }
}
