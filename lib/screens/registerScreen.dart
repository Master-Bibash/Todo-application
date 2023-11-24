import 'package:firebase_applicationfffirebase_1/screens/loginScreen.dart';
import 'package:firebase_applicationfffirebase_1/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';


class Register extends StatefulWidget {
  Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController conformPassword = TextEditingController();
  bool loading=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("register"),
      ),
      body: Column(
        children: [
          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: "Email"),
          ),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(labelText: "password"),
          ),
          TextField(
            controller: conformPassword,
            decoration: const InputDecoration(labelText: "Confirm password"),
          ),
           loading?  CircularProgressIndicator(): ElevatedButton(
            
              onPressed: () async {
                setState(() {
                  loading=true;
                });
                if (emailController.text.isEmpty ||
                    passwordController.text.isEmpty) {
                  const AlertDialog(
                    content: Text("fill the field"),
                  );
                } else if (passwordController.text != conformPassword.text) {
                  const AlertDialog(
                    content: Text("pass no match"),
                  );
                } else {
                  User? result = await AuthService().register(
                      emailController.text, passwordController.text, context);
                  if (result != null) {
                    print("success");
                    print(result.email);
                  }
                }
                setState(() {
                  loading=false;
                });
              },
              child: const Text("Submit")
              ),
              TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: const Text("have an account?")),
              SizedBox(height: 10,),
              Divider(),
            loading
    ? CircularProgressIndicator()
    : SignInButton(
        Buttons.Google,
        text: "Continue with Google",
        onPressed: () async {
          setState(() {
            loading = true;
          });
          User? user = await AuthService().signInWithGoogle();
          if (user != null) {
            print("User signed in: ${user.displayName}");
          } else {
            print("Google sign-in failed");
          }
          setState(() {
            loading = false;
          });
        },
      )

        ],
      ),
    );
  }
}
