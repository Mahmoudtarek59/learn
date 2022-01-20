import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class Learn3Screen extends StatefulWidget {
  const Learn3Screen({Key? key}) : super(key: key);

  @override
  _Learn3ScreenState createState() => _Learn3ScreenState();
}

class _Learn3ScreenState extends State<Learn3Screen> {
  File? image;
  String? url;
  getImage()async{
   await ImagePicker().pickImage(source: ImageSource.camera,imageQuality: 10).then((value) {
     image = File(value!.path);
     setState(() {

     });
   });
  }
  uploadImage()async{
    Reference ref = FirebaseStorage.instance.ref().child("image");
    var uploadedImage = await ref.putFile(image!);
    url = await uploadedImage.ref.getDownloadURL();
    print(url);
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if(image!=null)
              Container(
                width: 200.0,
                height: 200.0,
                decoration: BoxDecoration(image: DecorationImage(image: FileImage(image!))),
              ),
            ElevatedButton(onPressed: getImage, child: Text("PickImage")),
            if(url!=null)
              Container(
                width: 200.0,
                height: 200.0,
                decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(url!))),
              ),
            ElevatedButton(onPressed:uploadImage, child: Text("Upload"))
          ],
        ),
      ),
    );
  }
}
