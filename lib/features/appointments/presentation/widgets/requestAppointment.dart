import 'package:clinica/features/appointments/data/appointmentsDb.dart';
import 'package:clinica/features/appointments/domain/entities/request.dart';
import 'package:clinica/features/auth/presentation/data/currentUser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class RequestAppointment extends StatefulWidget {
  const RequestAppointment({super.key});

  @override
  State<RequestAppointment> createState() => _RequestAppointmentState();
}

class _RequestAppointmentState extends State<RequestAppointment> {
  AppointmentsDb appointmentsDb = AppointmentsDbImpl();
  DateTime? date;
  String? comment;

  void submit() async {
    if (date != null) {
      AppointmentRequest r =
          AppointmentRequest(date: date!, patient: userId.toString());
      Response result = await appointmentsDb.requestAppointment(r);
      if (result.statusCode == 200) {
        Navigator.pop(context);
        setState(() {});
        setState(() {});
      } else {
        setState(() {
          comment = result.body;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: 500,
      height: 150,
      child: Center(
        child: Column(
          children: [
            comment == null
                ? const SizedBox()
                : Text(
                    comment!,
                    style: const TextStyle(color: Colors.red),
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "picked date :  ${date == null ? "" : date.toString().split(" ").first}",
                  style: const TextStyle(color: Colors.black),
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
                          date = picked;
                        });
                      }
                    },
                    child: const Text("PICK DATE"))
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () {
                  submit();
                },
                child: const Text("request"))
          ],
        ),
      ),
    );
  }
}
