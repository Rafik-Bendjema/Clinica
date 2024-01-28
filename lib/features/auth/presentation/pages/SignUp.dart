import 'dart:ui';

import 'package:clinica/features/auth/presentation/data/AuthLogic.dart';
import 'package:clinica/features/auth/presentation/domain/entities/User.dart';
import 'package:clinica/homePage.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  AuthLogic authLogic = AuthLogicImpl();

  late String email;
  late String pwd;
  late String fname;
  late String sname;
  late int age;
  final _formKey = GlobalKey<FormState>();

  void signUp() async {
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        User user = User(
            firstName: fname,
            secondName: sname,
            email: email,
            pwd: pwd,
            role: "patient",
            age: age);
        User? result = await authLogic.signup(user);

        if (result != null) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        }
      }
    } on Exception catch (e) {
      print("here is the exception ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Blur
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 1.0, sigmaY: 1.0), // Adjust blur intensity
            child: Container(
              color: Colors.black
                  .withOpacity(0.3), // Adjust overlay color and opacity
            ),
          ),

          // Content
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(color: Colors.blue),
                child: Row(
                  children: [
                    const Text(
                      "Clinica",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      width: 500,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: const Text("Contact Us"),
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text("about us"),
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text("report"),
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 500,
                    width: 500,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            "welcome to clinica platform",
                            style: TextStyle(
                                fontSize: 30,
                                color: Color.fromARGB(255, 8, 144, 255)),
                          ),
                          Image.asset(
                            "assets/images/logo.png",
                            width: 300,
                          ),
                        ]),
                  ),
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      color: Color.fromARGB(47, 0, 0, 0),
                    ),
                    width: 500,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Text(
                            "Sign up",
                            style: TextStyle(fontSize: 30, color: Colors.blue),
                          ),
                          const SizedBox(
                            height: 70,
                          ),
                          TextFormField(
                            onSaved: (val) {
                              fname = val!;
                            },
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "this field can't be empty";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                hintText: "First name",
                                filled: true,
                                fillColor: Color.fromARGB(255, 164, 164, 164)),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            onSaved: (val) {
                              sname = val!;
                            },
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "this field can't be empty";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                hintText: "Second name",
                                filled: true,
                                fillColor: Color.fromARGB(255, 164, 164, 164)),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            onSaved: (val) {
                              email = val!;
                            },
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "this field can't be empty";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                hintText: "email",
                                filled: true,
                                fillColor: Color.fromARGB(255, 164, 164, 164)),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            onSaved: (val) {
                              age = int.parse(val!);
                            },
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "this field can't be empty";
                              }
                              if (int.tryParse(val) == null) {
                                return "this field has to be numeric value";
                              }
                              if (int.parse(val) < 0) {
                                return "this field can't be negative";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                hintText: "age",
                                filled: true,
                                fillColor: Color.fromARGB(255, 164, 164, 164)),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            onSaved: (val) {
                              pwd = val!;
                            },
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "this field can't be empty";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                hintText: "Password",
                                filled: true,
                                fillColor: Color.fromARGB(255, 164, 164, 164)),
                          ),
                          Expanded(
                              child: Center(
                            child: ElevatedButton(
                                onPressed: () async {
                                  signUp();
                                },
                                child: const Text("Sign up")),
                          )),
                        ],
                      ),
                    ),
                  )
                ],
              ))
            ],
          ),
        ],
      ),
    );
  }
}
