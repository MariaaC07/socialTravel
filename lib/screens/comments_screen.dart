import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel/models/user.dart';
import 'package:travel/providers/user_provider.dart';
import 'package:travel/resources/firestore_methods.dart';
// import 'package:flutter/widgets.dart';
import 'package:travel/utils/colors.dart';
import 'package:travel/widgets/comment_card.dart';

class CommentsScreen extends StatefulWidget {
  final snap;
  const CommentsScreen({Key? key, required this.snap}) : super(key: key);
  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentControler = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _commentControler.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('Comments'),
        centerTitle: false,
      ),
      body: CommentCard(),
      bottomNavigationBar: SafeArea(
          child: Container(
        height: kToolbarHeight,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.photoUrl),
              radius: 18,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: TextField(
                  controller: _commentControler,
                  decoration: InputDecoration(
                      hintText: 'Comment as ${user.username}',
                      border: InputBorder.none),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await FirestoreMethods().postComment(
                    widget.snap['postId'],
                    _commentControler.text,
                    user.uid,
                    user.username,
                    user.photoUrl);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 8,
                ),
                child: const Text(
                  'Post',
                  style: TextStyle(
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
