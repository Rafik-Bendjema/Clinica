class AppointmentRequest {
  int? id;
  String patient;
  DateTime date;

  AppointmentRequest({this.id, required this.date, required this.patient});

  factory AppointmentRequest.fromJson(Map<String, dynamic> json) {
    return AppointmentRequest(
      id: json['id'] as int,
      patient: json['patient'],
      date: DateTime.parse(json['date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient': patient,
      'date': date.toIso8601String(),
    };
  }
}
