import 'package:flutter/material.dart';
import 'package:herewego/model/post_model.dart';
import 'package:herewego/services/prefs_service.dart';
import 'package:herewego/services/rtdb_service.dart';

class DetailPage extends StatefulWidget {
  static final String id = "detail_page";
  const DetailPage({Key? key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
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

    RTDBService.addPost(new Post(id, firstname, lastname, content, date)).then((value) => {
      _respAddPost()
    });
  }

  _respAddPost() {
    Navigator.of(context).pop({'data': 'done'});
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
                child: Text("Add"),
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