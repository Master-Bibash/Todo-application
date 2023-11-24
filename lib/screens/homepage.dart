import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_applicationfffirebase_1/models/node.dart';
import 'package:firebase_applicationfffirebase_1/screens/addNoteScreen.dart';
import 'package:firebase_applicationfffirebase_1/screens/editNote.dart';
import 'package:firebase_applicationfffirebase_1/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class homePage extends StatefulWidget {
  homePage({required this.user});
  User user;

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
              onPressed: () async {
                await AuthService().signOut();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('notes')
            .where('userid', isEqualTo: widget.user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.length > 0) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  NoteModel note =
                      NoteModel.fromJson(snapshot.data!.docs[index]);
                  return Card(
                    color: Colors.teal,
                    elevation: 5,
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                       title: Text(
                        note.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        maxLines: 2,
                      ),
                      subtitle: Text(
                        note.description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(color: Colors.white),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                     
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => editNOteScreen(note),
                        ));
                      },
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text("No Notes Ava"),
              );
            }
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      )

      // ListView(
      //   children: [
      //      Card(
      //       color: Colors.teal,
      //       elevation: 5,
      //       margin: const EdgeInsets.all(10),
      //       child: ListTile(
      //         onTap: () {
      //           Navigator.of(context).push(MaterialPageRoute(builder: (context) => const editNOteScreen(),));
      //         },
      //         subtitle: const Text(
      //           "Learn to build a clone of clubhouse application from udaemy",
      //           overflow: TextOverflow.ellipsis,
      //           maxLines: 2,
      //         ),
      //         contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      //         title: const Text(
      //           "build a new app",
      //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      //         ),
      //       ),
      //     )
      //   ],
      // ),
      ,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddNoteScreen(widget.user)));
        },
        backgroundColor: Colors.orangeAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
