import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flippo/core/model/user.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  ///creating objects
  static final Firestore _firestore = Firestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final Firestore firestore = Firestore.instance;

  ///creating objects
  //collectionRefernce for DRY implementation
  static final CollectionReference _userCollection =
      _firestore.collection("users");

  ///fetching loggedIn user details///
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    return currentUser;
  }

  Future<User> getUserDetails() async {
    FirebaseUser currentUser = await getCurrentUser();

    DocumentSnapshot documentSnapshot =
        await _userCollection.document(currentUser.uid).get();

    return User.fromMap(documentSnapshot.data);
  }

  Future<User> getUserDetailsById(id) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _userCollection.document(id).get();
      return User.fromMap(documentSnapshot.data);
    } catch (e) {
      print(e);
      return null;
    }
  }

  ///fetching loggedIn user details///
  ///SigningIn User///
  Future<FirebaseUser> signIn() async {
    try {
      //google signIn
      GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();

      GoogleSignInAuthentication _signInAuthentication =
          await _signInAccount.authentication;

      //creating credential object for signIn purposes
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: _signInAuthentication.accessToken,
          idToken: _signInAuthentication.idToken);

      AuthResult result = await _auth.signInWithCredential(credential);

      return result.user;
    } catch (e) {
      print("Auth methods error");
      print(e);
      return null;
    }
  }

  ///SigningIn User///
  ///User authentication to db///
  //checking if the user is new
  Future<bool> authenticateUser(FirebaseUser user) async {
    QuerySnapshot result = await firestore
        .collection("users")
        .where('email', isEqualTo: user.email)
        .getDocuments();

    final List<DocumentSnapshot> docs = result.documents;

    //if user is registered then length of list > 0 or else less than 0
    return docs.length == 0 ? true : false;
  }

  //Username
  static String getUsername(String email) {
    return "${email.split("@")[0]}";
  }

  //Adding the new user to db
  Future<void> addDataToDb(FirebaseUser currentUser) async {
    String username = getUsername(currentUser.email);

    User user = User(
        uid: currentUser.uid,
        email: currentUser.email,
        name: currentUser.displayName,
        profilePhoto: currentUser.photoUrl,
        username: username);

    firestore
        .collection("users")
        .document(currentUser.uid)
        .setData(user.toMap(user));
  }

  ///Signing Out///
  Future<bool> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      return true;
    } catch (e) {
      print("Error in signout method - $e");
      return false;
    }
  }
}
