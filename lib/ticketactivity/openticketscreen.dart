import "package:flutter/material.dart";
import "package:jira_imitation_app/ticketactivity/openticketform.dart";

class OpenTicketActivity extends StatefulWidget {
  @override
  _openticketState createState() => _openticketState();
}

// Pretty much every state will return a widget
class _openticketState extends State<OpenTicketActivity> {
  @override
  Widget build(BuildContext context) {
    // Scaffold holds pretty much the app bar and the body of a page
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Ticket'),
      ),
      body: OpenTicketForm(),
    );
  }
}
