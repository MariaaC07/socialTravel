import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  final String chatRoomId;
  final String sender;
  final String receiver;
  final String lastMessage;
  final Timestamp timestamp;

  ChatRoom({
    required this.chatRoomId,
    required this.sender,
    required this.receiver,
    required this.lastMessage,
    required this.timestamp,
  });

  factory ChatRoom.fromDocument(DocumentSnapshot doc) {
    return ChatRoom(
      chatRoomId: doc.id,
      sender: doc['sender'],
      receiver: doc['receiver'],
      lastMessage: doc['lastMessage'],
      timestamp: doc['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'receiver': receiver,
      'lastMessage': lastMessage,
      'timestamp': timestamp,
    };
  }
}

class Message {
  final String sender;
  final String receiver;
  final String content;
  final Timestamp timestamp;

  Message({
    required this.sender,
    required this.receiver,
    required this.content,
    required this.timestamp,
  });

  factory Message.fromDocument(DocumentSnapshot doc) {
    return Message(
      sender: doc['sender'],
      receiver: doc['receiver'],
      content: doc['content'],
      timestamp: doc['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'receiver': receiver,
      'content': content,
      'timestamp': timestamp,
    };
  }
}
