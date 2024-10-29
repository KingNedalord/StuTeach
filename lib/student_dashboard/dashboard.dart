import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stu_teach/auth.dart';
import 'package:stu_teach/login_page/login_register.dart';

class Dashboard_Student extends StatefulWidget {
  const Dashboard_Student({super.key});

  @override
  State<Dashboard_Student> createState() => _Dashboard_StudentState();
}

class _Dashboard_StudentState extends State<Dashboard_Student> {

  
  final User? user = Auth().currenUser;
  Future<void> signOut()async{
    Auth().signOut();
    Navigator.push(context, CupertinoPageRoute(builder: (_)=>LoginRegister()));
  }
   Widget _signOutButton(){
    return ElevatedButton(onPressed: signOut, child:  const Text('Sign Out'),);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _signOutButton(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Text("Student"),
        ),
      )
    );
  }
}