import 'package:clinica/features/appointments/data/appointmentsDb.dart';
import 'package:clinica/features/appointments/domain/entities/request.dart';
import 'package:clinica/features/appointments/presentation/widgets/addAppointment.dart';
import 'package:clinica/features/appointments/presentation/widgets/requestAppointment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../domain/entities/appointments.dart';

class AppointmentsTable extends StatefulWidget {
  bool isStaff;
  AppointmentsTable({super.key, required this.isStaff});

  @override
  State<AppointmentsTable> createState() => _AppointmentsTableState();
}

class _AppointmentsTableState extends State<AppointmentsTable> {
  @override
  void initState() {
    super.initState();
  }

  AppointmentsDb appointmentsDb = AppointmentsDbImpl();
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () {
              setState(() {});
            },
            child: const Text("refresh"),
          ),
        ),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.6 / 3,
                child: const Text("date")),
            const SizedBox(width: 300, child: Text("room")),
            const Expanded(child: Text("status")),
            const Text('INFO')
          ],
        ),
      ),
      FutureBuilder(
          future: appointmentsDb.getAll(null),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No appointments available.'),
              );
            } else {
              List<Object> all = snapshot.data!;

              return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: all.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          height: 50,
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 151, 208, 255),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Row(
                            children: [
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.6 / 3,
                                child: all[index] is Appointments
                                    ? Text((all[index] as Appointments)
                                        .date
                                        .toString()
                                        .split(".")
                                        .first
                                        .toString())
                                    : Text((all[index] as AppointmentRequest)
                                        .date
                                        .toString()
                                        .split(".")
                                        .first
                                        .toString()),
                              ),
                              SizedBox(
                                width: 300,
                                child: all[index] is Appointments
                                    ? Text((all[index] as Appointments).room)
                                    : const Text(""),
                              ),
                              Expanded(
                                  child: Text(
                                all[index] is Appointments
                                    ? (all[index] as Appointments).status
                                    : "waiting",
                                style: TextStyle(
                                    color: all[index] is Appointments
                                        ? (all[index] as Appointments).status ==
                                                "scheduled"
                                            ? Colors.green
                                            : Colors.red
                                        : const Color.fromARGB(
                                            255, 73, 73, 73)),
                              )),
                              all[index] is Appointments
                                  ? TextButton(
                                      onPressed: () {
                                        print(
                                            "this is the id of the app ${(all[index] as Appointments).id}");
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'Appointment Details'),
                                              content: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                      'Date: ${(all[index] as Appointments).date.toString()}'),
                                                  Text(
                                                      'Room: ${(all[index] as Appointments).room}'),
                                                  Text(
                                                      'Status: ${(all[index] as Appointments).status}'),
                                                  Text(
                                                      'Notes: ${(all[index] as Appointments).note}'),

                                                  (all[index] as Appointments)
                                                              .status !=
                                                          "canceled"
                                                      ? Column(
                                                          children: [
                                                            Center(
                                                              child:
                                                                  ElevatedButton(
                                                                      onPressed:
                                                                          () async {
                                                                        await appointmentsDb.cancelResponse((all[index]
                                                                            as Appointments));
                                                                        Navigator.pop(
                                                                            context);
                                                                        setState(
                                                                            () {});
                                                                      },
                                                                      child: const Text(
                                                                          "CANCEL")),
                                                            ),
                                                            widget.isStaff
                                                                ? Center(
                                                                    child: ElevatedButton(
                                                                        onPressed: () async {
                                                                          await appointmentsDb.cancelResponse((all[index]
                                                                              as Appointments));
                                                                          Navigator.pop(
                                                                              context);
                                                                          setState(
                                                                              () {});
                                                                        },
                                                                        child: const Text("DONE")),
                                                                  )
                                                                : const SizedBox()
                                                          ],
                                                        )
                                                      : const SizedBox()
                                                  // Add more fields as needed
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(); // Close the dialog
                                                  },
                                                  child: const Text('Close'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: const Text('INFO'))
                                  : Row(
                                      children: [
                                        widget.isStaff
                                            ? IconButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AddAppointmentPage(
                                                                r: all[index]
                                                                    as AppointmentRequest,
                                                              )));
                                                },
                                                icon: const Icon(Icons.add))
                                            : const SizedBox(),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            AppointmentsDb appointmentsDb =
                                                AppointmentsDbImpl();
                                            Response result = await appointmentsDb
                                                .deleteRequest((all[index]
                                                        as AppointmentRequest)
                                                    .id
                                                    .toString());
                                            if (result.statusCode == 200) {
                                              setState(() {});
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      const Dialog(
                                                        child: SizedBox(
                                                          height: 200,
                                                          width: 200,
                                                          child: Center(
                                                            child: Text(
                                                                "DELETED ! "),
                                                          ),
                                                        ),
                                                      ));
                                            }
                                          },
                                          icon: const Icon(Icons.delete),
                                        ),
                                      ],
                                    )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        )
                      ],
                    );
                  });
            }
          })
    ]);
  }
}
