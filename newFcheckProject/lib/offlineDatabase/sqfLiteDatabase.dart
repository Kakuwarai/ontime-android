import 'dart:math';

import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'database_helper.dart';

class DBProvider{
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static Database ?_database;

  Future <Database> get database async{
    if(_database !=null)
      return _database!;

    _database = await initDB();
    return _database!;
  }
  initDB() async {
    return await openDatabase(
        join(await getDatabasesPath(), 'offlineDB.db'),
        onCreate: (db, version) async{
          await db.execute('''
        CREATE TABLE employees(
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        employeeId TEXT,
        employeeName TEXT,
        dateAndTime TEXT,
        sbu TEXT, 
        department TEXT
        )
        ''');
        },
        version: 1
    );
  }

  newUser(employees employee) async {
    final db = await database;

    var res = await db.rawInsert('''
    INSERT INTO employees (
    id ,employeeId,employeeName,dateAndTime,sbu,department
    ) VALUES (?,?,?,?,?,?)
    ''', [employee.id,employee.employeeId,employee.employeeName, employee.dateAndTime,employee.sbu,employee.department]);
    return res;
  }

  Future<dynamic> getAllData() async{
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM employees');
    if(res.length==0){
      return null;
    }else{
      return res;
    }
  }

  Future<dynamic> getEmployeesData(String picker) async{
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM employees');
    if(res.length==0){
      return null;
    }else{
      var resMap1;
      if(picker == "Id"){
         resMap1 = res[0]["employeeId"];
      }
      else if (picker == "dateTime"){
         resMap1 = res[0]["dateAndTime"];
      }
      else if (picker == "employeeName"){
        resMap1 = res[0]["employeeName"];
      }
      return resMap1;
    }
  }

  Future<dynamic> dateCorrection(String newDateTime) async{
    final db = await database;
    var res = await db.rawQuery('''
    UPDATE employees SET dateAndTime = ? WHERE Id = ?
    ''', [newDateTime , 0]);
   return res;
  }
}