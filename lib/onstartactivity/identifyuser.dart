import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../ticketactivity/closedticketlistscreen.dart';
import '../ticketactivity/newticketlistscreen.dart';
import '../ticketactivity/ticketinprogressscreen.dart';
import '../ticketactivity/ticketscreen.dart';
import '../authactivity/authscreen.dart';
import '../mainmenuactivity/menuscreen.dart';
import '../ticketactivity/ticketsinprogresslist.dart';
import 'uniqueuserdata.dart';

class IdentifyUserActivity extends StatefulWidget {
  const IdentifyUserActivity({super.key});

  @override
  State<IdentifyUserActivity> createState() => IdentifyUserActivityState();
}

class IdentifyUserActivityState extends State<IdentifyUserActivity> {
  String getUID() {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    return user!.uid;
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    return MaterialApp(
// This code now identifies the user
      home: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('userdetails')
            .where('email', isEqualTo: user!.email)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          print("size " + snapshot.data!.size.toString());
          snapshot.data!.docs.forEach((document) {
            print('Email: ${document['email']}');
            print('company-role: ${document['company-role']}');
          });

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {

            print('snapshot had data');
            print(snapshot.data!.docs);
            final companyRole = snapshot.data!.docs.first['company-role'];
            UniqueUserData.companyRole = companyRole;
            UniqueUserData.userName = snapshot.data!.docs.first['username'];
            // if (companyRole == 'IT') {
            return MainMenuActivity(
                title: "Menu Directory Page", companyRole: companyRole);
            // } else {
            //   return AuthActivity();
            // }
          }

          if (snapshot.data!.docs.isEmpty) {
            print('NO DATA');
            final companyRole = "Operations";
            UniqueUserData.companyRole = companyRole;
            UniqueUserData.userName ="unkown";
            return MainMenuActivity(
                title: "Menu Directory Page", companyRole: companyRole);
          }

          return AuthActivity();
        },
      ),
      routes: {
        '/login': ((context) => AuthActivity()),
        '/main-menu': ((context) => MainMenuActivity(
              title: "Menu Directory Page",
              companyRole: '',
            )),
        '/signup': ((context) => AuthActivity()),
        '/ticket-form': ((context) => AddTicketActivity()),
        '/ticketInTheWorksQueue': ((context) => ExistingTicketInTheWorksActivity()),
        '/newticketlist': ((context) =>
            NewTicketListPage(title: "New Tickets")),
        '/closedticketlist': ((context) => ClosedTicketListPage(
              title: 'Closed Tickets',
            )),
        '/ticketsInProgressList': ((context) => TicketInProgressListPage()),
      },
    );
  }
}
