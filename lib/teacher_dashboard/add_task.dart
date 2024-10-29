import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stu_teach/teacher_dashboard/upload_file.dart';

class AddTask extends StatefulWidget {
  final last_index;
  const AddTask({super.key, required this.last_index});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  File? _pdf;
  File? _video;
  File? _word;
  File? _audio;
  String? pdf;
  String? word;
  String? video;
  String? image;
  String? audio;
// Picking files of all extensions except of images 
  Future<void> pickFile(String extension) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: extension != "doc" ? [extension] : ["docx", "doc"],
    );
    if (result != null) {
      if (extension == 'pdf') {
        _pdf = File(result.files.single.path!);
        pdf = await FirebaseStorageService().uploadFile(_pdf!);
    
      } else if (extension == 'doc') {
        _word = File(result.files.single.path!);
        word = await FirebaseStorageService().uploadFile(_word!);
     
      } else if (extension == 'mp4') {
        _video = File(result.files.single.path!);
        video = await FirebaseStorageService().uploadFile(_video!);
  
      }else if (extension == 'ogg') {
        _audio = File(result.files.single.path!);
        audio = await FirebaseStorageService().uploadFile(_audio!);
        
      }
    }
  }

  File? _image;
  final ImagePicker _picker = ImagePicker();
// Picking Images
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      image = await FirebaseStorageService().uploadFile(_image!);
    }
  }
// Adding to firestore
  Future<void> addTask(
      String description, String task_name, String time, int id) async {
    FirebaseFirestore.instance.collection("task").add({
      "description": description,
      "task_name": task_name,
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
  TextEditingController task_name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adding tasks"),
      ),
      body: SafeArea(
        child: Container(
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
                  controller: task_name,
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
                          onTap: () {
                            _pickImage();
                          },
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
                        onTap: () {
                          pickFile('mp4');
                        },
                        child: Container(
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
                        },
                        child: Container(
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
                    if (task_name.value.text != "" &&
                        description.value.text != "") {
                      DateTime now = DateTime.now();
                      String formattedDate =
                          "${now.hour}:${now.minute} ${now.day}-${now.month}-${now.year}";
                      if (formattedDate != "") {
                        addTask(description.value.text, task_name.value.text,
                            formattedDate, widget.last_index + 1);
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: Text(
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
