import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test2/db/functions/db_functions.dart';
import 'package:test2/db/model/student.dart';

class ScreenList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List'),
      ),
      body: Container(
        color: Colors.blue[100],
        height: double.infinity,
        width: double.infinity,
        child: ValueListenableBuilder(
          valueListenable: StudentListNotifier,
          builder: (BuildContext context, List<StudentModel> StudentList, child) {
            return ListView.separated(
              itemCount: StudentList.length,
              itemBuilder: (context, index) {
                final data = StudentList[index];
                return ListTile(
                  leading: IconButton(
                    onPressed: () {
                      // Open the edit dialog when the edit button is pressed
                      _openEditStudentDialog(context, data);
                    },
                    icon: Icon(Icons.edit, color: Colors.white),
                  ),
                  title: Text(data.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.number),
                      Text(data.age),
                      Text(data.gender),
                    ],
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      _showDeleteConfirmationDialog(context, data);
                    },
                    icon: Icon(Icons.remove_circle, color: Colors.red),
                  ),
                );
              },
              separatorBuilder: (context, index) => Divider(),
            );
          },
        ),
      ),
    );
  }

  // Function to open the edit dialog
  void _openEditStudentDialog(BuildContext context, StudentModel student) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditStudentDialog(student: student);
      },
    );
  }

  // Function to show the delete confirmation dialog
  void _showDeleteConfirmationDialog(BuildContext context, StudentModel student) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text('Are you sure that you want to delete the data?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                delete(student.id!);
                Navigator.of(context).pop();
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }
}

class EditStudentDialog extends StatefulWidget {
  final StudentModel student;

  EditStudentDialog({required this.student});

  @override
  _EditStudentDialogState createState() => _EditStudentDialogState();
}

class _EditStudentDialogState extends State<EditStudentDialog> {
  late TextEditingController _nameController;
  late TextEditingController _numberController;
  late TextEditingController _ageController;
  late TextEditingController _genderController;

  @override
  void initState() {
    super.initState();
    // Initialize the text controllers with the current student data
    _nameController = TextEditingController(text: widget.student.name);
    _numberController = TextEditingController(text: widget.student.number);
    _ageController = TextEditingController(text: widget.student.age);
    _genderController = TextEditingController(text: widget.student.gender);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Student'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _numberController,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            decoration: InputDecoration(labelText: 'Number'),
          ),
          TextField(
            controller: _ageController,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
            ],
            decoration: InputDecoration(labelText: 'Age'),
          ),
          TextField(
            controller: _genderController,
            decoration: InputDecoration(labelText: 'Gender'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Update the student's details and close the dialog
            _updateStudentDetails();
            Navigator.of(context).pop();
          },
          child: Text('Save'),
        ),
      ],
    );
  }

  // Function to update the student's details
  void _updateStudentDetails() {
    final updatedStudent = StudentModel(
      id: widget.student.id,
      name: _nameController.text,
      number: _numberController.text,
      age: _ageController.text,
      gender: _genderController.text,
    );

    // Call the update function to update the student's details in the database
    update(updatedStudent);
  }

  @override
  void dispose() {
    // Dispose of the text controllers when the dialog is closed
    _nameController.dispose();
    _numberController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    super.dispose();
  }
}
