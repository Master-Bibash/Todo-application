import 'package:firebase_applicationfffirebase_1/service/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddNoteScreen extends StatefulWidget {
  AddNoteScreen(this.user);
  User user;

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  TextEditingController titleCOntroller = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool Loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Title",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: titleCOntroller,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Description",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: descriptionController,
                maxLines: 4,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 30,
              ),
              Loading
                  ? CircularProgressIndicator()
                  : Container(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (titleCOntroller.text.isEmpty ||
                                descriptionController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('All fields are required')));
                            } else {
                              setState(() {
                                Loading = true;
                              });
                            }
                            await FirebaseService().insertNote(
                                titleCOntroller.text,
                                descriptionController.text,
                                widget.user.uid);
                            setState(() {
                              Loading = false;
                            });
                            Navigator.pop(context);
                          },
                          style:
                              ElevatedButton.styleFrom(primary: Colors.orange),
                          child: Text(
                            "add Note",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
