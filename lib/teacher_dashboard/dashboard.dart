import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:stu_teach/adapters/task.dart';
import 'package:stu_teach/auth.dart';
import 'package:stu_teach/login_page/login_register.dart';
import 'package:stu_teach/teacher_dashboard/add_task.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  final User? user = Auth().currenUser;

  Future<void> signOut() async {
    Auth().signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    SharedPreferences prefs2 = await SharedPreferences.getInstance();
    await prefs2.setBool('isTeacher', false);
    Navigator.push(
        context, CupertinoPageRoute(builder: (_) => const LoginRegister()));
  }

  int last_index = -1;

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
            mp4: m.get('video'),
            word: m.get('word'),
          ),
        );
        if (last_index < m.get("id")) {
          last_index = m.get("id");
        }
      }
    });
    return taskList;
  }

  void showSnackBar1(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Successfuly deleted"),
      dismissDirection: DismissDirection.vertical,
      duration: Duration(seconds: 3),
    ));
  }

  late String errorMessage;
  Future<void> deleteTask(int id) async {
    try {
      CollectionReference tasksCollection =
          FirebaseFirestore.instance.collection('task');

      QuerySnapshot querySnapshot =
          await tasksCollection.where('id', isEqualTo: id).get();

      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs.first.id;

        await tasksCollection.doc(docId).delete();
        print("IDD");
        errorMessage = "Succesfully deleted the task";
      } else {
        print("NOT IDD");
        errorMessage = "ID PROBLEM";
      }
    } catch (e) {
      errorMessage = e.toString();
      print("ERORRRRRR");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
          appBar: AppBar(
            title: TextButton(
              onPressed: () {
                setState(() {});
              },
              // style: TextButton.styleFrom(
              //  // fixedSize: Size(MediaQuery.of(context).size.width * 0.15,MediaQuery.of(context).size.height * 0.001)
              // ),
              child: const Text(
                "Teacher",
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
                child: const Icon(Icons.exit_to_app),
              )
            ],
          ),
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
                          return ListView.separated(
                              itemBuilder: (context, index) {
                                return Slidable(
                                  key: Key("${snapshot.data![index]}"),
                                  endActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: (context) {
                                            deleteTask(
                                              snapshot.data![index].id,
                                            );
                                            setState(() {});
                                            showSnackBar1(context);
                                          },
                                          backgroundColor: Colors.red,
                                          icon: CupertinoIcons.trash,
                                        ),
                                      ]),
                                  child: ListTile(
                                      leading:
                                          Text("${snapshot.data?[index].id}"),
                                      title:
                                          Text(snapshot.data![index].taskname),
                                      trailing:
                                          Text(snapshot.data![index].time),
                                      onTap: () {
                                        // Navigator.push(
                                        //     context,
                                        // CupertinoPageRoute(
                                        //     builder: (_) => TaskPage(
                                        //           task: Task(
                                        //               description: snapshot
                                        //                   .data![index]
                                        //                   .description,
                                        //               task_name: snapshot
                                        //                   .data![index]
                                        //                   .task_name,
                                        //               time: snapshot
                                        //                   .data![index]
                                        //                   .time,
                                        //               id: snapshot
                                        //                   .data![index]
                                        //                   .id,
                                        //               image: snapshot
                                        //                   .data?[index]
                                        //                   .image,
                                        //               pdf: snapshot
                                        //                   .data?[index]
                                        //                   .pdf,
                                        //               mp4: snapshot
                                        //                   .data?[index]
                                        //                   .mp4,
                                        //               word: snapshot
                                        //                   .data?[index]
                                        //                   .word,
                                        //               audio: snapshot
                                        //                   .data![index]
                                        //                   .audio),
                                        //         ))
                                        //         );
                                      }),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const Padding(
                                  padding:
                                      EdgeInsets.only(left: 8.0, right: 8.0),
                                  child: Divider(
                                    color: Colors.black,
                                  ),
                                );
                              },
                              itemCount: snapshot.data!.length);
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0, top: 8.0),
                    child: FloatingActionButton(
                      onPressed: () async {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (_) => AddTask(
                                      lastIndex: last_index,
                                    )));
                      },
                      child: const Icon(Icons.add),
                    ),
                  )
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
