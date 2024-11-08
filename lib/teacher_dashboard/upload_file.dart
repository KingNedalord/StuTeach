import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

// Uploading Files with different extensions to storage and return the link
class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadFile(File file) async {
    String downloadUrl = "";
    final fileName = file.path.split('/').last;
    final storagePath = fileName;
    final storageRef = _storage.ref().child(storagePath);
    final uploadTask = storageRef.putFile(file);

    await uploadTask.whenComplete(() async {
      downloadUrl = await storageRef.getDownloadURL();
    });
    if (downloadUrl == "") {
      print("RETURNED ERROR");
      return "error";
    } else {
      print("RETURNED DOWNLOADURL");
      return downloadUrl;
    }
  }
}
