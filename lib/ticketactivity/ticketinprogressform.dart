import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../onstartactivity/uniqueuserdata.dart';
import 'notes.dart';
import 'notesform.dart';

class TicketInProgressForm extends StatefulWidget {
  TicketInProgressForm({Key? key}) : super(key: key);
  @override
  TicketInProgressFormState createState() => TicketInProgressFormState();
}

class TicketInProgressFormState extends State<TicketInProgressForm> {
  late bool isExistingTicket = true;
  late bool isTicketClosed = false;
  String description = "";
  late String creatorUid;
// Initial Selected Value
  String dropdowncategory = 'Bug';
  String dropdownseverity = 'Low';
  String time = "";
  final discriptionController = TextEditingController();
  late final categoryController = ValueNotifier<String>(dropdowncategory);
  late final severityController = ValueNotifier<String>(dropdownseverity);
// List of items in our dropdown menu
  var categoryList = [
    'Bug',
    'Incident',
    'Task',
    'Sub-Task',
    'Company wide',
    'Underwriting'
  ];

  var severityList = ['Low', 'Medium', 'High', 'Urgent', 'Catastrophe'];
  String companyRole = "";
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
  void moveToCompletedTickets(String time, String text, String dropdowncategory,
      String dropdownseverity, String creatorUid) async {
    if (time.isEmpty) {
      time = DateTime.now().toString();
    }

    // moves the ticket to a closed tickets viewable specifically by the current user
    FirebaseFirestore.instance
        .collection('tickets')
        .doc(uid)
        .collection('closedTickets')
        .doc(time)
        .set({
      'description': text,
      'category': dropdowncategory,
      'severity': dropdownseverity,
      'time': time,
      'creatorUid': creatorUid,
      'closerUid': uid,
    });
    // move the ticket to a closed tickets viewable specifically by the user who create it
    FirebaseFirestore.instance
        .collection('tickets')
        .doc(creatorUid)
        .collection('closedTickets')
        .doc(time)
        .set({
      'description': text,
      'category': dropdowncategory,
      'severity': dropdownseverity,
      'time': time,
      'creatorUid': creatorUid,
      'closerUid': uid,
    });

    // removed the ticket from newTickets viewable by all**
    FirebaseFirestore.instance
        .collection(fields['mainCollection']!)
        .doc(uid)
        .collection('myTickets')
        .doc(time)
        .delete();
    Fluttertoast.showToast(msg: "Moved to completed");
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/main-menu',
      (route) => false,
    );
  }

  Future<void> updateTicket(
      String time, String description, String category, String severity) async {
    try {
      await FirebaseFirestore.instance
          .collection(fields['mainCollection']!)
          .doc(uid)
          .collection('myTickets')
          .doc(time)
          .update({
        'description': discriptionController.text.trim(),
        'category': category,
        'severity': severity,
        'notes': Notes.notes,
      });
      Fluttertoast.showToast(msg: "Updates saved!");
      print('Ticket updated successfully!');
    } catch (e) {
      print('Error updating ticket: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    isExistingTicket = arguments['isExistingTicket'] ?? false;
    if (isExistingTicket) {
      discriptionController.text = arguments['description'];
      dropdowncategory = arguments['category'];
      dropdownseverity = arguments['severity'];
      if (arguments['time'] != null) {
        time = arguments['time'];
      }
      if (arguments['isTicketClosed'] != null) {
        isTicketClosed = arguments['isTicketClosed'];
      }
      if (arguments['creatorUid'] != null) {
        creatorUid = arguments['creatorUid'];
      } else {
        // early ticket, had no creator field
        creatorUid = "No creator saved";
      }
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Form(
              child: Column(
                children: [
                  const Text(
                    'Ticket',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Positioned(
                    child: Text(
                      'Describe the issue/bug:',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  TextFormField(
                    minLines: 2,
                    maxLines: null,
                    onChanged: (value) {
                      // Update the class variable
                      description = value;
                      // Update the controller with the new value entered by the user
                      discriptionController.text = value;
                    },
                    // the description can only be edited by the creator of the ticket, severity level and ticket catgeory can be edited by either
                    enabled:
                        !isTicketClosed && UniqueUserData.companyRole != 'IT',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter a description";
                      }
                      return null;
                    },
                    initialValue: arguments['description'] ?? '',
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Enter a description"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Positioned(
                    child: Text(
                      'Select a category:',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(4.0),
                      ),
                    ),
                    child: DropdownButton(
                      // Initial Value
                      value: categoryController.value,
                      // Down Arrow Icon
                      icon: const Icon(Icons.keyboard_arrow_down),
                      dropdownColor: Colors.grey,
                      isExpanded: true,
                      // Array list of items
                      items: categoryList.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) {
                        setState(() {
                          categoryController.value = newValue!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Positioned(
                    child: Text(
                      'Severity level:',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(4.0),
                      ),
                    ),
                    child: DropdownButton(
                      // Initial Value
                      value: severityController.value,
                      // Down Arrow Icon
                      icon: const Icon(Icons.keyboard_arrow_down),
                      dropdownColor: const Color.fromRGBO(231, 232, 232, 1.0),
                      isExpanded: true,
                      // Array list of items
                      items: severityList.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) {
                        setState(() {
                          severityController.value = newValue!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        textStyle: MaterialStateProperty.all<TextStyle>(
                            const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight
                                    .bold) // Change the font size to 20
                            ),
                      ),
                      onPressed: () {
                        updateTicket(time, description,
                            categoryController.value, severityController.value);
                      },
                      // ***** This will be both the create ticket for user side, and the move to open ticket on admin side***
                      child: Text('Save updated ticket'),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  NotesForm(notes: Notes.notes),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        textStyle: MaterialStateProperty.all<TextStyle>(
                            const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight
                                    .bold) // Change the font size to 20
                            ),
                      ),
                      onPressed: () {
                        Fluttertoast.showToast(
                            msg: "Currently not available",
                            toastLength: Toast.LENGTH_SHORT);
                      },
                      // ***** This will be both the create ticket for user side, and the move to open ticket on admin side***
                      child: Text('Send Creator Of Ticket A Message'),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        textStyle: MaterialStateProperty.all<TextStyle>(
                            const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight
                                    .bold) // Change the font size to 20
                            ),
                      ),
                      onPressed: () {
                        if (description.isEmpty || description == null) {
                          description = discriptionController.text.trim();
                        }
                        moveToCompletedTickets(
                            time,
                            description,
                            categoryController.value,
                            severityController.value,
                            creatorUid);
                      },
                      // ***** This will be both the create ticket for user side, and the move to open ticket on admin side***
                      child: Text('Move To Completed'),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
