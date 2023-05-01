import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewTicketListPage extends StatefulWidget {
  const NewTicketListPage({super.key, required this.title});
  final String title;

  @override
  State<NewTicketListPage> createState() => NewTicketListPageState();
}

class NewTicketListPageState extends State<NewTicketListPage> {
  Stream<QuerySnapshot> ticketStream =
      FirebaseFirestore.instance.collection('newtickets').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: StreamBuilder(
          stream: ticketStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(child: CircularProgressIndicator());
            } else {
              /// THIS NEEDS TO BE REVIEWED WAS ORIGINALLY ANOTHER LINE OF CODE*****
              final docs = snapshot.data!.docs;
              return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        // code to open ticket item details
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
