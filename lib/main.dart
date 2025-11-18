import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_video_player/screens/video_player_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Video Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const VideoPlayerScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}