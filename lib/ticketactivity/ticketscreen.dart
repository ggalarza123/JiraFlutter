import "package:flutter/material.dart";
import "package:jira_imitation_app/ticketactivity/ticketform.dart";

class AddTicketActivity extends StatefulWidget {
  @override
  _ticketState createState() => _ticketState();
}

// Pretty much every state will return a widget
class _ticketState extends State<AddTicketActivity> {
  @override
  Widget build(BuildContext context) {
    // Scaffold holds pretty much the app bar and the body of a page
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket'),
      ),
      body: TicketForm(),
    );
  }
}
