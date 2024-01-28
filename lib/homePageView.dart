import 'dart:convert';

import 'package:clinica/features/appointments/data/appointmentsDb.dart';
import 'package:clinica/features/appointments/domain/entities/appointments.dart';
import 'package:clinica/features/appointments/presentation/widgets/addAppointment.dart';
import 'package:clinica/features/appointments/presentation/widgets/appointmentsTable.dart';
import 'package:clinica/features/appointments/presentation/widgets/requestAppointment.dart';
import 'package:clinica/features/auth/presentation/domain/entities/User.dart';
import 'package:clinica/features/patients/data/PatientDb.dart';
import 'package:flutter/material.dart';

class HomePageView extends StatefulWidget {
  bool isStaff;
  HomePageView({super.key, required this.isStaff});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  PatientDb patientDb = PatientDbImpl();
  AppointmentsDb appointmentsDb = AppointmentsDbImpl();
  void fetchData() async {
    List<User> doctors = await _fetchDoctors();
    List<User> patients = await _fetchPatients();
    List<Appointments> appointments =
        await appointmentsDb.getAppointments(null);
    setState(() {
      nbPatients = patients.length;
      nbDoctors = doctors.length;
      nbAppointments = appointments.length;
    });
  }

  Future<List<User>> _fetchPatients() async {
    final response = await patientDb.getPatients();
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      // Filter patients based on role "doctor"
      final List<User> doctors = data
          .map((json) => User.fromJson(json))
          .where((user) => user.role == "patient")
          .toList();
      return doctors;
    } else {
      throw Exception('Failed to fetch patients');
    }
  }

  Future<List<User>> _fetchDoctors() async {
    final response = await patientDb.getPatients();
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      // Filter patients based on role "doctor"
      final List<User> doctors = data
          .map((json) => User.fromJson(json))
          .where((user) => user.role == "doctor")
          .toList();
      return doctors;
    } else {
      throw Exception('Failed to fetch patients');
    }
  }

  int nbDoctors = 0;
  int nbPatients = 0;
  int nbAppointments = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Dashboard",
              style: TextStyle(fontSize: 30),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(30),
          width: MediaQuery.of(context).size.width * 0.6,
          height: 150,
          decoration: const BoxDecoration(
              // color: Color.fromARGB(255, 151, 208, 255),
              gradient: LinearGradient(
                  colors: [Color.fromARGB(255, 151, 208, 255), Colors.purple],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight),
              borderRadius: BorderRadius.all(Radius.circular(50))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RichText(
                  text: const TextSpan(
                      text: "4  ",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                      children: [
                    TextSpan(
                        text: "Departement", style: TextStyle(fontSize: 15))
                  ])),
              RichText(
                  text: TextSpan(
                      text: "${nbAppointments.toString()}  ",
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                      children: const [
                    TextSpan(
                        text: "Appointments", style: TextStyle(fontSize: 15))
                  ])),
              RichText(
                  text: TextSpan(
                      text: "${nbPatients.toString()}  ",
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                      children: const [
                    TextSpan(text: "Patient", style: TextStyle(fontSize: 15))
                  ])),
              RichText(
                  text: TextSpan(
                      text: "$nbDoctors  ",
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                      children: const [
                    TextSpan(text: "Doctor", style: TextStyle(fontSize: 15))
                  ])),
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "your appointments",
                style: TextStyle(fontSize: 30),
              ),
              ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => Dialog(
                            child: widget.isStaff
                                ? AddAppointmentPage()
                                : const RequestAppointment())).then((value) {
                      setState(() {});
                    });
                  },
                  child: const Text("ADD"))
            ],
          ),
        ),
        Center(
            child: AppointmentsTable(
          isStaff: true,
        ))
      ],
    );
  }
}
