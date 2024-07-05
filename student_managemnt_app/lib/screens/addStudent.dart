// ignore: file_names
import 'dart:io';
// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_managemnt_app/screens/studentList.dart';

import '../functions/functions.dart';
import 'model.dart';

// ignore: use_key_in_widget_constructors
class AddStudent extends StatefulWidget {
  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final _formKey = GlobalKey<FormState>();
  final rollnoController = TextEditingController();
  final nameController = TextEditingController();
  final departmentController = TextEditingController();
  final phonenoController = TextEditingController();
  final agecontroller = TextEditingController();
  final fnameController = TextEditingController();
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Student Information",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.yellow,
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StudentInfo()),
                );
              },
              icon: const Icon(
                Icons.person_search,
                color: Colors.black,
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.all(25),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction, // Add this line
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: const AssetImage('assets/images/addimageicon.png'),
                  maxRadius: 60,
                  child: GestureDetector(
                    onTap: () async {
                      File? pickimage = await _pickImageFromCamera();
                      setState(() {
                        _selectedImage = pickimage;
                      });
                    },
                    child: _selectedImage != null
                        ? ClipOval(
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                              width: 140,
                              height: 140,
                            ),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: agecontroller,
                  decoration: const InputDecoration(
                    labelText: "Age",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.school),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Age is required';
                    }
                    final age = int.tryParse(value);
                    if (age == null || age < 1 || age > 120) {
                      return 'Invalid age';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Student Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Name is required';
                    }
                    if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                      return 'Invalid name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: rollnoController,
                  decoration: const InputDecoration(
                    labelText: "Roll number",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Roll no is required';
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Invalid roll number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: departmentController,
                  decoration: const InputDecoration(
                    labelText: "Department",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.school),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Department is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: phonenoController,
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Phone number is required';
                    }
                    final phoneRegExp = RegExp(r'^[0-9]{10}$');
                    if (!phoneRegExp.hasMatch(value)) {
                      return 'Invalid phone number';
                    }
                    return null;
                  },
                ),
          
                const SizedBox(height: 45),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (_selectedImage == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(
                                  "You must select an image",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                            return;
                          }

                          
                          final student = StudentModel(
                            rollno: rollnoController.text,
                            name: nameController.text,
                            department: departmentController.text,
                            phoneno: phonenoController.text,
                            age: agecontroller.text,
                            // ignore: prefer_null_aware_operators
                            imageurl: _selectedImage != null
                                ? _selectedImage!.path
                                : null,
                          );  
                          await addStudent(student);
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).push(MaterialPageRoute(builder:(context) =>const StudentInfo(),));

                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.green,
                              content: Text(
                                "Data Added Successfully",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                          rollnoController.clear();
                          nameController.clear();
                          departmentController.clear();
                          phonenoController.clear();
                          agecontroller.clear();
                          setState(() {
                            _selectedImage = null;
                          });
                        }
                      },
                      child: const Text("Save"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        rollnoController.clear();
                        nameController.clear();
                        departmentController.clear();
                        phonenoController.clear();
                        agecontroller.clear();
                        setState(() {
                          _selectedImage = null;
                        });
                      },
                      child: const Text('Clear'),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<File?> _pickImageFromCamera() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      return File(pickedImage.path);
    }
    return null;
  }
}
