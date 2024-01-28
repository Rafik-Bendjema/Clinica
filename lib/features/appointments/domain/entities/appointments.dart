class Appointments {
  int? id;
  DateTime date;
  String patient;
  String doctor;
  String room;
  String status;
  String note;

  Appointments({
    this.id,
    required this.date,
    required this.doctor,
    required this.note,
    required this.patient,
    required this.room,
    required this.status,
  });

  // Named constructor to create an instance from a JSON map
  factory Appointments.fromJson(Map<String, dynamic> json) {
    return Appointments(
      id: json['id'],
      date: DateTime.parse(json['date']),
      doctor: json['doctor'],
      note: json['notes'],
      patient: json['patient'],
      room: json['room'],
      status: json['status'],
    );
  }

  // Method to convert an Appointments object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'doctor': doctor,
      'notes': note,
      'patient': patient,
      'room': room,
      'status': status,
    };
  }

  @override
  String toString() {
    return "\n $id    $date     $doctor    $note     $room \n";
  }
}
