import 'package:flutter/material.dart';
import 'package:jira_imitation_app/ticketactivity/ticketform.dart';

class NotesForm extends StatefulWidget {
  const NotesForm({super.key});

  @override
  NotesFormState createState() => NotesFormState();
}

class NotesFormState extends State<NotesForm> {
  final notesController = TextEditingController();
  final messagesController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        child: Column(
          children: [
            const Positioned(
              child: Text(
                'Notes:',
                style: TextStyle(fontSize: 14),
              ),
            ),
            TextFormField(
              controller: notesController,
              minLines: 3,
              maxLines: null,
              decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.grey,
                  border: OutlineInputBorder(),
                  labelText: "Notes here..."),
            ),
            const SizedBox(
              height: 10,
            ),
            const Positioned(
              child: Text(
                'Messages:',
                style: TextStyle(fontSize: 14),
              ),
            ),
            TextFormField(
              controller: messagesController,
              minLines: 3,
              maxLines: null,
              decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.grey,
                  border: OutlineInputBorder(),
                  labelText: "Messages..."),
            ),
          ],
        ),
      ),
    );
  }
}
