import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TicketForm extends StatefulWidget {
  const TicketForm({super.key});
  @override
  TicketFormState createState() => TicketFormState();
}

class TicketFormState extends State<TicketForm> {
  final _formkey = GlobalKey<FormState>();
// Initial Selected Value
  String dropdownvalue = 'Bug';
  String dropdownvalue2 = 'Low';
  final discriptionController = TextEditingController();
  final categoryController = ValueNotifier<String>("Bug");
  final severityController = ValueNotifier<String>("Low");

  // List of items in our dropdown menu
  var items = [
    'Bug',
    'Incident',
    'Task',
    'Sub-Task',
    'Company wide',
    'Underwriting'
  ];

  var items2 = ['Low', 'Medium', 'High', 'Urgent', 'Catastrophe'];

  void createTicket(
      String description, String category, String severity) async {
    await FirebaseFirestore.instance.collection('newtickets').add({
      'description': description,
      'category': category,
      'severity': severity,
    });

    // final validity = _formkey.currentState!.validate();
    // FirebaseAuth auth = FirebaseAuth.instance;
    // final User? user = auth.currentUser;
    // final uid = user!.uid;
    // var time = DateTime.now();
    // await FirebaseFirestore.instance
    //     .collection('tickets')
    //     .doc(uid)
    //     .collection('newtickets')
    //     .doc(time.toString())
    //     .set({
    //   'description': ticketDiscriptionController.text,
    //   'category': categoryController.value,
    //   'severity': severityController.value,
    // });
  }

  @override
  Widget build(BuildContext context) {
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
                      items: items.map((String items) {
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
                      dropdownColor: const Color.fromRGBO(
                          231, 232, 232, 1.0),
                      isExpanded: true,
                      // Array list of items
                      items: items2.map((String items) {
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
                        createTicket(discriptionController.text.trim(),
                            categoryController.value, severityController.value);
                      },
                      // ***** This will be both the create ticket for user side, and the move to open ticket on admin side***
                      child: Text('CREATE TICKET'),
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
