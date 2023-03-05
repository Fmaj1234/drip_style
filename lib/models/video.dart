import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  final String username;
  final String uid;
  final String postId;
  final List likes;
  final int commentCount;
  final int shareCount;
  final String songName;
  final DateTime datePublished;
  final String description;
  final String postUrl;
  final String thumbnail;
  final String profImage;

  Video({
    required this.username,
    required this.uid,
    required this.postId,
    required this.likes,
    required this.commentCount,
    required this.shareCount,
    required this.songName,
    required this.datePublished,
    required this.description,
    required this.postUrl,
    required this.profImage,
    required this.thumbnail,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "profImage": profImage,
        "postId": postId,
        "likes": likes,
        "commentCount": commentCount,
        "shareCount": shareCount,
        "songName": songName,
        "datePublished": datePublished,
        "description": description,
        "postUrl": postUrl,
        "thumbnail": thumbnail,
      };

  static Video fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Video(
      username: snapshot['username'],
      uid: snapshot['uid'],
      postId: snapshot['postId'],
      likes: snapshot['likes'],
      commentCount: snapshot['commentCount'],
      shareCount: snapshot['shareCount'],
      songName: snapshot['songName'],
      datePublished: snapshot["datePublished"],
      description: snapshot['description'],
      postUrl: snapshot['postUrl'],
      profImage: snapshot['profImage'],
      thumbnail: snapshot['thumbnail'],
    );
  }
}
