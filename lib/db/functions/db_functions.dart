import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test2/db/model/student.dart';

ValueNotifier<List<StudentModel>> StudentListNotifier = ValueNotifier([]);


  Future<void> addStudent (StudentModel value)async {
    // StudentListNotifier.value.add(value);
    // print(value.toString());

  final studentDB = await Hive.openBox<StudentModel>('student_db');
  final _id = await studentDB.add(value);
  value.id = _id;
  StudentListNotifier.value.add(value);

    StudentListNotifier.notifyListeners();
  }

Future<void> getAllStudents() async{
  final studentDB = await Hive.openBox<StudentModel>('student_db');
  StudentListNotifier.value.clear();
  StudentListNotifier.value.addAll(studentDB.values);
  StudentListNotifier.notifyListeners(); 
}

Future<void> delete(int id)async{
 final studentDB = await Hive.openBox<StudentModel>('student_db');
 await studentDB.delete(id);
  getAllStudents();
}

Future<void> update(StudentModel updatedStudent) async{
  final studentDB = await Hive.openBox<StudentModel>('student_db');

  final existingStudent = studentDB.get(updatedStudent.id);

  if (existingStudent != null){
    existingStudent.name = updatedStudent.name;
    existingStudent.number = updatedStudent.number;
    existingStudent.age = updatedStudent.age;
    existingStudent.gender = updatedStudent.gender;

    studentDB.put(updatedStudent.id, existingStudent);

    getAllStudents();
  }
}