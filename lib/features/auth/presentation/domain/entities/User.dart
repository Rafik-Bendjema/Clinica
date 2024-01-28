class User {
  int? id;
  String firstName;
  String secondName;
  String email;
  String pwd;
  int age;
  String pic;
  String role;
  User({
    this.id,
    required this.firstName,
    required this.secondName,
    required this.email,
    required this.pwd,
    required this.age,
    required this.role,
    this.pic = "",
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      secondName: json['second_name'],
      email: json['email'],
      pwd: json['pwd'],
      age: json['age'],
      role: json['role'],
      pic: json['pic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'second_name': secondName,
      'email': email,
      'pwd': pwd,
      'age': age,
      'role': role,
      'pic': pic,
    };
  }
}
