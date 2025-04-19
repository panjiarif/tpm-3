import 'package:flutter/material.dart';
import 'package:tpm_tugas3/pages/homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_session_jwt/flutter_session_jwt.dart';
import 'package:tpm_tugas3/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? error;
  bool visible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            'Selamat Datang',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 10),
        _usernameField(),
        _passwordField(),
        _loginButton(context),
      ],
    ));
  }

  Widget _usernameField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        enabled: true,
        controller: _emailController,
        decoration: InputDecoration(
          hintText: 'Email',
          contentPadding: const EdgeInsets.all(8.0),
          border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Colors.red)),
        ),
      ),
    );
  }

  Widget _passwordField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        enabled: true,
        controller: _passwordController,
        obscureText: visible,
        decoration: InputDecoration(
          hintText: 'Password',
          contentPadding: const EdgeInsets.all(8.0),
          border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Colors.red)),
          suffixIcon: IconButton(
            icon: Icon(visible ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                visible = !visible;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: () async {
          await AuthService().signin(
            email: _emailController.text,
            password: _passwordController.text,
            context: context
          );

          if (FirebaseAuth.instance.currentUser != null) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
              return homePage();
            }));
          }
        },
        child: Text("Login"),
      ),
    );
  }
}
