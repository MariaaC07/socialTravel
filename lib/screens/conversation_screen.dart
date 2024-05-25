// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel/models/chats.dart';
import 'package:travel/resources/firestore_methods.dart';


class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  final String otherUser;
  const ConversationScreen(
      {Key? key, required this.chatRoomId, required this.otherUser})
      : super(key: key);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}


class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  String? currentUsername;

  @override
  void initState() {
    super.initState();
    getCurrentUsername();
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty && currentUsername != null) {
      final message = Message(
        receiver: widget.otherUser,
        sender: currentUsername!,
        content: _messageController.text,
        timestamp: Timestamp.now(),
      );

      FirestoreMethods().sendMessage(widget.chatRoomId, message);
      _messageController.clear();
    }
  }

  Future<void> getCurrentUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        currentUsername = userDoc['username'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: currentUsername == null
            ? Center(child: CircularProgressIndicator())
            : Container(
                margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: Colors.white,
                        ),
                        SizedBox(width: 20),
                        Text(
                          widget.otherUser,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: StreamBuilder<List<Message>>(
                        stream: FirestoreMethods().getMessages(widget.chatRoomId),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }

                          final messages = snapshot.data!;

                          return ListView.builder(
                            reverse: true,
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final message = messages[index];
                              return Container(
                                padding: EdgeInsets.all(10),
                                alignment: message.sender == currentUsername
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  color: message.sender == currentUsername
                                      ? Colors.blue[300]
                                      : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                margin: EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  message.content,
                                  style: TextStyle(color: Colors.black, fontSize: 15),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Type a message",
                                hintStyle: TextStyle(color: Colors.white),
                              ),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.send, color: Colors.white54),
                            onPressed: _sendMessage,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
