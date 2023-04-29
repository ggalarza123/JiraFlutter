import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuView extends StatefulWidget {
  @override
  State<MenuView> createState() => MenuViewPageState();
}

class MenuViewPageState extends State<MenuView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Welcome!',
            style: TextStyle(
              fontSize: 40,
            ),
          ),
          const SizedBox(height: 150),
          SizedBox(
            width: 250,
            height: 60,
            child: ElevatedButton(
              style: ButtonStyle(
                textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(
                        fontSize: 20,
                        fontWeight:
                            FontWeight.bold) // Change the font size to 20
                    ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/ticket-form');
              },
              child: Text('Create Ticket'),
            ),
          ),
          const SizedBox(height: 50),
          SizedBox(
            width: 250,
            height: 60,
            child: ElevatedButton(
              style: ButtonStyle(
                textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(
                        fontSize: 20,
                        fontWeight:
                            FontWeight.bold) // Change the font size to 20
                    ),
              ),
              onPressed: () {
                // THIS NEEDS TO BE ADJUSTED SINCE IT TAKES US TO THE FORM FOR TESTING BUT NOT THE ACTUAL OPEN TICKETS
                Navigator.pushNamed(context, '/openticketform');
              },
              child: Text('View Open Tickets'),
            ),
          ),
          const SizedBox(height: 50),
          SizedBox(
            width: 250,
            height: 60,
            child: ElevatedButton(
              style: ButtonStyle(
                textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(
                        fontSize: 20,
                        fontWeight:
                            FontWeight.bold) // Change the font size to 20
                    ),
              ),
              onPressed: () {},
              child: Text('View Closed Tickets'),
            ),
          ),
        ],
      ),
    );
  }
}
