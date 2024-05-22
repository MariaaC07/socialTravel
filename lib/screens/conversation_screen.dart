// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:travel/utils/colors.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      body: Container(
        margin: EdgeInsets.only(top: 60, left: 20, right: 20),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 90),
                Text(
                  "Username",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 40),
              // margin:
              //     EdgeInsets.only(left: MediaQuery.of(context).size.width / 2),
              // alignment: Alignment.bottomRight,
              height: MediaQuery.of(context).size.height / 1.15,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    // bottomLeft: Radius.circular(10)
                  )),
              child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width / 3),
                      alignment: Alignment.bottomRight,
                      decoration: BoxDecoration(
                          color: Colors.white30,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10))),
                      child: Text(
                        "This is the first message",
                        style: TextStyle(color: Colors.white60, fontSize: 15),
                      )),
                  SizedBox(height: 20),
                  Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width / 3),
                      alignment: Alignment.bottomRight,
                      decoration: BoxDecoration(
                          color: Colors.white30,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      child: Text(
                        "This is the second message",
                        style: TextStyle(color: Colors.white60, fontSize: 15),
                      )),
                  Spacer(),
                  Material(
                    borderRadius: BorderRadius.circular(20),
                    elevation: 5,
                    child: Container(
                      padding: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration:
                                  InputDecoration(border: InputBorder.none, hintText: "Type a message", hintStyle: TextStyle(color: Colors.white)),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            child: Icon(Icons.send, color: Colors.white54,))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
