import 'dart:ui';

import 'package:clinica/AuthDevider.dart';
import 'package:clinica/features/auth/presentation/data/AuthLogic.dart';
import 'package:clinica/features/auth/presentation/pages/SignUp.dart';
import 'package:clinica/homePage.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  String? comment;
  late String email;
  late String pwd;
  final _formKey = GlobalKey<FormState>();

  AuthLogic authLogic = AuthLogicImpl();
  void login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var result = await authLogic.login(email, pwd);
      if (result.statusCode == 200) {
        print("this is the return of the login ${result.body}");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AuthDivider(
                      role: result.body,
                    )));
      } else {
        setState(() {
          comment = result.body;
        });
      }
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
                    height: 500,
                    width: 500,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          comment == null
                              ? const SizedBox(
                                  height: 0,
                                )
                              : Text(
                                  comment!.replaceAll('"', ""),
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 20),
                                ),
                          const Text(
                            "Login",
                            style: TextStyle(fontSize: 30, color: Colors.blue),
                          ),
                          const SizedBox(
                            height: 70,
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
                                hintText: "Email",
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
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: const InputDecoration(
                                hintText: "Password",
                                filled: true,
                                fillColor: Color.fromARGB(255, 164, 164, 164)),
                          ),
                          Expanded(
                              child: Center(
                            child: ElevatedButton(
                                onPressed: () async {
                                  login();
                                },
                                child: const Text("login")),
                          )),
                          SizedBox(
                              height: 70,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("you don't have account ?  "),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const SignUp()));
                                      },
                                      child: const Text("Sign up"))
                                ],
                              ))
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
