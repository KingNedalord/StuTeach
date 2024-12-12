// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stu_teach/adapters/auth.dart';
import 'package:stu_teach/student_dashboard/dashboard.dart';
import 'package:stu_teach/teacher_dashboard/dashboard.dart';

class LoginRegister extends StatefulWidget {
  const LoginRegister({super.key});

  @override
  State<LoginRegister> createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
  String errorMessage = '';
  bool login = false;
  bool? isLoggedIn;

  final TextEditingController _emailcontr = TextEditingController();
  final TextEditingController _passwordcontr = TextEditingController();

  Future<void> signInWithEmailAndPassword(bool isTeacher) async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: _emailcontr.value.text, password: _passwordcontr.value.text);
      if (isTeacher) {
        SharedPreferences prefs2 = await SharedPreferences.getInstance();
        await prefs2.setBool('isTeacher', true);
        Navigator.push(context,
            CupertinoPageRoute(builder: (_) => const TeacherDashboard()));
      } else {
        Navigator.push(context,
            CupertinoPageRoute(builder: (_) => const StudentDashboard()));
      }
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setBool('isLoggedIn', true);
      _emailcontr.text = " ";
      _passwordcontr.text = "";
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message!;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword(bool isTeacher) async {
    if (_passwordcontr.value.text.length >= 6) {
      try {
        await Auth().createUserWithEmailAndPassword(
            email: _emailcontr.value.text, password: _passwordcontr.value.text);
        if (isTeacher) {
          SharedPreferences prefs2 = await SharedPreferences.getInstance();
          await prefs2.setBool('isTeacher', true);
          Navigator.push(context,
              CupertinoPageRoute(builder: (_) => const TeacherDashboard()));
        } else {
          String uid = Auth().currenUser!.uid;
          DocumentReference docRef =
              FirebaseFirestore.instance.collection("students").doc(uid);
          docRef.set({"name": "Student1", "assignments": []});
          Navigator.push(context,
              CupertinoPageRoute(builder: (_) => const StudentDashboard()));
        }
        _emailcontr.text = " ";
        _passwordcontr.text = "";
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setBool('isLoggedIn', true);
      } on FirebaseAuthException catch (e) {
        setState(() {
          errorMessage = e.message!;
        });
      }
    } else {
      setState(() {
        errorMessage = "Password must contain more than 6 symbols";
      });
    }
  }

  Widget _title() {
    return const Text(
      'StuTeach',
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _entryField(String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            labelText: title),
      ),
    );
  }

  Widget _erorrMessage() {
    return Text(
      errorMessage == "" ? "" : errorMessage,
      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
    );
  }

  Widget _submitButton(bool isTeacher) {
    return ElevatedButton(
        onPressed: () {
          if (login) {
            signInWithEmailAndPassword(isTeacher);
          } else {
            createUserWithEmailAndPassword(isTeacher);
          }
          FocusScope.of(context).unfocus();
        },
        child: Text(login ? 'Login' : 'Register'));
  }

  Widget _loginOrRegister() {
    return TextButton(
        onPressed: () {
          setState(() {
            login = !login;
          });
        },
        child: Text(login ? 'Register instead' : 'Login instead'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEBE5E5),
        title: _title(),
      ),
      body: CarouselSlider(
        slideTransform: const CubeTransform(),
        slideIndicator:
            CircularSlideIndicator(padding: const EdgeInsets.only(bottom: 10)),
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.green[400],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Student",
                  style: TextStyle(
                      fontSize: 25,
                      // color: Colors.bla,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                _entryField('email', _emailcontr),
                _entryField('password', _passwordcontr),
                _erorrMessage(),
                _submitButton(false),
                _loginOrRegister()
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.blue[300],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Teacher",
                  style: TextStyle(
                      fontSize: 25,
                      // color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                _entryField('email', _emailcontr),
                _entryField('password', _passwordcontr),
                _erorrMessage(),
                _submitButton(true),
                _loginOrRegister()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
