import 'package:cloud_firestore/cloud_firestore.dart';


class FirebaseService{
  FirebaseFirestore fireStore= FirebaseFirestore.instance;

  Future insertNote(String title,String description,String userId)async{
     try {
      await fireStore.collection('notes').add({
        "title":title,
        "description":description,
        "date":DateTime.now(),
        "userid":userId,
      });
       
     } catch (e) {
       
     }

     
  }
  Future updateNote(String docId,String description,String title)async{
      try {
        await fireStore.collection('notes').doc(docId).update({
          "title":title,
          'description':description,
          

        });
        
      } catch (e) {print(
        e
      );
        
      }
     }
     Future deleteNote(String docId)async{
      try {
        await fireStore.collection('notes').doc(docId).delete();
        
      } catch (e) {
        print(e);
        
      }
     }
}