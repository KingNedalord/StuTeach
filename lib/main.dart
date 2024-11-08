import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stu_teach/login_page/login_register.dart';
import 'package:stu_teach/student_dashboard/dashboard.dart';
import 'package:stu_teach/teacher_dashboard/dashboard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final prefs = await SharedPreferences.getInstance();
  bool? isLogin = prefs.getBool('isLoggedIn');
  final prefs2 = await SharedPreferences.getInstance();
  bool? isTeacher = prefs2.getBool('isTeacher');
  if (isTeacher == true) {
    runApp(MaterialApp(
      home: isLogin == true ? const TeacherDashboard() : const LoginRegister(),
      debugShowCheckedModeBanner: false,
    ));
  } else {
    runApp(MaterialApp(
      home: isLogin == true ? const StudentDashboard() : const LoginRegister(),
      debugShowCheckedModeBanner: false,
    ));
  }
}
