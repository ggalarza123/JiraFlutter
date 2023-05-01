import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuView extends StatefulWidget {
  @override
  State<MenuView> createState() => MenuViewPageState();
}

Future<void> logOut(context) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  await auth.signOut();
  Navigator.pushNamed(context, '/login');
}


class MenuViewPageState extends State<MenuView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 60),
            const Text(
              'Welcome!',
              style: TextStyle(
                fontSize: 40,
              ),
            ),
            const SizedBox(height: 80),
            SizedBox(
              width: 250,
              height: 60,
              child: ElevatedButton(
                style: ButtonStyle(
                  textStyle: MaterialStateProperty.all<TextStyle>(
                      const TextStyle(
                          fontSize: 20,
                          fontWeight:
                              FontWeight.bold) // Change the font size to 20
                      ),
                ),
                onPressed: () {

                  Navigator.pushNamed(context, '/ticket-form');
                },
                child: Text('Create Ticket'),
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: 250,
              height: 60,
              child: ElevatedButton(
                style: ButtonStyle(
                  textStyle: MaterialStateProperty.all<TextStyle>(
                      const TextStyle(
                          fontSize: 20,
                          fontWeight:
                              FontWeight.bold) // Change the font size to 20
                      ),
                ),
                onPressed: () {

                  // THIS NEEDS TO BE ADJUSTED SINCE IT TAKES US TO THE FORM FOR TESTING BUT NOT THE ACTUAL OPEN TICKETS
                  Navigator.pushNamed(context, '/newticketlist');
                },
                child: Text('View Open Tickets'),
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: 250,
              height: 60,
              child: ElevatedButton(
                style: ButtonStyle(
                  textStyle: MaterialStateProperty.all<TextStyle>(
                      const TextStyle(
                          fontSize: 20,
                          fontWeight:
                              FontWeight.bold) // Change the font size to 20
                      ),
                ),
                onPressed: () {},
                child: Text('View Closed Tickets'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            tooltip: 'Logout',
            backgroundColor: Colors.teal,
            child: const Icon(Icons.exit_to_app),
            onPressed: () => logOut(context),
          ),
        ],
      ),
    );
  }
}
