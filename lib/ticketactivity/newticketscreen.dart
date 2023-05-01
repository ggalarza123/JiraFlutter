import "package:flutter/material.dart";
import "package:jira_imitation_app/ticketactivity/newticketform.dart";

class NewTicketActivity extends StatefulWidget {
  @override
  NewTicketState createState() => NewTicketState();
}

// Pretty much every state will return a widget
class NewTicketState extends State<NewTicketActivity> {
  @override
  Widget build(BuildContext context) {
    // Scaffold holds pretty much the app bar and the body of a page
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Ticket'),
      ),
      body: NewTicketForm(),
    );
  }
}
