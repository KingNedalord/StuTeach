import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stu_teach/adapters/auth.dart';

import 'package:stu_teach/adapters/task.dart';
import 'package:stu_teach/adapters/upload_file.dart';
import '../adapters/pdfView.dart';

class TaskPageStudent extends StatefulWidget {
  final Task task;

  const TaskPageStudent({super.key, required this.task});

  @override
  State<TaskPageStudent> createState() => _TaskPageStudentState();
}

class _TaskPageStudentState extends State<TaskPageStudent> {
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

  TextEditingController answerText = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String? image;
  bool waitUrl = false;

  Future<void> _pickImage() async {
    waitUrl = true;
    File image1;
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image1 = File(pickedFile.path);
      image = await FirebaseStorageService().uploadFile(image1);
    }
  }

  Future<void> addAnswer(Map<String, dynamic> newAssignmente) async {
    String uid = Auth().currenUser!.uid;
    try {
      DocumentReference docRef =
          FirebaseFirestore.instance.collection("students").doc(uid);
      await docRef.update({
        "assignments": FieldValue.arrayUnion([
          newAssignmente,
        ]),
      });
    } catch (e) {
      print(
          "EEEEEEEEEEEERRRRRRRRRRRRRRRRRRRRRRRRRRRRROOOOOOOOOOOOOOOOOOOOOOOOOOOOR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[500],
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
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(CupertinoIcons.check_mark),
        //     color: Colors.white70,
        //   ),
        // ],
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.green[400],
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Text(
                widget.task.taskname,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    textAlign: TextAlign.center,
                    widget.task.description,
                    maxLines: 10,
                    overflow: TextOverflow.clip,
                    style: const TextStyle(color: Colors.white),
                  )),
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
                          color: Colors.green[100]),
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
                                showSnackBar1("No Word File");
                              }
                            },
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: Image.asset('assets/office.png'),
                            ),
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
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: Image.asset(
                                'assets/mp4.png',
                                color: Colors.white70,
                              ),
                            ),
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
                                    builder: (_) =>
                                        Pdfview(url: "${widget.task.pdf}"),
                                  ),
                                );
                              } else {
                                showSnackBar1("No PDF");
                              }
                            },
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: Image.asset('assets/pdf.png'),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: OutlinedButton(
                      onPressed: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: Colors.lime,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                // width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.6,
                                child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        const Text(
                                          "Write your respond",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.07,
                                            child: TextField(
                                              controller: answerText,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                labelText: "Your respond",
                                                suffix: IconButton(
                                                    onPressed: () {
                                                      _pickImage()
                                                          .whenComplete(() {
                                                        waitUrl = false;
                                                      });
                                                    },
                                                    icon: const Icon(Icons
                                                        .attach_file_outlined)),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.07,
                                          child: ElevatedButton(
                                              onPressed: waitUrl
                                                  ? null
                                                  : () {
                                                      if (answerText.text !=
                                                              "" &&
                                                          !waitUrl) {
                                                        DateTime now =
                                                            DateTime.now();
                                                        String formattedDate =
                                                            "${now.hour}:${now.minute} ${now.day}-${now.month}-${now.year}";
                                                        addAnswer({
                                                          "id": widget.task.id,
                                                          "taskName": widget
                                                              .task.taskname,
                                                          "time": formattedDate,
                                                          "respond": answerText
                                                              .value.text,
                                                          "image": image
                                                        });
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                              child: const Text("Submit")),
                                        )
                                      ],
                                    )),
                              );
                            });
                      },
                      child: const Text("Answer"),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
