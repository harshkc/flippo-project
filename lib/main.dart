import 'package:firebase_auth/firebase_auth.dart';
import 'package:flippo/core/provider/image_upload_provider.dart';
import 'package:flippo/core/service/auth_service.dart';
import 'package:flippo/ui/shared/constant.dart';
import 'package:flippo/ui/view/home_screen.dart';
import 'package:flippo/ui/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthMethods _authMethods = AuthMethods();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ImageUploadProvider(),
      child: MaterialApp(
        title: 'Flippo Project',
        theme: ThemeData(
          primaryColor: kPrimaryColor,
          backgroundColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
          future: _authMethods.getCurrentUser(),
          builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
            if (!snapshot.hasData) {
              return LoginScreen();
            } else {
              return HomeScreen();
            }
          },
        ),
      ),
    );
  }
}
