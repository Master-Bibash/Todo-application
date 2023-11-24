import 'package:firebase_applicationfffirebase_1/screens/crud.dart';
import 'package:firebase_applicationfffirebase_1/screens/registerScreen.dart';
import 'package:firebase_applicationfffirebase_1/screens/uploadscreen.dart';
import 'package:firebase_applicationfffirebase_1/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("register"),
      ),
      body: Column(
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: "Email"),
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(labelText: "password"),
          ),
          loading
              ? CircularProgressIndicator()
              : ElevatedButton(
                
                  onPressed: () async {
                    setState(() {
                      loading=true;
                    });
                    if (emailController.text.isEmpty ||
                        passwordController.text.isEmpty) {
                      AlertDialog(
                        content: Text("fill the field"),
                      );
                    } else {
                      User? result = await AuthService()
                          .Login(emailController.text, passwordController.text);
                      if (result != null) {
                        print("success");
                        print(result.email);
                        Navigator.pushAndRemoveUntil(context,
                         MaterialPageRoute(builder: (context)=>crud()),
                          (route) => false);
                      }
                    }
                    setState(() {
                      loading=false;
                    });
                  },
                  child: Text("Login")),
          TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Register()));
              },
              child: Text("Dont have an account?"))
        ],
      ),
    );
  }
}
