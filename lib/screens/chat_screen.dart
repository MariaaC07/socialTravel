// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, library_private_types_in_public_api, unnecessary_string_escapes, use_build_context_synchronously, avoid_print, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel/models/chats.dart';
import 'package:travel/resources/firestore_methods.dart';
import 'package:travel/screens/conversation_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool search = false;
  bool isShowUser = false;
  final TextEditingController searchController = TextEditingController();
  String? currentUsername;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      if (searchController.text.isEmpty) {
        setState(() {
          isShowUser = false;
        });
      }
    });
    getCurrentUsername();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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

  String getChatRoomIdByUsername(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 50, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  search
                      ? Expanded(
                          child: TextFormField(
                            controller: searchController,
                            decoration: const InputDecoration(
                                labelText: 'Search for a user'),
                            onFieldSubmitted: (String _) {
                              setState(() {
                                isShowUser = searchController.text.isNotEmpty;
                              });
                            },
                          ),
                        )
                      : Text(
                          "Chat",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        search = true;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: Icon(Icons.search, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                child: isShowUser
                    ? FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .where('username',
                                isGreaterThanOrEqualTo: searchController.text)
                            .where('username',
                                isLessThan: '${searchController.text}z')
                            .get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          final docs = snapshot.data!.docs;

                          return ListView.builder(
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                              final data =
                                  docs[index].data() as Map<String, dynamic>;

                              return InkWell(
                                onTap: () async {
                                  search = false;
                                  setState(() {});
                                  String otherUsername = data['username'];
                                  var chatRoomId = getChatRoomIdByUsername(
                                      currentUsername!, otherUsername);

                                  // camera de chat între utilizatori
                                  await FirestoreMethods().createChatRoom(
                                      chatRoomId,
                                      currentUsername!,
                                      otherUsername);

                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ConversationScreen(
                                      chatRoomId: chatRoomId,
                                      otherUser: otherUsername,
                                    ),
                                  ));
                                },
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        data.containsKey('photoUrl') &&
                                                data['photoUrl'] != null
                                            ? NetworkImage(data['photoUrl'])
                                            : null,
                                    child: data.containsKey('photoUrl') &&
                                            data['photoUrl'] != null
                                        ? null
                                        : Text(
                                            data['username'] != null &&
                                                    data['username'].isNotEmpty
                                                ? data['username'][0]
                                                    .toUpperCase()
                                                : '?',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                    backgroundColor: Colors.grey,
                                  ),
                                  title: Text(data['username'] ?? 'No username',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              );
                            },
                          );
                        },
                      )
                    : currentUsername == null
                        ? Center(child: CircularProgressIndicator())
                        : FutureBuilder<List<ChatRoom>>(
                            future: FirestoreMethods.getChatRoomsForUser(
                                currentUsername!),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }

                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                print(
                                    "No chat rooms found for user: $currentUsername");
                                return Center(
                                  child: Text(
                                    'No conversations yet',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                );
                              }

                              final chatRooms = snapshot.data!;

                              print(
                                  "Found ${chatRooms.length} chat rooms for user: $currentUsername");
                              return ListView.builder(
                                itemCount: chatRooms.length,
                                itemBuilder: (context, index) {
                                  final chatRoom = chatRooms[index];

                                  final otherUser =
                                      chatRoom.receiver != currentUsername
                                          ? chatRoom.receiver
                                          : chatRoom.sender;

                                  final lastMessage = chatRoom.lastMessage;
                                  final formattedTimestamp =
                                      chatRoom.getFormattedTimestamp();

                                  return Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey.shade800,
                                            width: 0.5),
                                      ),
                                    ),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 8.0),
                                      title: Text(
                                        otherUser,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      subtitle: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  lastMessage,
                                                  style: TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 14.0,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            formattedTimestamp,
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              ConversationScreen(
                                            chatRoomId: chatRoom.chatRoomId,
                                            otherUser: otherUser,
                                          ),
                                        ));
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
