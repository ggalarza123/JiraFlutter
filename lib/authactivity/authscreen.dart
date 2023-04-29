import "package:flutter/material.dart";

import "authform.dart";

class AuthActivity extends StatefulWidget {
  @override
  _authScreenState createState() => _authScreenState();
}

// Pretty much every state will return a widget
class _authScreenState extends State<AuthActivity> {
  @override
  Widget build(BuildContext context) {
    // Scaffold holds pretty much the app bar and the body of a page
    return Scaffold(
      appBar: AppBar(
        title: Text('Login/Signup'),
      ),
      // body will use the authform.dart by creating an instance
      body: Authform(),
    );
  }
}
