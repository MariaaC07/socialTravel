import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel/models/post.dart';
import 'package:travel/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload post
  Future<String> uploadPost(
      String description,
      Uint8List file,
      String uid,
      String country,
      String city,
      String postType,
      String username,
      String profImage) async {
    String res = "Some error occured";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1(); //unique id

      Post post = Post(
          description: description,
          uid: uid,
          city: city,
          country: country,
          postType: postType,
          username: username,
          postId: postId,
          datePublished: DateTime.now(),
          postUrl: photoUrl,
          profImage: profImage,
          likes: []);
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
