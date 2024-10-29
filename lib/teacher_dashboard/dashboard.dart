import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stu_teach/adapters/task.dart';
import 'package:stu_teach/auth.dart';
import 'package:stu_teach/login_page/login_register.dart';
import 'package:stu_teach/teacher_dashboard/add_task.dart';
import 'package:stu_teach/teacher_dashboard/task_page.dart';

class Dashboard_Teacher extends StatefulWidget {
  const Dashboard_Teacher({super.key});

  @override
  State<Dashboard_Teacher> createState() => _Dashboard_TeacherState();
}

class _Dashboard_TeacherState extends State<Dashboard_Teacher> {
  final User? user = Auth().currenUser;

  Future<void> signOut() async {
    Auth().signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    SharedPreferences prefs2 = await SharedPreferences.getInstance();
    await prefs2.setBool('isTeacher', false);
    Navigator.push(
        context, CupertinoPageRoute(builder: (_) => LoginRegister()));
  }

  int last_index = -1;

  Future<List<Task>> getTask() async {
    List<Task> task_list = [];
    await FirebaseFirestore.instance
        .collection("task")
        .get()
        .then((QuerySnapshot querysnapshot) {
      for (var m in querysnapshot.docs) {
        task_list.add(
          Task(
              description: m.get('description'),
              task_name: m.get('task_name'),
              time: m.get('time'),
              id: m.get('id'),
              image: m.get('image'),
              pdf: m.get('pdf'),
              mp4: m.get('video'),
              word: m.get('word'),
              audio: m.get('audio')),
        );
        if (last_index < m.get("id")) {
          last_index = m.get("id");
        }
      }
    });
    return task_list;
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
              child: Text(
                "Teacher",
                style: TextStyle(fontSize: 20),
              ),
            ),
            bottom: TabBar(tabs: <Widget>[
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
                child: Icon(Icons.exit_to_app),
              )
            ],
          ),
          body: TabBarView(children: <Widget>[
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.82,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        width: MediaQuery.of(context).size.width,
                        child: FutureBuilder(
                          future: getTask(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError || !snapshot.hasData) {
                              return Container();
                            } else {
                              return ListView.separated(
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                        leading:
                                            Text("${snapshot.data?[index].id}"),
                                        title: Text(
                                            snapshot.data![index].task_name),
                                        trailing: Text(
                                            "${snapshot.data![index].time}"),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                  builder: (_) => TaskPage(
                                                        task: Task(
                                                            description: snapshot
                                                                .data![index]
                                                                .description,
                                                            task_name: snapshot
                                                                .data![index]
                                                                .task_name,
                                                            time: snapshot
                                                                .data![index]
                                                                .time,
                                                            id: snapshot
                                                                .data![index]
                                                                .id,
                                                            image: snapshot
                                                                .data?[index]
                                                                .image,
                                                            pdf: snapshot
                                                                .data?[index]
                                                                .pdf,
                                                            mp4: snapshot
                                                                .data?[index]
                                                                .mp4,
                                                            word: snapshot
                                                                .data?[index]
                                                                .word,
                                                            audio: snapshot
                                                                .data![index]
                                                                .audio),
                                                      )));
                                        });
                                  },
                                  separatorBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
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
                                          last_index: last_index,
                                        )));
                          },
                          child: Icon(Icons.add),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Center(
              child: Text("data"),
            )
          ])),
    );
  }
}
