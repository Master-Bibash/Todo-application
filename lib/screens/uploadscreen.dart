import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({Key? key}) : super(key: key);

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  bool loading = false;

  Future<void> uploadImage(String inputSource) async {
    final picker = ImagePicker();
    final XFile? pickImage = await picker.pickImage(
      source: inputSource == "camera" ? ImageSource.camera : ImageSource.gallery,
    );

    if (pickImage == null) {
      return null;
    }

    String fileName = pickImage.name;
    File imageFile = File(pickImage.path);

    try {
      setState(() {
        loading = true;
      });

      await firebaseStorage.ref(fileName).putFile(imageFile);

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Successfully uploaded")),
      );
    } on FirebaseException catch (e) {
      print("Firebase Exception: $e");
    } catch (error) {
      print("Generic Error: $error");
    }
  }

  Future<List> loadingImage() async {
  List<Map> files = [];
  try {
    final ListResult result = await firebaseStorage.ref().listAll();
    final List<Reference> allFiles = result.items;

    await Future.forEach(allFiles, (Reference file) async {
      final String fileUrl = await file.getDownloadURL();
      print("File URL: $fileUrl"); // Add this line for debugging
      files.add({
        'url': fileUrl,
        'path': file.fullPath,
      });
    });
  } catch (e) {
    print("Error loading images: $e");
  }

  print("Files: $files"); // Add this line for debugging
  return files;
}
Future<void> delete(String ref)async{
  await firebaseStorage.ref(ref).delete();
  setState(() {
    
  });

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload to Firebase Storage"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          loading
              ? Center(child: CircularProgressIndicator())
              : ElevatedButton.icon(
                  onPressed: () {
                    uploadImage("camera");
                  },
                  icon: Icon(Icons.camera_alt_outlined),
                  label: Text("Camera"),
                ),
          ElevatedButton.icon(
            onPressed: () {
              uploadImage('gallery');
            },
            icon: Icon(Icons.library_add),
            label: Text("Gallery"),
          ),
          SizedBox(height: 20),
          Expanded(
            child: FutureBuilder(
              future: loadingImage(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('no data foundd'),);
                  
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length ?? 0,
                  itemBuilder: (context, index) {
                    final Map image = snapshot.data![index];
                    return Row(
                      children: [
                        Expanded(
                          child: Card(
                            child: Container(
                              height: 100,
                              child: Image.network(image['url']),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async{
                            await delete(image['path']);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("image deleted")));
                          
                          },
                          icon: Icon(Icons.delete, color: Colors.red),
                        )
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

