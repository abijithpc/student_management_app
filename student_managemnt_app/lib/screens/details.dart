// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';


class Details extends StatelessWidget {

  
  final Map<String, dynamic> student;
   Details({super.key,required this.student});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.yellow ,
        title: Text('Details of ${student['name']}'),
      ),
      body: Center(
         child: Container(
          decoration: BoxDecoration(color: Colors.yellow,borderRadius: BorderRadius.circular(7)),
          height: 400,
          width: 350,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                SizedBox(height: 30,),
                CircleAvatar(
                  backgroundImage:
                   FileImage(File(student['imageurl'])),
                  radius: 60,
                ),
                SizedBox(height: 30,),
                Text(student['name'],
                style: TextStyle(fontSize:30,fontWeight: FontWeight.w300,color: Colors.black),
                )
                ,
                SizedBox(height: 12,),
                Text('department : ${student['department']}',
                style: TextStyle(fontSize:20,fontWeight: FontWeight.w300,color: Colors.black ),
                )
                ,
                SizedBox(height: 12,),
                Text('rollno : ${student['rollno']}',
                style: TextStyle(fontSize:20,fontWeight: FontWeight.w300,color: Colors.black),
                )
                ,
                SizedBox(height: 12,),
                Text('mobile : ${student['phoneno']}',
                style: TextStyle(fontSize:20,fontWeight: FontWeight.w300,color: Colors.black),
                )
              ],
            ),
          ),
         ),
         ),
    );
  }
}