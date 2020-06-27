import 'package:flippo/ui/shared/constant.dart';
import 'package:flippo/ui/view/home_feed.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Flippo",
            style: GoogleFonts.pacifico(
              fontSize: 32.0,
              color: kPrimaryColor,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 8.0),
        child: FeedScreen(),
      ),
    );
  }
}
