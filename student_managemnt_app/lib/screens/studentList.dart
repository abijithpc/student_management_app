// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:student_managemnt_app/screens/details.dart';
import '../functions/functions.dart';
import 'model.dart';

class StudentInfo extends StatefulWidget {
  const StudentInfo({Key? key}) : super(key: key);

  @override
  State<StudentInfo> createState() => _StudentInfoState();
}

class _StudentInfoState extends State<StudentInfo> {
  late List<Map<String, dynamic>> _studentsData = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    _fetchStudentsData();
    super.initState();
  }

  Future<void> _fetchStudentsData() async {
    List<Map<String, dynamic>> students = await getAllStudents();
    if (searchController.text.isNotEmpty) {
      students = students
          .where((student) => student['name']
              .toString()
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    }

    setState(() {
      _studentsData = students;
    });
  }

  Future<void> _showEditDialog(int index) async {
    final student = _studentsData[index];
    final TextEditingController nameController =
        TextEditingController(text: student['name']);
    final TextEditingController rollnoController =
        TextEditingController(text: student['rollno'].toString());
    final TextEditingController departmentController =
        TextEditingController(text: student['department']);
    final TextEditingController phonenoController =
        TextEditingController(text: student['phoneno'].toString());
        final TextEditingController ageController =
        TextEditingController(text: student['age'].toString());
        

    showDialog(
      context: context,
      builder: (BuildContext) => AlertDialog(
        title: Text("Edit Student"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Name"),
              ),
              TextFormField(
                controller: rollnoController,
                decoration: InputDecoration(labelText: "Roll No"),
              ),
              TextFormField(
                controller: departmentController,
                decoration: InputDecoration(labelText: "Department"),
              ),
              TextFormField(
                controller: phonenoController,
                decoration: InputDecoration(labelText: "Phone No"),
              ),
               TextFormField(
                controller: ageController,
                decoration: InputDecoration(labelText: " Age"),
              ),

            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await updateStudent(
                StudentModel(
                  id: student['id'],
                  rollno: rollnoController.text,
                  name: nameController.text,
                  department: departmentController.text,
                  phoneno: phonenoController.text,
                  age:ageController.text,
                  imageurl: student['imageurl'],
                ),
              );
              Navigator.of(context).pop();
              _fetchStudentsData(); // Refresh the list
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.green,
                  content: Text("Changes Updated")));
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.yellow,
          title: Text(
            "STUDENT LIST",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      _fetchStudentsData();
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    labelText: "Search",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: _studentsData.isEmpty
            ? Center(child: Text("No students available."))
            : ListView.separated(
                itemBuilder: (context, index) {
                  final student = _studentsData[index];
                  final id = student['id'];
                  final imageUrl = student['imageurl'];
                  return ListTile(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return Details(student: student);
                      }));
                    },
                    leading: GestureDetector(
                      onTap: () {
                        if (imageUrl != null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.file(File(imageUrl)),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                      child: CircleAvatar(
                        backgroundImage:
                            imageUrl != null ? FileImage(File(imageUrl)) : null,
                        child: imageUrl == null ? Icon(Icons.person) : null,
                      ),
                    ),
                    title: Text(student['name']),
                    subtitle: Text(student['department']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            _showEditDialog(index);
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.grey,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext) => AlertDialog(
                                title: Text("Delete Student"),
                                content:
                                    Text("Are you sure you want to delete?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await deleteStudent(id);
                                      _fetchStudentsData();
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Deleted Successfully")));
                                    },
                                    child: Text("Ok"),
                                  )
                                ],
                              ),
                            );
                          },
                          icon: Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: _studentsData.length,
              ),
      ),
    );
  }
}
