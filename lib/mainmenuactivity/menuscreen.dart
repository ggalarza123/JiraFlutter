import 'package:flutter/material.dart';
import 'mainmenuoptions.dart';

class MainMenuActivity extends StatefulWidget {
  const MainMenuActivity({super.key, required this.title});
  final String title;

  @override
  State<MainMenuActivity> createState() => MainMenuActivityState();
}

class MainMenuActivityState extends State<MainMenuActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main menu'),
      ),
      body: MenuView(

      ),
    );
  }
}
