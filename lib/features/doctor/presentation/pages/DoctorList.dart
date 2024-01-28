import 'dart:convert';

import 'package:clinica/features/auth/presentation/domain/entities/User.dart';
import 'package:clinica/features/patients/data/PatientDb.dart';
import 'package:flutter/material.dart';

class DoctorList extends StatefulWidget {
  const DoctorList({super.key});

  @override
  State<DoctorList> createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
  late Future<List<User>> _patientsFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _patientsFuture = _fetchPatients();
  }

  PatientDb patientDb = PatientDbImpl();

  Future<List<User>> _fetchPatients() async {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            "Doctos List",
            style: TextStyle(fontSize: 20),
          ),
          FutureBuilder<List<User>>(
            future: _patientsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                return Column(
                  children: [
                    for (final patient in snapshot.data!)
                      Card(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          title: Text(
                              '${patient.firstName} ${patient.secondName}'),
                          subtitle: Text(
                              'Email: ${patient.email}, Age: ${patient.age}'),
                        ),
                      ),
                  ],
                );
              } else {
                return const Center(child: Text('No doctors available'));
              }
            },
          ),
        ],
      ),
    );
  }
}
