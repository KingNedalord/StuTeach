import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:stu_teach/adapters/task.dart';
import 'package:stu_teach/adapters/auth.dart';
import 'package:stu_teach/login_page/login_register.dart';
import 'package:stu_teach/teacher_dashboard/add_task.dart';
import 'package:stu_teach/teacher_dashboard/task_page.dart';

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

  int lastIndex = -1;

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
        if (lastIndex < m.get('id')) {
          lastIndex = m.get('id');
        }
      }
    });
    return taskList;
  }

  void showSnackBar1(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Successfully deleted"),
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

        errorMessage = "Successfully deleted the task";
      } else {
        errorMessage = "ID PROBLEM";
      }
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (_) => AddTask(
                  lastIndex: lastIndex,
                ),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.blue[400],
          title: TextButton(
            onPressed: () {
              setState(() {});
            },
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
              child: const Icon(
                Icons.exit_to_app,
                color: Colors.white70,
              ),
            )
          ],
        ),
        backgroundColor: Colors.blue[100],
        body: TabBarView(
          children: <Widget>[
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
                                  child: Slidable(
                                    key: Key("${snapshot.data![index]}"),
                                    endActionPane: ActionPane(
                                        motion: const ScrollMotion(),
                                        children: [
                                          SlidableAction(
                                            onPressed: (context) {
                                              deleteTask(
                                                snapshot.data![index].id,
                                              ).whenComplete(() {
                                                setState(() {});
                                              });
                                              showSnackBar1(context);
                                            },
                                            backgroundColor: Colors.red,
                                            icon: CupertinoIcons.trash,
                                          ),
                                        ]),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (_) => TaskPage(
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
                                        color: Colors.blue[200],
                                        elevation: 3,
                                        shadowColor: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                                                    width:
                                                        MediaQuery.of(context)
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
            RefreshIndicator(
              onRefresh: () {
                setState(() {});
                throw Exception();
              },
              child: GridView.extent(
                maxCrossAxisExtent: 150.0, // Max width of each item
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                children: List.generate(20, (index) {
                  return Container(
                    color: Colors.purple,
                    child: Center(child: Text('Item $index')),
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
