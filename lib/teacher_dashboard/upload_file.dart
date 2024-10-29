import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
// Uploading Files with different extensions to storage and return the link
class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadFile(File file) async {
    String? url;
    final fileName = file.path.split('/').last;
    final storagePath = fileName; 
    final storageRef = _storage.ref().child(storagePath);
    final uploadTask = storageRef.putFile(file);

    await uploadTask.whenComplete(() async {
    
    final downloadUrl = await storageRef.getDownloadURL();
    url = downloadUrl;
      
    });
   return url;
  }
}
