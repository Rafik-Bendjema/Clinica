import 'package:clinica/data.dart';
import 'package:clinica/features/auth/presentation/pages/SignUp.dart';
import 'package:clinica/features/auth/presentation/pages/authPage.dart';

import 'package:clinica/features/doctor/presentation/pages/DoctorList.dart';
import 'package:clinica/features/patients/presentation/pages/PatientsList.dart';
import 'package:clinica/features/record/presentation/pages/RecordPage.dart';
import 'package:clinica/homePageView.dart';
import 'package:flutter/material.dart';

class StaffHomeView extends StatefulWidget {
  const StaffHomeView({super.key});

  @override
  State<StaffHomeView> createState() => _StaffHomeViewState();
}

class _StaffHomeViewState extends State<StaffHomeView> {
  @override
  void initState() {
    super.initState();
  }

  final List<Widget> _pages = [
    HomePageView(
      isStaff: true,
    ),
    const PatientsList(),
    const DoctorList()
  ];

  String role = "staff";
  final DataTableSource _data = MyData();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(40),
          height: MediaQuery.of(context).size.height,
          width: 300,
          decoration:
              const BoxDecoration(color: Color.fromARGB(255, 182, 182, 182)),
          child: Column(children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage("assets/images/profile.jpg"))),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              role,
              style: const TextStyle(color: Colors.blue),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ButtonStyle(
                  shadowColor: MaterialStateColor.resolveWith(
                      (states) => Colors.transparent),
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => Colors.transparent)),
              onPressed: () {
                setState(() {
                  index = 0;
                });
              },
              child: Container(
                height: 50,
                width: 200,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 151, 208, 255),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: const Center(
                  child: Text("Home"),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ButtonStyle(
                  shadowColor: MaterialStateColor.resolveWith(
                      (states) => Colors.transparent),
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => Colors.transparent)),
              onPressed: () {
                setState(() {
                  index = 2;
                });
              },
              child: Container(
                height: 50,
                width: 200,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 151, 208, 255),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: const Center(
                  child: Text("Doctor list"),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ButtonStyle(
                  shadowColor: MaterialStateColor.resolveWith(
                      (states) => Colors.transparent),
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => Colors.transparent)),
              onPressed: () {
                setState(() {
                  index = 1;
                });
              },
              child: Container(
                height: 50,
                width: 200,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 151, 208, 255),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: const Center(
                  child: Text("patinets list"),
                ),
              ),
            ),
            const Expanded(child: SizedBox()),
            SizedBox(
                height: 200,
                child: Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shadowColor: MaterialStateColor.resolveWith(
                            (states) => Colors.transparent),
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.transparent)),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AuthPage()));
                    },
                    child: Container(
                      height: 50,
                      width: 200,
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 151, 208, 255),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: const Center(
                        child: Text("logout"),
                      ),
                    ),
                  ),
                )),
          ]),
        ),
        Expanded(
            child: Container(
          padding: const EdgeInsets.all(60),
          child: SingleChildScrollView(child: _pages[index]),
        ))
      ],
    ));
  }
}
