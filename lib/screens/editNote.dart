import 'package:firebase_applicationfffirebase_1/models/node.dart';
import 'package:firebase_applicationfffirebase_1/service/firebase_service.dart';
import 'package:flutter/material.dart';



@immutable
class editNOteScreen extends StatefulWidget {

NoteModel note;
editNOteScreen(this.note);

  @override
  State<editNOteScreen> createState() => _editNOteScreenState();
}

class _editNOteScreenState extends State<editNOteScreen> {
  TextEditingController titleController=TextEditingController();
  TextEditingController descriptionController=TextEditingController();
  bool loading=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController.text=widget.note.title;
    descriptionController.text=widget.note.description;
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: ()async{
            await showDialog(context: context,
             builder: (context) {
              return AlertDialog(
                title: Text("please confirm"),
                content: Text("Are you sure to delete the note?"),
                actions: [
                  //yes button
                  TextButton(onPressed: ()async{
                    await FirebaseService().deleteNote(widget.note.id);
                    //close the dialog
                    Navigator.pop(context);
                  },
                   child: Text("yes"))
                   ,
                    TextButton(onPressed: (){
                      Navigator.pop(context);
                    },
                   child: Text("No"))
                ],
              );
            
             } ,);
          }, 
          icon: Icon(Icons.delete,color: Colors.red,))
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Title",style: TextStyle(fontSize: 30,
            fontWeight: FontWeight.bold
            ),),
            SizedBox(height: 20,),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 30,),
             Text("Description",style: TextStyle(fontSize: 30,
            fontWeight: FontWeight.bold
            ),),
             TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder()
              ),
            ),
              SizedBox(height: 30,),
               loading? CircularProgressIndicator() :    Container(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(onPressed: ()async{
                  if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required")));
                    
                  }else{
                    setState(() {
                      loading=true;
                    });
                    
                    await FirebaseService().updateNote(widget.note.id, titleController.text,descriptionController.text);

                  }
                  Navigator.pop(context);

                },
                style: ElevatedButton.styleFrom(primary: Colors.orange),
                 child: Text("Update Now",style: TextStyle(
                  fontSize: 25,fontWeight: FontWeight.bold,
                  
                 ),)),
              )




          ],
        ),
        ),
      ),
    );
  }
}