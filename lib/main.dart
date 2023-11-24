import 'package:firebase_applicationfffirebase_1/screens/homepage.dart';
import 'package:firebase_applicationfffirebase_1/screens/registerScreen.dart';
import 'package:firebase_applicationfffirebase_1/screens/uploadscreen.dart';
import 'package:firebase_applicationfffirebase_1/service/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBD7O-hQq-rH8qPw2GtZFsmAm2s0dfI8mM",
        appId: "1:506366493277:android:a6d20396bfef72f910c3b4",
        messagingSenderId: "506366493277",
        projectId: "dummy-b92c5",
        storageBucket: 'gs://dummy-b92c5.appspot.com',
      ),
    );

    print("Initialized Firebase");
  } catch (e) {
    print("Error initializing Firebase: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        key: UniqueKey(), // Provide a key for the StreamBuilder
        stream: AuthService().firebaseAuth.authStateChanges(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Loading state
            return const CircularProgressIndicator();
          } else if (snapshot.hasData) {
            // User authenticated
            return  homePage(user: snapshot.data,);
          } else if (snapshot.hasError) {
            // Handle error state
            return const Text('Error occurred');
          } else {
            // User not authenticated
            return  Register();
          }
        },
      ),
    );
  }
}
