import 'package:flutter/material.dart';
import 'package:jira_imitation_app/authactivity/authform.dart';

class AuthActivity extends StatefulWidget {
  @override
  AuthScreenState createState() => AuthScreenState();
}

// Pretty much every state will return a widget
class AuthScreenState extends State<AuthActivity> {
  @override
  Widget build(BuildContext context) {
    // Scaffold holds pretty much the app bar and the body of a page
    return Scaffold(
      appBar: AppBar(
        title: Text('Login/Signup'),
      ),
      // body will use the authform.dart by creating an instance
      body: AuthForm(),
    );
  }
}
