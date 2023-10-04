import 'package:hive/hive.dart';
part 'student.g.dart';

@HiveType(typeId: 1)

class StudentModel  {

  @HiveField(0)
   int? id ;

  @HiveField(1)
   String name;
  
  @HiveField(2)
   String number;
  
  @HiveField(3)
   String age;
  
  @HiveField(4)
   String gender;

  StudentModel( {required this.name,required this.number,required this.age,required this.gender,this.id});
}

