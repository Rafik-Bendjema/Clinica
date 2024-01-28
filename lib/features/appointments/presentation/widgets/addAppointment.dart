import 'dart:convert';

import 'package:clinica/features/appointments/data/appointmentsDb.dart';
import 'package:clinica/features/appointments/domain/entities/appointments.dart';
import 'package:clinica/features/appointments/domain/entities/request.dart';
import 'package:clinica/features/appointments/presentation/widgets/requestAppointment.dart';
import 'package:clinica/features/auth/presentation/domain/entities/User.dart';
import 'package:clinica/features/patients/data/PatientDb.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AddAppointmentPage extends StatefulWidget {
  AppointmentRequest? r;
  AddAppointmentPage({Key? key, this.r})
      : super(
          key: key,
        );

  @override
  _AddAppointmentPageState createState() => _AddAppointmentPageState();
}

class _AddAppointmentPageState extends State<AddAppointmentPage> {
  List<String> statusList = ["scheduled", "canceled", "completed"];
  @override
  void initState() {
    r = widget.r;
    checkRequest();
    super.initState();
    fetchdata();
  }

  AppointmentRequest? r;
  void checkRequest() {
    if (r != null) {
      setState(() {
        selectedPatient = r!.patient;
        date = r!.date;
      });
    }
  }

  void fetchdata() async {
    users = await _fetchUsers();
    setState(() {});
    print("here is the user length ${users.length}");
  }

  PatientDb patientDb = PatientDbImpl();
  AppointmentsDb appointmentsDb = AppointmentsDbImpl();
  Future<List<User>> _fetchUsers() async {
    final response = await patientDb.getPatients();
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<User> patients =
          data.map((json) => User.fromJson(json)).toList();
      return patients;
    } else {
      throw Exception('Failed to fetch patients');
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController();
  TextEditingController roomController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController patientController = TextEditingController();

  List<User> users = [];
  String? comment;
  String? selectedPatient;
  String? selectedDoctor;
  late String room;
  String status = "scheduled";
  String notes = "";
  DateTime? date;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Appointments appointment = Appointments(
          date: date!,
          doctor: selectedDoctor!,
          note: notes,
          patient: selectedPatient!,
          room: room,
          status: status);
      print("here is the class ${appointment.toJson()}");
      Response result = await appointmentsDb.addAppointment(appointment);
      if (result.statusCode == 200) {
        Navigator.pop(context);
        if (r != null) {
          await appointmentsDb.deleteRequest(r!.id.toString());
          setState(() {});
        }
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
      appBar: AppBar(
        title: const Text('Add Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              comment == null
                  ? const SizedBox()
                  : Text(
                      comment!,
                      style: const TextStyle(color: Colors.red, fontSize: 20),
                    ),
              Row(
                children: [
                  Text(
                      "picked date ${date == null ? "" : date.toString().split(" ").first}"),
                  const SizedBox(
                    width: 50,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        DateTime? picked;
                        picked = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate:
                                DateTime.now().add(const Duration(days: 365)));
                        if (picked != null) {
                          setState(() {
                            date = picked!;
                          });
                        }
                      },
                      child: const Text("PICK DATE")),
                ],
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedPatient,
                hint: const Text('Patient'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedPatient = newValue!;
                  });
                },
                items: users
                    .where((user) => user.role == "patient")
                    .map((User option) {
                  return DropdownMenuItem<String>(
                    value: option.id
                        .toString(), // Assuming id is the value you want to use
                    child:
                        Text(option.firstName), // Displaying user's first name
                  );
                }).toList(),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a patient.';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              DropdownButtonFormField<String>(
                value: selectedDoctor,
                hint: const Text('doctor'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDoctor = newValue!;
                  });
                },
                items: users
                    .where((user) => user.role == "doctor")
                    .map((User option) {
                  return DropdownMenuItem<String>(
                    value: option.id
                        .toString(), // Assuming id is the value you want to use
                    child:
                        Text(option.firstName), // Displaying user's first name
                  );
                }).toList(),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a patient.';
                  }
                  return null;
                },
              ),
              DropdownButton<String>(
                value: status, // Default value
                onChanged: (String? newValue) {
                  // Handle dropdown value change
                  print(newValue);
                },
                items: statusList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              TextFormField(
                controller: roomController,
                decoration: const InputDecoration(labelText: 'Room'),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "this field can't be null";
                  }
                  return null;
                },
                onSaved: (val) {
                  room = val!;
                },
                // Add additional notes validation if needed
              ),
              TextFormField(
                controller: notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
                onSaved: (val) {
                  if (val != null) {
                    notes = val;
                  }
                },
                // Add additional notes validation if needed
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _submitForm();
                },
                child: const Text('Add Appointment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
