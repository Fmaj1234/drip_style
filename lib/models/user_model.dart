import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final List followers;
  final List following;
  final String password;
  final bool isOnline;
  final bool privacy;
  final bool merchant;
  final String phoneNumber;
  final String provider;
  final String status;
  final String website;
  final String interest;
  final String location;
  final String timeAdded;
  final List<String> groupId;

  UserModel({
    required this.username,
    required this.uid,
    required this.photoUrl,
    required this.email,
    required this.bio,
    required this.followers,
    required this.following,
    required this.isOnline,
    required this.privacy,
    required this.merchant,
    required this.phoneNumber,
    required this.provider,
    required this.status,
    required this.password,
    required this.website,
    required this.interest,
    required this.location,
    required this.timeAdded,
    required this.groupId,
  });

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
      bio: snapshot["bio"],
      followers: snapshot["followers"],
      following: snapshot["following"],
      isOnline: snapshot['isOnline'],
      privacy: snapshot['privacy'],
      merchant: snapshot['merchant'],
      phoneNumber: snapshot['phoneNumber'],
      provider: snapshot['provider'],
      status: snapshot['status'],
      password: snapshot['password'],
      website: snapshot['website'],
      interest: snapshot['interest'],
      location: snapshot['location'],
      timeAdded: snapshot['timeAdded'],
      groupId: List<String>.from(snapshot['groupId']),
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
        "followers": followers,
        "following": following,
        'isOnline': isOnline,
        'privacy': privacy,
        'merchant': merchant,
        'phoneNumber': phoneNumber,
        'provider': provider,
        'status': status,
        'password': password,
        'website': website,
        'interest': interest,
        'location': location,
        'timeAdded': timeAdded,
        'groupId': groupId,
      };
}
