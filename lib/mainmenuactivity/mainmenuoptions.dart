import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jira_imitation_app/onstartactivity/uniqueuserdata.dart';

class MenuView extends StatefulWidget {
  @override
  State<MenuView> createState() => MenuViewPageState();
}

Future<void> logOut(context) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  await auth.signOut();
  Navigator.pushNamed(context, '/login');
}

class MenuViewPageState extends State<MenuView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 60),
              const Text(
                'Welcome!',
                style: TextStyle(
                  fontSize: 40,
                ),
              ),
              Text(
                ' ${UniqueUserData.userName ?? ''}',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 80),
              SizedBox(
                width: 250,
                height: 60,
                child: ElevatedButton(
                  style: ButtonStyle(
                    textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(
                            fontSize: 20,
                            fontWeight:
                                FontWeight.bold) // Change the font size to 20
                        ),
                  ),
                  onPressed: () {
                    if (UniqueUserData.companyRole != 'IT') {
                      Navigator.pushNamed(context, '/ticket-form', arguments: {
                        'isExistingTicket': false,
                      });
                    } else {
                      Navigator.pushNamed(context, '/newticketlist');
                    }
                  },
                  child: Text(() {
                    if (UniqueUserData.companyRole == 'IT') {
                      return 'View New Tickets';
                    } else {
                      return 'Create Ticket';
                    }
                  }()),
                ),
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: 250,
                height: 60,
                child: ElevatedButton(
                  style: ButtonStyle(
                    textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(
                            fontSize: 20,
                            fontWeight:
                                FontWeight.bold) // Change the font size to 20
                        ),
                  ),
                  onPressed: () {
                    if (UniqueUserData.companyRole != 'IT') {
                      Navigator.pushNamed(context, '/newticketlist');
                    } else {
                      Navigator.pushNamed(context, '/ticketsInProgressList');
                    }
                  },
                  child: Text(() {
                    if (UniqueUserData.companyRole == 'IT') {
                      return 'View My Ticket Queue';
                    } else {
                      return 'View Open Tickets';
                    }
                  }()),
                ),
              ),
              const SizedBox(height: 50),

              SizedBox(
                width: 250,
                height: 60,
                child: ElevatedButton(
                  style: ButtonStyle(
                    textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(
                            fontSize: 20,
                            fontWeight:
                                FontWeight.bold) // Change the font size to 20
                        ),
                  ),
                  onPressed: () {
                    if (UniqueUserData.companyRole != 'IT') {
                      Navigator.pushNamed(context, '/closedticketlist');
                    } else {
                      Navigator.pushNamed(context, '/closedticketlist');
                      // NEED completed ticket queue
                    }
                  },
                  child: Text(() {
                    if (UniqueUserData.companyRole == 'IT') {
                      return 'View Completed Tickets';
                    } else {
                      return 'View Closed Tickets';
                    }
                  }()),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            tooltip: 'Logout',
            backgroundColor: Colors.teal,
            child: const Icon(Icons.exit_to_app),
            onPressed: () => logOut(context),
          ),
        ],
      ),
    );
  }
}
