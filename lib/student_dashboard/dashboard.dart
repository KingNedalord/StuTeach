import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:stu_teach/adapters/task.dart';
import 'package:stu_teach/adapters/auth.dart';
import 'package:stu_teach/login_page/login_register.dart';
import 'package:stu_teach/student_dashboard/task_page.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final User? user = Auth().currenUser;

  Future<void> signOut() async {
    Auth().signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    SharedPreferences prefs2 = await SharedPreferences.getInstance();
    await prefs2.setBool('isTeacher', false);
    Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        CupertinoPageRoute(builder: (_) => const LoginRegister()));
  }

  Future<List<Task>> getTask() async {
    List<Task> taskList = [];
    await FirebaseFirestore.instance
        .collection("task")
        .get()
        .then((QuerySnapshot querysnapshot) {
      for (var m in querysnapshot.docs) {
        taskList.add(
          Task(
            description: m.get('description'),
            taskname: m.get('task_name'),
            time: m.get('time'),
            id: m.get('id'),
            image: m.get('image'),
            pdf: m.get('pdf'),
            video: m.get('video'),
            word: m.get('word'),
          ),
        );
      }
    });
    return taskList;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: Colors.green[500],
            title: TextButton(
              onPressed: () {
                setState(() {});
              },
              child: const Text(
                "Student",
                style: TextStyle(fontSize: 20),
              ),
            ),
            bottom: const TabBar(tabs: <Widget>[
              Tab(
                icon: Icon(Icons.task),
              ),
              Tab(
                icon: Icon(Icons.person_2),
              ),
            ]),
            actions: [
              MaterialButton(
                onPressed: signOut,
                child: const Icon(
                  Icons.exit_to_app,
                  color: Colors.white70,
                ),
              )
            ],
          ),
          backgroundColor: Colors.green[300],
          body: TabBarView(children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.65,
                    width: MediaQuery.of(context).size.width,
                    child: FutureBuilder(
                      future: getTask(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: const Center(
                              child: Text(
                                "Something went wrong",
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.w700),
                              ),
                            ),
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text(
                              "No tasks yet(",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w700),
                            ),
                          );
                        } else {
                          return ListView.builder(
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.12,
                                  width: MediaQuery.of(context).size.width,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (_) => TaskPageStudent(
                                                    task: Task(
                                                      description: snapshot
                                                          .data![index]
                                                          .description,
                                                      taskname: snapshot
                                                          .data![index]
                                                          .taskname,
                                                      time: snapshot
                                                          .data![index].time,
                                                      id: snapshot
                                                          .data![index].id,
                                                      image: snapshot
                                                          .data?[index].image,
                                                      pdf: snapshot
                                                          .data?[index].pdf,
                                                      video: snapshot
                                                          .data?[index].video,
                                                      word: snapshot
                                                          .data?[index].word,
                                                    ),
                                                  )));
                                    },
                                    child: Card(
                                      color: Colors.green[400],
                                      elevation: 3,
                                      shadowColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      margin: const EdgeInsets.all(10),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${snapshot.data![index].id}"
                                                  "."
                                                  "${snapshot.data![index].taskname}",
                                                  style: const TextStyle(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.9,
                                                  child: Text(
                                                    snapshot.data![index]
                                                        .description,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: snapshot.data!.length);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Center(
              child: Text("data"),
            )
          ])),
    );
  }
}
