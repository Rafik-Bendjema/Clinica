import 'package:clinica/features/Staff/presentation/pages/home/StaffViewHome.dart';
import 'package:clinica/homePage.dart';
import 'package:flutter/material.dart';

class AuthDivider extends StatefulWidget {
  String role;
  AuthDivider({super.key, required this.role});

  @override
  State<AuthDivider> createState() => _AuthDividerState();
}

class _AuthDividerState extends State<AuthDivider> {
  late String role;
  @override
  void initState() {
    role = widget.role.replaceAll('"', "");
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("i am in the divider and this is the role $role");
    if (role == "doctor") {
      print("m here");
      return const StaffHomeView();
    }
    return const HomePage();
  }
}
