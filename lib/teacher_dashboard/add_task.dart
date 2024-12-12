import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:stu_teach/adapters/upload_file.dart';

class AddTask extends StatefulWidget {
  final int lastIndex;
  const AddTask({super.key, required this.lastIndex});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  String? pdf;
  String? word;
  String? mp4;
  String? image;
  String? filePath;
  bool errorPicking = false;
  bool waitUrl = false;
  void showSnackBar1(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      dismissDirection: DismissDirection.vertical,
      duration: const Duration(seconds: 3),
    ));
  }

  Future<void> pickFile(String extension) async {
    waitUrl = true;
    File? file;
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: extension != "doc" ? [extension] : ["docx", "doc"],
    );
    if (result != null) {
      file = File(result.files.single.path!);
      filePath = await FirebaseStorageService().uploadFile(file);
      errorPicking = false;
    } else {
      errorPicking = true;
    }
  }

  final ImagePicker _picker = ImagePicker();
// Picking Images
  Future<void> _pickImage() async {
    waitUrl = true;
    File image1;
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image1 = File(pickedFile.path);
      image = await FirebaseStorageService().uploadFile(image1);
      errorPicking = false;
    } else {
      errorPicking = true;
    }
  }

// Adding to firestore
  Future<void> addTask(
      String description, String taskName, String time, int id) async {
    FirebaseFirestore.instance.collection("task").add({
      "description": description,
      "task_name": taskName,
      "time": time,
      "id": id,
      "image": image,
      "pdf": pdf,
      "video": mp4,
      "word": word,
    });
  }

  TextEditingController description = TextEditingController();
  TextEditingController taskNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blue[500],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(CupertinoIcons.back),
          color: Colors.white70,
        ),
        title: const Text(
          "Adding task",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white70),
        ),
      ),
      backgroundColor: Colors.blue[200],
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: taskNameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          gapPadding: 20,
                          borderRadius: BorderRadius.circular(20)),
                      hintText: "Task name"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: description,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          gapPadding: 20,
                          borderRadius: BorderRadius.circular(20)),
                      hintText: "Description"),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            pickFile('pdf').whenComplete(() {
                              if (errorPicking) {
                                showSnackBar1("Error while picking pdf");
                              } else {
                                pdf = filePath;
                                showSnackBar1("Complete");
                              }
                              waitUrl = false;
                            });
                          },
                          child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: Image.asset('assets/pdf.png')),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                        ),
                        InkWell(
                          onTap: () {
                            _pickImage().whenComplete(() {
                              if (errorPicking) {
                                showSnackBar1("Error while picking image");
                              } else {
                                showSnackBar1("Complete");
                              }
                              waitUrl = false;
                            });
                          },
                          child: SizedBox(
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
                        onTap: () {
                          pickFile('mp4').whenComplete(
                            () {
                              if (errorPicking) {
                                showSnackBar1("Error while picking video");
                              } else {
                                mp4 = filePath;
                                showSnackBar1("Complete");
                              }
                              waitUrl = false;
                            },
                          );
                        },
                        child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.15,
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: Image.asset('assets/mp4.png')),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                      ),
                      InkWell(
                        onTap: () {
                          pickFile('doc').whenComplete(
                            () {
                              if (errorPicking) {
                                showSnackBar1("Error while picking word");
                              } else {
                                word = filePath;
                                showSnackBar1("Complete");
                              }
                              waitUrl = false;
                            },
                          );
                        },
                        child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.15,
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: Image.asset('assets/office.png')),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.blue,
                ),
                child: MaterialButton(
                  onPressed: waitUrl
                      ? null
                      : () async {
                          if (taskNameController.value.text != "" &&
                              description.value.text != "") {
                            DateTime now = DateTime.now();
                            String formattedDate =
                                "${now.hour}:${now.minute} ${now.day}-${now.month}-${now.year}";
                            await Future.delayed(const Duration(seconds: 2));
                            addTask(
                                description.value.text,
                                taskNameController.value.text,
                                formattedDate,
                                widget.lastIndex + 1);
                            Navigator.pop(context);
                          }
                        },
                  child: const Text(
                    "Add",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
