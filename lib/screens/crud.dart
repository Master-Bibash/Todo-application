 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_applicationfffirebase_1/service/auth_service.dart';
import 'package:flutter/material.dart';

class crud extends StatelessWidget {
  FirebaseFirestore firestore=FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      actions: [
       TextButton.icon(onPressed: ()async{
        await AuthService().signOut();

        

       },
        icon: Icon(Icons.logout), label: Text("signout"))
      ],
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: ()async{
              CollectionReference users=firestore.collection('users');

              //makes a random key and stores the data
              // await users.add({
              //   'name':"biabsh",


              // });
              await users.doc("special person").set({
                'name':"biabsh"
              });

            },
             child: Text("add data")),
             ElevatedButton(onPressed: ()async{
              // shows all data
              CollectionReference users=firestore.collection('users');
              // QuerySnapshot allResults=await users.get();
              // allResults.docs.forEach((DocumentSnapshot result) {
              //   print(result.data()); 


              // });
            
            //show particular data only
              DocumentSnapshot result=await users.doc('special person').get();
              print(result.data());
              // for real time data change
              // users.doc('special person').snapshots().listen((value) {
              //   print(value.data());
              //  });
             },
              child: Text("show data")),

              SizedBox(height: 20,),
              ElevatedButton(onPressed: ()async{
                await firestore.collection('users').doc('special person').update({
                  'name':"bibash dai ko je"
                });


              }, 
              
                child: Text("update data")),
                 SizedBox(height: 20,),
                   ElevatedButton(onPressed: ()async{
                    await firestore.collection('users').doc('special person').delete();
             


              }, 
              
                child: Text("delete data")),

          ],
        ),
      ),
    );
  }
}