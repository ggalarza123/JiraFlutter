import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClosedTicketListPage extends StatefulWidget {
  const ClosedTicketListPage({super.key, required this.title});
  final String title;

  @override
  State<ClosedTicketListPage> createState() => ClosedTicketListPageState();
}

class ClosedTicketListPageState extends State<ClosedTicketListPage> {
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
        title: Text(widget.title),
      ),
      body: Container(
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(5),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(fields['mainCollection']!)
              .doc(uid)
              .collection('closedTickets')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              final docs = snapshot.data!.docs;
              return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    Color backgroundColor;
                    switch (docs[index]['severity']) {
                      case 'Medium':
                        backgroundColor = Colors.lightBlueAccent;
                        break;
                      case 'High':
                        backgroundColor = Colors.orange;
                        break;
                      case 'Urgent':
                        backgroundColor = Colors.redAccent;
                        break;
                      case 'Catastrophe':
                        backgroundColor = Colors.red;
                        break;
                      default:
                        backgroundColor = Colors.yellow;
                        break;
                    }
                    return Container(
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      margin: EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        onTap: () {
                          // code to open ticket item details
                          Navigator.pushNamed(context, '/ticket-form',
                              arguments: {
                                'severity': docs[index]['severity'],
                                'category': docs[index]['category'],
                                'description': docs[index]['description'],
                                'time': docs[index]['time'],
                                'isExistingTicket': true,
                                'isTicketClosed': true,
                              });
                        },
                        title: Row(
                          children: [
                            const Text(
                              "Category: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              docs[index]['category'],
                            ),
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            const Text(
                              "Severity Level: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              docs[index]['severity'],
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        trailing: Icon(Icons.remove_red_eye_outlined),
                      ),
                    );
                  });
            }
          },
        ),
      ),
    );
  }
}
