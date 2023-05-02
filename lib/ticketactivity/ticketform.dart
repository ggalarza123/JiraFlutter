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
  late String description;
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

  void createTicket(
      String description, String category, String severity) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user!.uid;
    var time = DateTime.now();

    await FirebaseFirestore.instance.collection('newtickets').doc(time.toString()).set({
      'description': description,
      'category': category,
      'severity': severity,
      'time': time.toString(),
    });

    Fluttertoast.showToast(msg: "Saved");
    Navigator.pushNamed(context, '/main-menu');
  }

  void moveTicketToMyQueue(
    String time,
    String text,
    String dropdowncategory,
    String dropdownseverity,
  ) async {
    if (time.isEmpty) {
      time = DateTime.now().toString();
    }
    print('does pass here 1.');
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
    });
    print('does pass here 2.');
    // makes a copy of the selected ticket and stores it in a que that can be viewed by all users****
    FirebaseFirestore.instance.collection('ticketsInReview').add({
      'description': text,
      'category': dropdowncategory,
      'severity': dropdownseverity,
      'time': time,
    });
    print('does pass here 3.');
    // finaly removed the ticket from 'newtickets' which is shared amongst all users
    FirebaseFirestore.instance
        .collection('newtickets')
        .doc(time)
        .delete();
    Fluttertoast.showToast(msg: "Moved to my queue.");
    Navigator.pushNamed(context, '/main-menu');
    print('does pass here 4.');
  }

  // this makes a copy of the selected ticket, makes a copy in a user specific queue,
  // IF THE USER IS A non-IT, and then deletes the ticket from the shared queue
  void closeTicket(
    String time,
    String text,
    String dropdowncategory,
    String dropdownseverity,
  ) async {
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
    });

    // removed the ticket from newTickets viewable by all**
    FirebaseFirestore.instance
        .collection(fields['mainCollection']!)
        .doc(uid)
        .collection('newtickets')
        .doc(time)
        .delete();
    Fluttertoast.showToast(msg: "Moved to closed.");
    Navigator.pushNamed(context, '/main-menu');
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    isExistingTicket = arguments['isExistingTicket'] ?? false;
    print(arguments['description']);
    print(arguments['category']);
    print(arguments['severity']);
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
                    controller: discriptionController,
                    minLines: 2,
                    maxLines: null,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter a description";
                      }
                      return null;
                    },
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
                        // or just
                        // categoryController.value = newValue!;
                        // without the setState method
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
                  if (!isTicketClosed)
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
                          if (isExistingTicket) {
                            if (UniqueUserData.companyRole == 'IT') {
                              moveTicketToMyQueue(
                                  time,
                                  discriptionController.text,
                                  dropdowncategory,
                                  dropdownseverity);
                            } else {
                              closeTicket(time, discriptionController.text,
                                  dropdowncategory, dropdownseverity);
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
                  const SizedBox(
                    height: 20,
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
