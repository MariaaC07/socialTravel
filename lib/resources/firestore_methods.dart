// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel/models/chats.dart';
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

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  Future<void> postComment(String postId, String text, String uid, String name,
      String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
      } else {
        print('Text is empty');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> deletePost(String postId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return "User not logged in";
    }
    try {
      final postSnapshot =
          await _firestore.collection('posts').doc(postId).get();
      if (postSnapshot.exists) {
        final postUserId = postSnapshot.data()?['uid'];
        if (postUserId == userId) {
          await _firestore.collection('posts').doc(postId).delete();
          return "Post deleted successfully";
        } else {
          return "You are not authorized to delete this post";
        }
      } else {
        return "Post not found";
      }
    } catch (err) {
      return err.toString();
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  

  Future<void> createChatRoom(
      String chatRoomId, String sender, String receiver) async {
    final chatRoomRef =
        FirebaseFirestore.instance.collection('chatRooms').doc(chatRoomId);

    final chatRoom = ChatRoom(
      chatRoomId: chatRoomId,
      sender: sender,
      receiver: receiver,
      lastMessage: '',
      timestamp: Timestamp.now(),
    );

    await chatRoomRef.set(chatRoom.toMap());
  }

  static Future<List<ChatRoom>> getChatRoomsForUser(String userId) async {
    QuerySnapshot chatRoomsSnapshotSender = await FirebaseFirestore.instance
        .collection('chatRooms')
        .where('sender', isEqualTo: userId)
        .get();

    QuerySnapshot chatRoomsSnapshotReceiver = await FirebaseFirestore.instance
        .collection('chatRooms')
        .where('receiver', isEqualTo: userId)
        .get();

    List<ChatRoom> chatRooms = [];

    chatRoomsSnapshotSender.docs.forEach((doc) {
      ChatRoom chatRoom = ChatRoom.fromDocument(doc);
      chatRooms.add(chatRoom);
    });

    chatRoomsSnapshotReceiver.docs.forEach((doc) {
      ChatRoom chatRoom = ChatRoom.fromDocument(doc);
      chatRooms.add(chatRoom);
    });

    return chatRooms;
  }

  Future<void> sendMessage(String chatRoomId, Message message) async {
    final messageRef = FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc();

    await messageRef.set(message.toMap());

    final chatRoomRef =
        FirebaseFirestore.instance.collection('chatRooms').doc(chatRoomId);

    await chatRoomRef.update({
      'lastMessage': message.content,
      'timestamp': message.timestamp,
    });
  }

  Stream<List<Message>> getMessages(String chatRoomId) {
    return FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Message.fromDocument(doc)).toList());
  }
}
