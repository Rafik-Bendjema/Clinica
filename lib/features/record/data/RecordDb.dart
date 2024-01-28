import 'package:clinica/features/record/domain/entities/Record.dart';
import 'package:http/http.dart';

import 'package:http/http.dart' as http;

abstract class RecordDb {
  Future<Response> addRecord(MedicalRecord record);
  Future<Response> getRecord(String? id);
}

class RecordDbImpl implements RecordDb {
  @override
  Future<Response> addRecord(MedicalRecord record) async {
    try {
      Response result = await http.post(
          Uri.parse("http://192.168.121.46:8000/addRecord/"),
          body: record.toJson());
      return result;
    } on Exception catch (e) {
      return Response("error", 400);
    }
  }

  @override
  Future<Response> getRecord(String? id) async {
    Map<String, dynamic> body = id == null ? {} : {"id": id};
    try {
      Response result = await http.post(
          Uri.parse("http://192.168.121.46:8000/getRecords/"),
          body: body);
      print(result.body);
      return result;
    } on Exception catch (e) {
      print("detected");
      return Response(e.toString(), 200);
    }
  }
}
