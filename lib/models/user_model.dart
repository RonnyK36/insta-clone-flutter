import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username;
  final String uid;
  final String bio;
  final String email;
  final String photoUrl;
  final List following;
  final List followers;
  const User({
    required this.bio,
    required this.uid,
    required this.username,
    required this.email,
    required this.photoUrl,
    required this.following,
    required this.followers,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "bio": bio,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "following": following,
        "followers": followers,
      };

  static User fromSnapshot(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;

    return User(
      bio: snap["bio"],
      uid: snap["uid"],
      username: snap["username"],
      email: snap["email"],
      photoUrl: snap["photoUrl"],
      following: snap["following"],
      followers: snap["followers"],
    );
  }
}
