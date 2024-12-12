import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:stu_teach/adapters/task.dart';
import '../adapters/pdfView.dart';

class TaskPage extends StatefulWidget {
  final Task task;

  const TaskPage({super.key, required this.task});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  TextEditingController taskNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Widget _image() {
    return Image.network(
      '${widget.task.image}',
      fit: BoxFit.fitWidth,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child; // Image loaded successfully, return the image widget
        }
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) {
        return Container(
          color: Colors.grey,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.08,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error,
                color: Colors.red,
              ),
              Text(
                "Something went wrong",
                style: TextStyle(color: Colors.blue),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _textField(TextEditingController controller, int maxLine, int minLine,
      String hintText1) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          hintText: hintText1,
        ),
        textAlign: TextAlign.justify,
        maxLines: maxLine,
        minLines: minLine,
      ),
    );
  }

  void showSnackBar1(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      dismissDirection: DismissDirection.vertical,
      duration: const Duration(seconds: 3),
    ));
  }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {});
  }

  @override
  void initState() {
    super.initState();
    taskNameController.text = widget.task.taskname;
    descriptionController.text = widget.task.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[500],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(CupertinoIcons.back),
          color: Colors.white70,
        ),
        title: Text(
          "Task ID:${widget.task.id}",
          style: const TextStyle(
              fontWeight: FontWeight.w600, color: Colors.white70),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(CupertinoIcons.check_mark),
            color: Colors.white70,
          ),
        ],
      ),
      backgroundColor: Colors.blue[200],
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.08,
                child: _textField(taskNameController, 1, 1, "Task name")),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: _textField(descriptionController, 5, 1, "Description"),
            ),
            if (widget.task.image != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _image(),
              ),
            if (widget.task.image == null)
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.05,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "No Image",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.blue[100],
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              if (widget.task.word != null) {
                                copyToClipboard("${widget.task.word}");
                              } else {
                                showSnackBar1("No Word");
                              }
                            },
                            child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                width: MediaQuery.of(context).size.width * 0.35,
                                child: Image.asset('assets/office.png')),
                          ),
                          InkWell(
                            onTap: () {
                              if (widget.task.video != null) {
                                copyToClipboard("${widget.task.video}");
                              } else {
                                showSnackBar1("No Video");
                              }
                            },
                            child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                width: MediaQuery.of(context).size.width * 0.35,
                                child: Image.asset('assets/mp4.png')),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              if (widget.task.pdf != null) {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (_) => Pdfview(
                                            url: widget.task.pdf ?? "null")));
                              } else {
                                showSnackBar1("No PDF");
                              }
                            },
                            child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                width: MediaQuery.of(context).size.width * 0.35,
                                child: Image.asset('assets/pdf.png')),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
