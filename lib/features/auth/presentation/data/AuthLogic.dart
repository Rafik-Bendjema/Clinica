import "dart:convert";

import "package:clinica/features/auth/presentation/domain/entities/User.dart";
import "package:http/http.dart" as http;
import "package:http/http.dart";

abstract class AuthLogic {
  Future<Response> login(String email, String pwd);
  Future<User?> signup(User user);
}

class AuthLogicImpl extends AuthLogic {
  @override
  Future<Response> login(String email, String pwd) async {
    print("srrat ");
    var result = await http.post(Uri.parse("http://192.168.121.46:8000/login/"),
        body: {"email": email, "pwd": pwd});

    print("this is the result ${result.statusCode}");
    return result;
  }

  @override
  Future<User?> signup(User user) async {
    print("here is the sign up user ${user.toJson()}");
    Response resutl =
        await http.post(Uri.parse('http://192.168.121.46:8000/add/'), body: {
      "first_name": user.firstName,
      "second_name": user.secondName,
      "email": user.email,
      "pwd": user.pwd,
      "age": user.age.toString(),
      "pic": user.pic
    });
    print("here is the result of the sing up ${resutl.body}");
    if (resutl.statusCode == 200) {
      return User.fromJson(jsonDecode(resutl.body));
    } else {
      return null;
    }
  }
}
