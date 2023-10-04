import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test2/db/functions/db_functions.dart';
import 'package:test2/db/model/student.dart'; // Import for TextInputFormatter

class ScreenHome extends StatelessWidget {
  ScreenHome({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _studentName = TextEditingController();
  final _phoneNumber = TextEditingController();
  final _age = TextEditingController();
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    getAllStudents();
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Student'),
      ),
      body: Container(
        color: Colors.blue[100],
        height: double.infinity,
        width: double.infinity,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _studentName,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _phoneNumber,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10), // Limit to 10 characters
                    ],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Number',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _age,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2), // Limit to 2 characters
                          ],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Age',
                          ),
                          validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Age';
                      }
                      return null;
                    },
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedGender,
                          onChanged: (value) {
                            _selectedGender = value;
                          },
                          items: ['Male', 'Female', 'Other'].map((gender) {
                            return DropdownMenuItem<String>(
                              value: gender,
                              child: Text(gender),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Gender',
                          ),
                          validator: (value) {
                      if (value == null) {
                        return 'Please Select one';
                      }
                      return null;
                    },
                        ),
                      ),
                      // ElevatedButton.icon(onPressed: (){}, icon: Icon(Icons.add), label: Text('Add'))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                   Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 50, // Set the desired height here
                  child: ElevatedButton.icon(
                    onPressed: () {
                      onButtonClick();
                    },
                    icon: Icon(Icons.add),
                    label: Text('Add to List'),
                  ),
                ),
              ],
            )
            
            
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onButtonClick() async{
    final studentName = _studentName.text.trim();
    final age = _age.text.trim();
    final phoneNumber = _phoneNumber.text.trim();
    final selectedGender = _selectedGender;

    if(studentName.isEmpty || phoneNumber.isEmpty || age.isEmpty || selectedGender==null){
      return;
    }
    // print('$_studentName $_phoneNumber $_age $_selectedGender');

    final _student = StudentModel(name: studentName, number: phoneNumber, age: age, gender: selectedGender);

    addStudent(_student);

    _studentName.clear();
    _phoneNumber.clear();
    _age.clear();
    _selectedGender = null;
  }
}
