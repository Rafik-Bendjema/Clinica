import "dart:convert";

import 'package:clinica/features/appointments/domain/entities/appointments.dart';
import "package:clinica/features/appointments/domain/entities/request.dart";
import "package:http/http.dart" as http;
import "package:http/http.dart";

abstract class AppointmentsDb {
  Future<List<Appointments>> getAppointments(String? id);
  Future<Response> addAppointment(Appointments a);
  Future<Response> requestAppointment(AppointmentRequest r);
  Future<List<AppointmentRequest>> getRequests(String? id);
  Future<List<Object>> getAll(String? id);
  Future<Response> cancelResponse(Appointments a);
  Future<Response> deleteRequest(String id);
  Future<Response> donResponse(Appointments a);
}

class AppointmentsDbImpl implements AppointmentsDb {
  final url = Uri.parse("http://192.168.121.46:8000/getAppointment/");

  @override
  Future<List<Appointments>> getAppointments(String? id) async {
    try {
      // Prepare the request body based on whether 'id' is provided or not
      final body = id != null ? {'id': id} : {};
      final result = await http.post(url, body: body);

      if (result.statusCode == 200) {
        // Decode the response body
        final List<dynamic> jsonList = json.decode(result.body);

        // Convert the decoded JSON into a list of Appointments
        final List<Appointments> appointmentsList = jsonList
            .map((jsonAppointment) => Appointments.fromJson(jsonAppointment))
            .toList();
        print(appointmentsList);
        return appointmentsList;
      } else {
        // Handle other status codes if needed
        print(
            "Failed to fetch appointments. Status code: ${result.statusCode}");
      }
    } catch (error) {
      // Handle network or other errors
      print("Error while fetching appointments: $error");
    }

    // Return an empty list if there's an error
    return [];
  }

  @override
  Future<Response> requestAppointment(AppointmentRequest r) async {
    Response result = await http.post(
        Uri.parse("http://192.168.121.46:8000/addRequest"),
        body: {"patient": r.patient.toString(), "date": r.date.toString()});
    print(result.body);
    return result;
  }

  @override
  Future<List<AppointmentRequest>> getRequests(String? id) async {
    try {
      // Prepare the request body based on whether 'id' is provided or not
      final body = id != null ? {'id': id} : {};

      final result = await http.post(
          Uri.parse("http://192.168.121.46:8000/getRequests/"),
          body: body);

      if (result.statusCode == 200) {
        // Decode the response body
        final List<dynamic> jsonList = json.decode(result.body);

        // Convert the decoded JSON into a list of Appointments
        final List<AppointmentRequest> requestsList = jsonList
            .map((jsonAppointment) =>
                AppointmentRequest.fromJson(jsonAppointment))
            .toList();
        print(requestsList);
        return requestsList;
      } else {
        // Handle other status codes if needed
        print(
            "Failed to fetch appointments. Status code: ${result.statusCode}");
      }
    } catch (error) {
      // Handle network or other errors
      print("Error while fetching requests: $error");
    }

    // Return an empty list if there's an error
    return [];
  }

  @override
  Future<List<Object>> getAll(String? id) async {
    try {
      List<Object> result = [];
      List<Appointments> appointments = await getAppointments(id);
      List<AppointmentRequest> requests = await getRequests(id);
      result = [...requests, ...appointments];
      return result;
    } on Exception catch (e) {
      print("error fetching all ${e.toString()}");
      return [];
    }
  }

  @override
  Future<Response> cancelResponse(Appointments a) async {
    Response response = await http.post(
        Uri.parse("http://192.168.121.46:8000/cancelAppointment/"),
        body: {"id": a.id.toString()});
    return response;
  }

  @override
  Future<Response> donResponse(Appointments a) async {
    Response response = await http.post(
        Uri.parse("http://192.168.121.46:8000/cancelAppointment/"),
        body: {"id": a.id.toString()});
    return response;
  }

  @override
  Future<http.Response> deleteRequest(String id) async {
    try {
      Response result = await http.post(
          Uri.parse("http://192.168.121.46:8000/deleteRequest/"),
          body: {"id": id});

      return result;
    } on Exception catch (e) {
      return Response("error deleting ", 400);
    }
  }

  @override
  Future<http.Response> addAppointment(Appointments a) async {
    try {
      Response result = await http.post(
          Uri.parse("http://192.168.121.46:8000/addAppointment/"),
          body: a.toJson());
      return result;
    } on Exception catch (e) {
      return Response("error adding appointmen", 400);
    }
  }
}
