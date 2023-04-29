import 'package:flutter/material.dart';
import 'package:jira_imitation_app/ticketactivity/ticketform.dart';

class OpenTicketForm extends StatefulWidget {
  const OpenTicketForm({super.key});
  @override
  OpenTicketFormState createState() => OpenTicketFormState();
}

class OpenTicketFormState extends State<OpenTicketForm> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListView(
        children: [
          Container(
            child: Form(
              child: Column(
                children: [
                  TicketForm(),
                  // rest of new widgets here*******
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
