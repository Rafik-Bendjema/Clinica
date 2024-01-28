class MedicalRecord {
  String patient;
  String firstName;
  String lastName;
  String age;
  String phoneNumber;
  String chronicDiseases;
  String birthday;
  String birthdayPlace;
  String bloodType;
  String parentsDisease;
  String marriageStatus;

  MedicalRecord({
    required this.patient,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.phoneNumber,
    required this.chronicDiseases,
    required this.birthday,
    required this.birthdayPlace,
    required this.bloodType,
    required this.parentsDisease,
    required this.marriageStatus,
  });

  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    return MedicalRecord(
      patient: json['patient'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      age: json['age'].toString(),
      phoneNumber: json['phone_number'],
      chronicDiseases: json['chronic_diseases'],
      birthday: json['birthday'],
      birthdayPlace: json['birthday_place'],
      bloodType: json['blood_type'],
      parentsDisease: json['parents_disease'],
      marriageStatus: json['marriage_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patient': patient,
      'first_name': firstName,
      'last_name': lastName,
      'age': age,
      'phone_number': phoneNumber,
      'chronic_diseases': chronicDiseases,
      'birthday': birthday,
      'birthday_place': birthdayPlace,
      'blood_type': bloodType,
      'parents_disease': parentsDisease,
      'marriage_status': marriageStatus,
    };
  }

  @override
  String toString() {
    return 'MedicalRecord: { patient: $patient, firstName: $firstName, lastName: $lastName, age: $age, phoneNumber: $phoneNumber, chronicDiseases: $chronicDiseases, birthday: $birthday, birthdayPlace: $birthdayPlace, bloodType: $bloodType, parentsDisease: $parentsDisease, marriageStatus: $marriageStatus }';
  }
}
