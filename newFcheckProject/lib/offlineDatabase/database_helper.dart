import 'dart:convert';

employees userFromJson(String str) => employees.fromJson(json.decode(str));

String userToJson(employees data) => json.encode(data.toJson());

class employees{
  int id;
  String employeeId;
  String employeeName;
  String dateAndTime;
  String sbu;
  String department;

  employees({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.dateAndTime,
    required this.sbu,
    required this.department
  });
  factory employees.fromJson(Map<String, dynamic> json) => employees(
    id: json["id"],
    employeeId: json["employeeId"],
      employeeName: json["employeeName"],
      dateAndTime: json["dateAndTime"],
      sbu: json["sbu"],
    department: json["department"]
  );
  Map<String, dynamic> toJson() => {
    "id":id,
    "employeeId":employeeId,
    "employeeName":employeeName,
    "dateAndTime":dateAndTime,
    "sbu":sbu,
    "department":department
  };
}
