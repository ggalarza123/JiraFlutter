import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
// ggala
// fake4@gmail.com
// 123gg123GG!@

// 123gg
// fake9@gmail.com
// 123gg123GG!@

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});
  @override
  AuthFormState createState() => AuthFormState();
}

class AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();

  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final roleController = ValueNotifier<String>("IT");

  var items3 = ['IT', 'Operations', 'Management-Non-IT'];
  bool isLoginPage = false;

  authenticate() {
    final validity = _formkey.currentState!.validate();
    if (validity) {
      if (isLoginPage) {
        signIn();
      } else {
        signUp();
      }
    }
  }

  Future signUp() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim());

    addUserDetails(emailController.text.trim(), userNameController.text.trim(),
        roleController.value.trim());
  }

  Future addUserDetails(String email, String username, String role) async {
    await FirebaseFirestore.instance.collection('userdetails').add({
      'email': email,
      'username': username,
      'company-role': role,
      'userID': FirebaseAuth.instance.currentUser?.uid,
    });
    Navigator.pushNamed(context, '/main-menu');
  }

  // NEW code
  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // Login successful, navigate to home screen or perform other actions
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: "Incorrect username or password.");
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
              key: _formkey,
              child: Column(
                children: [
                  if (!isLoginPage)
                    TextFormField(
                      controller: userNameController,
                      keyboardType: TextInputType.name,
                      key: const ValueKey('username'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'username is required';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Enter UserName"),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    key: const ValueKey('email'),
                    validator: (value) {
                      final bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value!);
                      if (!emailValid) {
                        return "Enter valid email address";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Enter Email Address"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    key: const ValueKey('password'),
                    validator: (value) {
                      final bool emailValid = RegExp(
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                          .hasMatch(value!);
                      if (!emailValid) {
                        return "Enter valid Password";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Enter Password"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (!isLoginPage)
                    const Positioned(
                      child: Text(
                        'What is your company role:',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  if (!isLoginPage)
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
                        value: roleController.value,
                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),
                        dropdownColor: const Color.fromRGBO(231, 232, 232, 1.0),
                        isExpanded: true,
                        // Array list of items
                        items: items3.map((String items) {
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
                            roleController.value = newValue!;
                          });
                        },
                      ),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        authenticate();
                        // signIn();
                      },
                      child: isLoginPage
                          ? const Text('Login')
                          : const Text('Signup'),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLoginPage = !isLoginPage;
                      });
                    },
                    child: isLoginPage
                        ? const Text('Not a Member?')
                        : const Text('Already a Member?'),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
