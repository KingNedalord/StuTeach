import 'package:firebase_auth/firebase_auth.dart';


class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currenUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String>signInWithEmailAndPassword({
    required String email,
    required String password
  })async{
     UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    String uid = userCredential.user!.uid;
    return uid;
  }
  
  Future<void>createUserWithEmailAndPassword({
    required String email,
    required String password
  })async{
    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

Future<void>signOut()async{
  await _firebaseAuth.signOut();
}
}