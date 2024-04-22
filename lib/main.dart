import 'package:flutter/material.dart';
import 'package:travel/responsive/mobile_screen_layout.dart';
import 'package:travel/responsive/responsive_layout_screen.dart';
import 'package:travel/responsive/web_screen_layout.dart';
import 'package:travel/utils/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TravelBuddy',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      home:const ResponsiveLayout(
        mobileScreenLayout: MobileScreenLayout(), 
        webScreenLayout: WebScreenLayout(),
        ),
    );
  }
}

