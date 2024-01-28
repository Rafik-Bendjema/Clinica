import 'package:http/http.dart';

import 'package:http/http.dart' as http;

abstract class PatientDb {
  Future<Response> getPatients();
}

class PatientDbImpl implements PatientDb {
  @override
  Future<Response> getPatients() async {
    Response result = await http.get(Uri.parse("http://192.168.121.46:8000"));
    print(result.body);
    return result;
  }
}
