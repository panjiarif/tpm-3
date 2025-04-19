import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tpm_tugas3/pages/homePage.dart';

class AuthService {
  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      if (e.code == 'invalid-credential') {
        errorMessage = 'Email atau password salah!';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Email tidak valid!';
      } else if (e.code == 'channel-error') {
        errorMessage = 'Email dan password tidak boleh kosong!';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Password salah!';
      }else {
        errorMessage = e.code;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      String errorMessage = '';
      FirebaseAuth.instance.currentUser != null ? errorMessage = 'Login sebagai $FirebaseAuth.instance.currentUser' : '';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}