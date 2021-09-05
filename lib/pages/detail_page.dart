import 'dart:io';

import 'package:flutter/material.dart';
import 'package:herewego/model/post_model.dart';
import 'package:herewego/services/prefs_service.dart';
import 'package:herewego/services/rtdb_service.dart';
import 'package:herewego/services/store_service.dart';
import 'package:image_picker/image_picker.dart';

class DetailPage extends StatefulWidget {
  static final String id = "detail_page";
  const DetailPage({Key? key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  File? _image;
  final picker = ImagePicker();

  bool isLoading = false;
  var firstnameController = TextEditingController();
  var lastnameController = TextEditingController();
  var contentController = TextEditingController();
  var dateController = TextEditingController();



  _addPost() async {
    String firstname = firstnameController.text.toString();
    String lastname = lastnameController.text.toString();
    String content = contentController.text.toString();
    String date = dateController.text.toString();

    var id = await Prefs.loadUserId();
    if (firstname.isEmpty || lastname.isEmpty || content.isEmpty || date.isEmpty) return;
    _apiUploadImage(firstname, lastname, content, date);
  }

  void _apiUploadImage(firstname, lastname, content, date) {
    setState(() {
      isLoading = true;
    });
    StoreService.uploadImage(_image!).then((img_url) => {
      _apiAddPost(firstname, lastname, content, date, img_url),
    });
  }

  _apiAddPost(firstname, lastname, content, date, img_url) async {
    var id = await Prefs.loadUserId();
    RTDBService.addPost(new Post(id, firstname, lastname, content, date, img_url)).then((response) => {
      _respAddPost(),
    });
  }

  _respAddPost() {
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop({'data': 'done'});
  }

  Future _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Post"),
      ),
      body: SingleChildScrollView(
              padding: EdgeInsets.all(25),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _getImage,
                    child: Container(
                      width: double.infinity,
                      height: 250,
                      child: _image != null ?
                      Image.file(_image!,fit: BoxFit.cover) :
                      Image.asset("assets/images/ic_camera.png"),
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextField(
                    controller: firstnameController,
                    decoration: InputDecoration(
                        hintText: "Firstname",
                        hintStyle: TextStyle(color: Colors.grey)
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextField(
                    controller: lastnameController,
                    decoration: InputDecoration(
                        hintText: "Lastname",
                        hintStyle: TextStyle(color: Colors.grey)
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextField(
                    controller: contentController,
                    decoration: InputDecoration(
                        hintText: "Content",
                        hintStyle: TextStyle(color: Colors.grey)
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextField(
                    controller: dateController,
                    decoration: InputDecoration(
                        hintText: "Date",
                        hintStyle: TextStyle(color: Colors.grey)
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      child: Stack(
                        children: [
                          isLoading != true ?
                          Center(child: Text("Add")):
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(color: Colors.white,),
                                SizedBox(width: 10),
                                Text("Please wait", style: TextStyle(fontSize: 18, color: Colors.white),)
                              ],
                            ),
                          )
                        ],
                      ),
                      onPressed: (){
                        _addPost();
                      },
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
















