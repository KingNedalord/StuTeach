import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stu_teach/teacher_dashboard/upload_file.dart';

class AddTask extends StatefulWidget {
  final int lastIndex;
  const AddTask({super.key, required this.lastIndex});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  String? pdf;
  String? word;
  String? video;
  String? image;
  String? audio;
  bool errorPicking = false;
  void showSnackBar1(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Error with picking file.. Retry!"),
      dismissDirection: DismissDirection.vertical,
      duration: Duration(seconds: 3),
    ));
  }

// Picking files of all extensions except of images
  Future<void> pickFile(String extension) async {
    File? pdf1;
    File? video1;
    File? word1;
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: extension != "doc" ? [extension] : ["docx", "doc"],
    );
    if (result != null) {
      if (extension == 'pdf') {
        pdf1 = File(result.files.single.path!);
        pdf = await FirebaseStorageService().uploadFile(pdf1);
        if (pdf == "error") {
          setState(() {
            errorPicking = true;
          });
        } else {
          errorPicking = false;
        }
      } else if (extension == 'doc') {
        word1 = File(result.files.single.path!);
        word = await FirebaseStorageService().uploadFile(word1);
        if (word == "error") {
          setState(() {
            errorPicking = true;
          });
        } else {
          errorPicking = false;
        }
      } else if (extension == 'mp4') {
        video1 = File(result.files.single.path!);
        video = await FirebaseStorageService().uploadFile(video1);
        if (video == "error") {
          setState(() {
            errorPicking = true;
          });
        } else {
          errorPicking = false;
        }
      }
    }
  }

  final ImagePicker _picker = ImagePicker();
// Picking Images
  Future<void> _pickImage() async {
    File image1;
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image1 = File(pickedFile.path);

      image = await FirebaseStorageService().uploadFile(image1);
      if (image == "error") {
        setState(() {
          errorPicking = true;
        });
      } else {
        errorPicking = false;
      }
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
      "isDone": false,
      "image": image,
      "video": video,
      "word": word,
      "pdf": pdf
    });
  }

  TextEditingController description = TextEditingController();
  TextEditingController taskNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adding tasks"),
      ),
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
                          onTap: () {
                            pickFile('pdf');
                            if (errorPicking) {
                              showSnackBar1(context);
                            }
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
                            _pickImage();
                            if (errorPicking) {
                              showSnackBar1(context);
                            }
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
                          pickFile('mp4');
                          if (errorPicking) {
                            showSnackBar1(context);
                          }
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
                          pickFile('doc');
                          if (!errorPicking) {
                            showSnackBar1(context);
                          }
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
                  onPressed: () {
                    if (taskNameController.value.text != "" &&
                        description.value.text != "") {
                      DateTime now = DateTime.now();
                      String formattedDate =
                          "${now.hour}:${now.minute} ${now.day}-${now.month}-${now.year}";
                      if (formattedDate != "") {
                        addTask(
                            description.value.text,
                            taskNameController.value.text,
                            formattedDate,
                            widget.lastIndex + 1);
                        Navigator.pop(context);
                      }
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
