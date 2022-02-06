import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/models/user_model.dart' as model;
import 'package:instagram_clone/services/storage_methods.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // fetch user details
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection("users").doc(currentUser.uid).get();
    return model.User.fromSnapshot(snapshot);
  }

  //  create user
  Future<String> createUser({
    required String username,
    required String bio,
    required String email,
    required String password,
    required Uint8List file,
  }) async {
    String result = "Some error occured while creating your account";
    try {
      if (username.isNotEmpty &&
          bio.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty) {
        // register user
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        print(credential.user!.uid);
        String photoUrl =
            await Storage().uploadProfile("profilePics", file, false);
        //  Save user to DB

        model.User user = model.User(
          uid: credential.user!.uid,
          username: username,
          bio: bio,
          email: email,
          photoUrl: photoUrl,
          followers: [],
          following: [],
        );
        _firebaseFirestore
            .collection("users")
            .doc(credential.user!.uid)
            .set(user.toJson());
        result = "success";
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == "invalid-email") {
        result = "Check your email";
      } else if (error.code == "weak-password") {
        result = "Password should be atleast 6 characters.";
      }
    } catch (error) {
      result = error.toString();
    }
    return result;
  }

  Future<String> login(
      {required String email, required String password}) async {
    String result = "Error occured login you in!";

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        result = "success";
      } else {
        result = "Please provide email and password!";
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == "user-not-found") {
        result = "The account $email does not exist!";
      } else if (error.code == "wrong-password") {
        result = "You have entered a wrong password!";
      }
    } catch (error) {
      result = error.toString();
      print(error.toString());
    }
    return result;
  }
}
