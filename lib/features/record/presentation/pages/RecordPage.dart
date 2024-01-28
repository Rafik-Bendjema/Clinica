import 'dart:convert';

import 'package:clinica/features/auth/presentation/data/currentUser.dart';
import 'package:clinica/features/record/data/RecordDb.dart';
import 'package:clinica/features/record/domain/entities/Record.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class RecordPage extends StatefulWidget {
  String? id;
  RecordPage({super.key, this.id});

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  bool _isEditingEnabled = true;

  @override
  void initState() {
    getRecord();
    super.initState();
  }

  void getRecord() async {
    String id;
    if (widget.id == null) {
      id = widget.id!;
    } else {
      id = userId.toString();
    }
    Response result = await recordDb.getRecord(id);
    if (result.statusCode == 200) {
      final parsed = jsonDecode(result.body).cast<Map<String, dynamic>>();
      List<MedicalRecord> records = parsed
          .map<MedicalRecord>((json) => MedicalRecord.fromJson(json))
          .toList();
      MedicalRecord? m = records.isNotEmpty ? records.first : null;

      if (m != null) {
        setState(() {
          _firstNameController.text = m.firstName;
          _secondNameController.text = m.lastName;
          _ageController.text = m.age;
          _phoneNumberController.text = m.phoneNumber;
          _chronicDiseasesController.text = m.chronicDiseases;
          _birthdayController.text = m.birthday;
          _birthdayPlaceController.text = m.birthdayPlace;
          _bloodTypeController.text = m.bloodType;
          _parentsDiseaseController.text = m.parentsDisease;
          _marriageController.text = m.marriageStatus;

          // Disable editing
          _isEditingEnabled = false;
        });
      }
    } else if (result.statusCode == 404) {
      setState(() {
        comment = jsonDecode(result.body)["message"];
      });
    }
  }

  RecordDb recordDb = RecordDbImpl();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _secondNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _chronicDiseasesController =
      TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _birthdayPlaceController =
      TextEditingController();
  final TextEditingController _bloodTypeController = TextEditingController();
  final TextEditingController _parentsDiseaseController =
      TextEditingController();
  final TextEditingController _marriageController = TextEditingController();
  String? comment;
  void saveRecord() async {
    final String firstName = _firstNameController.text;
    final String secondName = _secondNameController.text;
    final int age = int.tryParse(_ageController.text) ?? 0;
    final String phoneNumber = _phoneNumberController.text;
    final String chronicDiseases = _chronicDiseasesController.text;
    final String birthday = _birthdayController.text;
    final String birthdayPlace = _birthdayPlaceController.text;
    final String bloodType = _bloodTypeController.text;
    final String parentsDisease = _parentsDiseaseController.text;
    final String marriage = _marriageController.text;

    MedicalRecord r = MedicalRecord(
        patient: userId.toString(),
        firstName: firstName,
        lastName: secondName,
        age: age.toString(),
        phoneNumber: phoneNumber,
        chronicDiseases: chronicDiseases,
        birthday: birthday,
        birthdayPlace: birthdayPlace,
        bloodType: bloodType,
        parentsDisease: parentsDisease,
        marriageStatus: marriage);

    Response result = await recordDb.addRecord(r);

    if (result.statusCode == 200) {
      showDialog(
          context: context,
          builder: (context) => const Dialog(
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Center(
                    child: Text("succes"),
                  ),
                ),
              ));
    } else {
      setState(() {
        comment = result.body;
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _secondNameController.dispose();
    _ageController.dispose();
    _phoneNumberController.dispose();
    _chronicDiseasesController.dispose();
    _birthdayController.dispose();
    _birthdayPlaceController.dispose();
    _bloodTypeController.dispose();
    _parentsDiseaseController.dispose();
    _marriageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              comment == null
                  ? const SizedBox()
                  : Text(
                      comment!,
                      style: const TextStyle(color: Colors.red, fontSize: 20),
                    ),
              const Text(
                "Medical Record",
                style: TextStyle(fontSize: 30),
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextField(
                  controller: _firstNameController,
                  enabled: _isEditingEnabled,
                  decoration: InputDecoration(
                    labelText: "first name",
                    hintText: 'First name',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextField(
                  controller: _secondNameController,
                  enabled: _isEditingEnabled,
                  decoration: InputDecoration(
                    labelText: "second name",
                    hintText: 'Second name',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextField(
                  controller: _ageController,
                  enabled: _isEditingEnabled,
                  decoration: InputDecoration(
                    labelText: "age",
                    hintText: 'Age',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextField(
                  controller: _phoneNumberController,
                  enabled: _isEditingEnabled,
                  decoration: InputDecoration(
                    labelText: "phone number",
                    hintText: 'Phone number',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextField(
                  controller: _chronicDiseasesController,
                  enabled: _isEditingEnabled,
                  decoration: InputDecoration(
                    labelText: "Chronic diseases",
                    hintText: 'Chronic diseases',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextField(
                  controller: _birthdayController,
                  enabled: _isEditingEnabled,
                  decoration: InputDecoration(
                    labelText: "birthday",
                    hintText: 'Birthday',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextField(
                  controller: _birthdayPlaceController,
                  enabled: _isEditingEnabled,
                  decoration: InputDecoration(
                    labelText: "birthday place",
                    hintText: 'Birthday Place',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextField(
                  controller: _bloodTypeController,
                  enabled: _isEditingEnabled,
                  decoration: InputDecoration(
                    labelText: "blood type",
                    hintText: 'Blood type',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextField(
                  controller: _parentsDiseaseController,
                  enabled: _isEditingEnabled,
                  decoration: InputDecoration(
                    labelText: 'parents disease',
                    hintText: 'Parents disease ? ',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextField(
                  controller: _marriageController,
                  enabled: _isEditingEnabled,
                  decoration: InputDecoration(
                    labelText: "marriage",
                    hintText: 'Marriage ?',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: _isEditingEnabled ? () => saveRecord() : null,
                child: const Text("Save"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
