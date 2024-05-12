import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String city;
  final String country;
  final String postType;
  final String username;
  final String postId;
  final  datePublished;
  final String postUrl;
  final String profImage;
  final likes;

  const Post(
      {required this.description,
      required this.uid,
      required this.city,
      required this.country,
      required this.postType,
      required this.username,
      required this.postId,
      required this.datePublished,
      required this.postUrl,
      required this.profImage,
      required this.likes});

  //convert to object
  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "description": description,
        "city": city,
        "country": country,
        "postType": postType,
        "postId": postId,
        "datePublished": datePublished,
        "postUrl": postUrl,
        "profImage": profImage,
        "likes": likes
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
        username: snapshot['username'],
        uid: snapshot['uid'],
        description: snapshot['description'],
        city: snapshot['city'],
        country: snapshot['country'],
        postType: snapshot['postType'],
        datePublished: snapshot['datePublished'],
        postUrl: snapshot['postUrl'],
        profImage: snapshot['profImage'],
        likes: snapshot['likes'],
        postId: snapshot['postId'],);
  }
}
