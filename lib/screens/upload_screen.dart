import 'dart:io';
import 'dart:math';
//import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class upload_screen extends StatefulWidget {
  const upload_screen({super.key});

  @override
  State<upload_screen> createState() => _upload_screenState();
}

class _upload_screenState extends State<upload_screen> {

  //Image picker package

  File? _image;
  final picker = ImagePicker();

  //method for image picking

  Future getImageGallery() async
  {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if(pickedFile!=null)
      {
        _image = File(pickedFile.path);
        setState(() {

        });
      }
    else
      {
        print("Image not selected");
      }


  }

  //Firebase storage instance

 // FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
//  DatabaseReference _databaseRef = FirebaseDatabase.instance.ref('post_data');

  //Firebase Database instance

 final _firebaseRef = FirebaseDatabase.instance.ref('post_data');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text("Upload Image To Firebase Screen",style: TextStyle(fontSize: 20,color: Colors.white),),
      ),
      body:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 50,
          ),
         const  Text("Posting data to Firebase Where We Will Store Image path",style: TextStyle(fontSize: 15,color: Colors.white),),
          const SizedBox(
            height: 50,
          ),
          InkWell(
            onTap: ()async
            {
             print('Calling posting data method:');
             dynamic id = DateTime.now().microsecondsSinceEpoch;
             print(id);
             _firebaseRef.child(id.toString()).set({
               'id': id.toString(),
               'data': 'Data which will be dynamic in future'
             }).then((value) {
               print('..............');
               print('Successfully Done');
             }
              ).onError((error, stackTrace){
               print('..............');
               print('error occur ${error}');
             });
             print('method end');
            },
            child: Container(
              height: 40,
              width: 200,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25)
              ),
              child: Center(child: Text("Post Data",style: TextStyle(color: Colors.black,fontSize: 21),),),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Select Image ",style: TextStyle(color: Colors.white,fontSize: 20),),
              InkWell(
                onTap: (){
                  print("Calling getting Image method");
                  getImageGallery();
                },
                  child: Icon(Icons.image,color: Colors.white,))
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          Container(
            height: 200,
            width: 200,
            color: Colors.white,
            child: _image!=null ? Image.file(_image!.absolute,fit: BoxFit.cover,) : Container(color: Colors.white,),
          ),
          const SizedBox(
            height: 50,
          ),
          InkWell(
            onTap: ()async
            {
              print(".........calling firebase storage code.......");

              final _ref = FirebaseStorage.instance.ref('/folder_name/'+'image_link');
              UploadTask _uploadTask = _ref.putFile(_image!.absolute);

              await Future.value(_uploadTask).then((value)async{
                print('success');
                var new_url = await _ref.getDownloadURL();

                dynamic id = DateTime.now().microsecondsSinceEpoch;
                _firebaseRef.child(id.toString()).set({
                  'id': id.toString(),
                  'data': new_url.toString()
                }).then((value){
                  print('..............');
                  print('Successfully Done');
                  print('..............');
                }).onError((error, stackTrace){
                  print('error inside future ${error}');
                });
              }).onError((error, stackTrace){
                print('error in future method: ${error}');
              });
            },
            child: Container(
              height: 40,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25)
              ),
              child: Center(child: Text("Upload Image",style: TextStyle(color: Colors.black,fontSize: 21),),),
            ),
          )
        ],
      ),
    );
  }
}
