import 'package:flutter/material.dart';
import 'package:travel/screens/add_post_screen.dart';
import 'package:travel/screens/feed_screen.dart';
import 'package:travel/screens/profile_screen.dart';
import 'package:travel/screens/search_screen.dart';

const webScreenSize = 600;

const homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Text('notif'),
  ProfileScreen()
];
