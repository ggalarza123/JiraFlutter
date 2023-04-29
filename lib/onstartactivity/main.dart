import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../authactivity/authscreen.dart';
import '../authactivity/signupscreen.dart';
import '../mainmenuactivity/menuscreen.dart';
import '../ticketactivity/openticketscreen.dart';
import '../ticketactivity/ticketscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Stream<QuerySnapshot> _userStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  // This widget is the root of this application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/main-menu',
      // home: StreamBuilder(
      //     stream: _userStream,
      //     builder: (context, userSnapshot) {
      //       if (FirebaseAuth.instance.currentUser == null) {
      //         Navigator.pushNamed(context, '/login');
      //       }
      //       return const MainMenuActivity(
      //         title: "Main Menu Activity",
      //       );
      //     }),
      routes: {
        '/login': ((context) => AuthActivity()),
        '/main-menu': ((context) =>
            const MainMenuActivity(title: "Menu Directory Page")),
        '/signup': ((context) => SignUpActivity()),
        '/ticket-form': ((context) => AddTicketActivity()),
        '/openticketform' : ((context) => OpenTicketActivity()),
      },
    );
  }
}
