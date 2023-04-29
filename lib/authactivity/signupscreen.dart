import 'package:flutter/material.dart';
import 'package:jira_imitation_app/authactivity/signupform.dart';

class SignUpActivity extends StatefulWidget {
  @override
  _signUpScreenState createState() => _signUpScreenState();
}

// Pretty much every state will return a widget
class _signUpScreenState extends State<SignUpActivity> {
  @override
  Widget build(BuildContext context) {
    // Scaffold holds pretty much the app bar and the body of a page
    return Scaffold(
      appBar: AppBar(
        title: Text('Login/Signup'),
      ),
      // body will use the authform.dart by creating an instance
      body: SignUpForm(),
    );
  }
}
