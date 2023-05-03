import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jira_imitation_app/onstartactivity/uniqueuserdata.dart';

class TicketForm extends StatefulWidget {
  TicketForm({Key? key}) : super(key: key);
  @override
  TicketFormState createState() => TicketFormState();
}

class TicketFormState extends State<TicketForm> {
  var fields = {'mainCollection': 'tickets'};

  late bool isExistingTicket;
  late bool isTicketClosed = false;
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
  String description = "";
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

  void createTicket(
      String description, String category, String severity) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user!.uid;
    var time = DateTime.now();

    await FirebaseFirestore.instance
        .collection('newtickets')
        .doc(time.toString())
        .set({
      'description': description,
      'category': category,
      'severity': severity,
      'time': time.toString(),
      'creatorUid': uid,
    });

    Fluttertoast.showToast(msg: "Saved");
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
          .collection('newtickets')
          .doc(time)
          .update({
        'description': description,
        'category': category,
        'severity': severity,
      });
      Fluttertoast.showToast(msg: "Saved");
      print('Ticket updated successfully!');
    } catch (e) {
      print('Error updating ticket: $e');
    }
  }

  void moveTicketToMyQueue(String time, String text, String dropdowncategory,
      String dropdownseverity, String creatorUid) async {
    if (time.isEmpty) {
      time = DateTime.now().toString();
    }

    // makes a copy of the selected ticket and stores it in a queue specifically for the current user****
    FirebaseFirestore.instance
        .collection('tickets')
        .doc(uid)
        .collection('myTickets')
        .doc(time)
        .set({
      'description': text,
      'category': dropdowncategory,
      'severity': dropdownseverity,
      'time': time,
      'creatorUid': creatorUid,
      'ticketReviewerUid': uid,
    });

    // finaly removed the ticket from 'newtickets' which is shared amongst all users
    FirebaseFirestore.instance.collection('newtickets').doc(time).delete();
    Fluttertoast.showToast(msg: "Moved to my queue.");
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/main-menu',
          (route) => false,
    );
  }

  // this makes a copy of the selected ticket, makes a copy in a user specific queue,
  // IF THE USER IS A non-IT, and then deletes the ticket from the shared queue
  void closeTicket(String time, String text, String dropdowncategory,
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

    // removed the ticket from newTickets viewable by the user who closed the ticket
    FirebaseFirestore.instance.collection('newtickets').doc(time).delete();
    Fluttertoast.showToast(msg: "Moved to closed");
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/main-menu',
          (route) => false,
    );
  }

  ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    textStyle: const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
  );

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

    if (UniqueUserData.companyRole != 'IT' && isExistingTicket) {
      buttonStyle = buttonStyle.copyWith(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
      );
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
                    enabled: !isTicketClosed && UniqueUserData.companyRole != 'IT',
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
                      // Set onChanged to null to disable changing the selected value
                      onChanged: isTicketClosed
                          ? null
                          : (String? newValue) {
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
                      // Set onChanged to null to disable changing the selected value
                      onChanged: isTicketClosed
                          ? null
                          : (String? newValue) {
                        setState(() {
                          severityController.value = newValue!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (isExistingTicket)
                    Text.rich(
                      TextSpan(
                        text: 'Status: ',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        children: [
                          !isTicketClosed
                              ? const TextSpan(
                            text: 'Pending Review',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          )
                              : const TextSpan(
                            text: 'Closed',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (isExistingTicket)
                    const SizedBox(
                      height: 20,
                    ),
                  if (!isTicketClosed)
                    SizedBox(
                      height: 60,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: buttonStyle,
                        onPressed: () {
                          if (isExistingTicket) {
                            if (UniqueUserData.companyRole == 'IT') {
                              moveTicketToMyQueue(
                                  time,
                                  discriptionController.text,
                                  categoryController.value,
                                  severityController.value,
                                  creatorUid);
                            } else {
                              closeTicket(
                                  time,
                                  discriptionController.text,
                                  categoryController.value,
                                  severityController.value,
                                  creatorUid);
                            }
                          } else {
                            createTicket(
                                discriptionController.text.trim(),
                                categoryController.value,
                                severityController.value);
                          }
                        },
                        // ***** This will be both the create ticket for user side, and the move to open ticket on admin side***
                        child: Text(() {
                          if (UniqueUserData.companyRole == 'IT') {
                            return 'Move To My Ticket Queue';
                          } else {
                            if (isExistingTicket) {
                              return 'Close Ticket';
                            } else {
                              return 'Create New Ticket';
                            }
                          }
                        }()),
                      ),
                    ),
                  if (isExistingTicket &&
                      UniqueUserData.companyRole != 'IT' &&
                      !isTicketClosed)
                    const SizedBox(
                      height: 20,
                    ),
                  if (isExistingTicket &&
                      UniqueUserData.companyRole != 'IT' &&
                      !isTicketClosed)
                    SizedBox(
                      height: 60,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.teal),
                          textStyle: MaterialStateProperty.all<TextStyle>(
                              const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight
                                      .bold) // Change the font size to 20
                          ),
                        ),
                        onPressed: () {
                          updateTicket(
                              time,
                              description,
                              categoryController.value,
                              severityController.value);
                        },
                        // ***** This will be both the create ticket for user side, and the move to open ticket on admin side***
                        child: Text('Update Ticket'),
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