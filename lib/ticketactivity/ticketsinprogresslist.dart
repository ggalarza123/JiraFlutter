import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TicketInProgressListPage extends StatefulWidget {
  const TicketInProgressListPage({super.key});

  @override
  State<TicketInProgressListPage> createState() =>
      TicketInProgressListPageState();
}

class TicketInProgressListPageState extends State<TicketInProgressListPage> {
  String uid = "";
  @override
  void initState() {
    super.initState();
    getUID();
  }

  getUID() {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    setState(() {
      uid = user!.uid;
    });
  }

  var fields = {'mainCollection': 'tickets'};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text("IF wanted title can go here"),
      ),
      body: Container(
        child: StreamBuilder(
          // stream needs to be for user specific
          stream: FirebaseFirestore.instance
              .collection(fields['mainCollection']!)
              .doc(uid)
              .collection('myTickets')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(child: CircularProgressIndicator());
            } else {
              final docs = snapshot.data!.docs;
              return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        // code to open ticket item details
                        Navigator.pushNamed(context, '/ticketInTheWorksQueue',
                            arguments: {
                              'severity': docs[index]['severity'],
                              'category': docs[index]['category'],
                              if (docs[index]['description'] != null)
                                'description': docs[index]['description'],
                              if (docs[index].data().containsKey('time'))
                                'time': docs[index]['time'],
                              'isExistingTicket': true,
                            });
                      },
                      title: Row(
                        children: [
                          Text("Category: "),
                          Text(docs[index]['category']),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          Text("Severity Level: "),
                          Text(docs[index]['severity']),
                        ],
                      ),
                      trailing: Icon(Icons.edit),
                    );
                  });
            }
          },
        ),
      ),
    );
  }
}
