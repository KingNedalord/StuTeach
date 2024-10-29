import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:stu_teach/adapters/task.dart';

class TaskPage extends StatefulWidget {
  final Task task;

  const TaskPage({super.key, required this.task});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task ID:${widget.task.id}"),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.trash)),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Text(widget.task.task_name),
            Text(widget.task.description),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          MaterialPageRoute(
                              builder: (context) =>
                                  PDFView(filePath: widget.task.pdf ?? ""));
                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.15,
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: Image.asset('assets/pdf.png')),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.15,
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: Image.asset('assets/image.png')),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: Image.asset('assets/mp4.png')),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: Image.asset('assets/office.png')),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
