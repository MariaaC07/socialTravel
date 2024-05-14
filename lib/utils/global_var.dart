import 'package:flutter/material.dart';
import 'package:travel/screens/add_post_screen.dart';
import 'package:travel/screens/feed_screen.dart';

const webScreenSize = 600;

const homeScreenItems = [
  FeedScreen(),
  Text('search'),
  AddPostScreen(),
  Text('notif'),
  Text('profile')
];
