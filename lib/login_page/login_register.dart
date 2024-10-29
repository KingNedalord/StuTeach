import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stu_teach/auth.dart';
import 'package:stu_teach/student_dashboard/dashboard.dart';
import 'package:stu_teach/teacher_dashboard/dashboard.dart';

class LoginRegister extends StatefulWidget {
  const LoginRegister({super.key});

  @override
  State<LoginRegister> createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
  String error_message = '';
  bool login = false;
  bool? isLoggedIn;

  TextEditingController _emailcontr = TextEditingController();
  TextEditingController _passwordcontr = TextEditingController();

  Future<void> signInWithEmailAndPassword(bool isTeacher) async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: _emailcontr.value.text, password: _passwordcontr.value.text);
      if (isTeacher) {
        SharedPreferences prefs2 = await SharedPreferences.getInstance();
        await prefs2.setBool('isTeacher', true);
        Navigator.push(
            context, CupertinoPageRoute(builder: (_) => Dashboard_Teacher()));
      } else {
        Navigator.push(
            context, CupertinoPageRoute(builder: (_) => Dashboard_Student()));
      }
      SharedPreferences pref = await SharedPreferences.getInstance();
      isLoggedIn = await pref.setBool('isLoggedIn', true);
       _emailcontr.text = " ";
               _passwordcontr.text = "";
    } on FirebaseAuthException catch (e) {
      setState(() {
        error_message = e.message!;
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
          Navigator.push(
              context, CupertinoPageRoute(builder: (_) => Dashboard_Teacher()));
        } else {
          Navigator.push(
              context, CupertinoPageRoute(builder: (_) => Dashboard_Student()));
        }
         _emailcontr.text = " ";
               _passwordcontr.text = "";
      } on FirebaseAuthException catch (e) {
        setState(() {
          error_message = e.message!;
        });
      }
    } else {
      setState(() {
        error_message = "Password must contain more than 6 symbols";
      });
    }
  }

  Widget _title() {
    return const Text('StuTeach');
  }

  Widget _entryField(String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
      error_message == "" ? "" : "$error_message",
      style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
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
        title: _title(),
      ),
      body: CarouselSlider(
        slideTransform: CubeTransform(),
        slideIndicator:
            CircularSlideIndicator(padding: EdgeInsets.only(bottom: 10)),
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.green[300],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Student",
                  style: TextStyle(fontSize: 20),
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
                Text(
                  "Teacher",
                  style: TextStyle(fontSize: 20),
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
