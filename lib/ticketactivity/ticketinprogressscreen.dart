import "package:flutter/material.dart";
import "package:jira_imitation_app/ticketactivity/ticketinprogressform.dart";

class ExistingTicketInTheWorksActivity extends StatefulWidget {
  @override
  ExistingTicketInTheWorksActivityState createState() => ExistingTicketInTheWorksActivityState();
}

// Pretty much every state will return a widget
class ExistingTicketInTheWorksActivityState extends State<ExistingTicketInTheWorksActivity> {
  @override
  Widget build(BuildContext context) {
    // Scaffold holds pretty much the app bar and the body of a page
    return Scaffold(
      appBar: AppBar(
        title: Text('Tickets In Queue'),
      ),
      body: TicketInProgressForm(),
    );
  }
}
