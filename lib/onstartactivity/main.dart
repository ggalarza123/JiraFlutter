import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../authactivity/authscreen.dart';
import '../ticketactivity/closedticketlistscreen.dart';
import '../ticketactivity/newticketlistscreen.dart';
import '../ticketactivity/ticketinprogressscreen.dart';
import '../ticketactivity/ticketscreen.dart';
import 'identifyuser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of this application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return IdentifyUserActivity();
          } else {
            return AuthActivity();
          }
        },
      ),
      routes: {
        '/login': ((context) => AuthActivity()),
        // '/main-menu': ((context) =>
        //     const MainMenuActivity(title: "Menu Directory Page")),
        '/signup': ((context) => AuthActivity()),
        '/ticket-form': ((context) => AddTicketActivity()),
        '/openticketform': ((context) => ExistingTicketInTheWorksActivity()),
        '/newticketlist': ((context) =>
            NewTicketListPage(title: "New Tickets")),
        '/closedticketlist': ((context) => ClosedTicketListPage(
              title: 'Closed Tickets',
            )),
      },
    );
  }
}
