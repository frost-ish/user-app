import 'package:firebase_auth/firebase_auth.dart';

enum Code {
  weakPassword,
  emailInUse,
  successful,
  unknownError,
  userNotFound,
  wrongPassword,
}

Future<Code> signInUser(String email, String password) async {
  try {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return Code.successful;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      return Code.userNotFound;
    } else if (e.code == 'wrong-password') {
      return Code.wrongPassword;
    } else {
      return Code.unknownError;
    }
  }
}
