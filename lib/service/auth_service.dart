
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //register
  Future<User?> register(
      String email, String pass, BuildContext context) async {
    try {
      UserCredential userCre = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: pass);
      return userCre.user;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message.toString()),
        backgroundColor: Colors.red,
      ));
    } catch (e) {
      print(e);
    }
    return null;
  }

  //login
  Future<User?> Login(String email, String password) async {
    UserCredential userCredential = await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  //google signIn
  Future<User?> signInWithGoogle() async {
  try {
    // Start the Google sign-in process
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Check if the user canceled the sign-in process
    if (googleUser == null) {
      // Handle the cancellation or do nothing
      print("Google sign-in canceled");
      return null;
    }

    // Retrieve authentication details
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a credential using the obtained authentication details
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in to Firebase using the credential
    UserCredential userCredential = await firebaseAuth.signInWithCredential(credential);

    // Return the signed-in user
    return userCredential.user;
  } catch (e) {
    // Handle any errors that occur during the sign-in process
    print("Error signing in with Google: $e");
    return null;
  }

 
  

}
Future signOut()async{
  // await GoogleSignIn().signOut();
  await firebaseAuth.signOut();
}
}
