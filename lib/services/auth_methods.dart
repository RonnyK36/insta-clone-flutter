import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  //  create user
  Future<String> createUser({
    required String username,
    required String bio,
    required String email,
    required String password,
    // required Uint8List file,
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
        //  Save user to DB
        _firebaseFirestore.collection("users").doc(credential.user!.uid).set({
          "uid": credential.user!.uid,
          "username": username,
          "email": email,
          "bio": bio,
          "following": [],
          "followers": [],
        });
        result = "Successfully created user";
      }
    } catch (error) {
      result = error.toString();
    }
    return result;
  }
}
