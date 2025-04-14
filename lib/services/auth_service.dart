import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:tpm_tugas3/main.dart';
import 'package:tpm_tugas3/pages/homePage.dart';

class AuthService {
  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context
  }) async {
    // try {
    //   await FirebaseAuth.instance.signInWithEmailAndPassword(
    //       email: email,
    //       password: password
    //   );
    //
    //   await Future.delayed(const Duration(seconds: 1));
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
    //     return homePage();
    //   }));
    // } on FirebaseAuthException catch (e) {
    //   print(e);
    // }
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        print('No user found for that email.');
      } else if (e.code == '') {
        print('Wrong password provided for that user.');
      } else {
        print(e.code);
      }
    } catch (e) {
      print(FirebaseAuth.instance.currentUser);
    }
  }
}