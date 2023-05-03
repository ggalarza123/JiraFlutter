import 'package:flutter/material.dart';
import 'package:jira_imitation_app/ticketactivity/ticketform.dart';

import 'notes.dart';

class NotesForm extends StatefulWidget {
  final String notes;

  const NotesForm({Key? key, required this.notes}) : super(key: key);
  @override
  NotesFormState createState() => NotesFormState();

}

class NotesFormState extends State<NotesForm> {
  late String notes;

  final messagesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final arguments =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    if (arguments['notes'] != null) {
      notes = arguments['notes'];
    }
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
              initialValue: notes,
              minLines: 3,
              maxLines: null,
              decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.grey,
                  border: OutlineInputBorder(),
                  labelText: "Notes here..."),
              onChanged: (value) {
                setState(() {
                  Notes.notes = value;

                });
              },
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
              minLines: 1,
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