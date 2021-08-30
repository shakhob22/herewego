import 'package:flutter/material.dart';
import 'package:herewego/model/post_model.dart';
import 'package:herewego/services/auth_service.dart';
import 'package:herewego/services/detail_page.dart';
import 'package:herewego/services/prefs_service.dart';
import 'package:herewego/services/rtdb_service.dart';

class HomePage extends StatefulWidget {
  static final String id = "home_page";
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List items = [];
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiGetPosts();
  }

  Future _openDetail() async{
    Map results = await Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context){
          return new DetailPage();
        }
    ));
    if(results != null && results.containsKey("data")){
      print(results['data']);
      _apiGetPosts();
    }
  }

  _apiGetPosts() async{
    var id = await Prefs.loadUserId();
    RTDBService.getPosts(id!).then((posts) => {
      _respPosts(posts),
    });
  }


  _respPosts(List<Post> posts) async {
    setState(() {
      items = posts;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("All Posts"),
        actions: [
          IconButton(
            onPressed: (){
              AuthService.signOutUser(context);
            },
            icon: Icon(Icons.exit_to_app),
          )
        ],
      ),
      
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (ctx, i) {
          return itemOfList(items[i]);
        },
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          //Navigator.pushNamed(context, DetailPage.id);
          _openDetail();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget itemOfList(Post post) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(post.firstname!+" ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              Text(post.lastname!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
            ],
          ),
          SizedBox(height: 5,),
          Text(post.date!, style: TextStyle(fontSize: 16),),
          SizedBox(height: 5,),
          Text(post.content!, style: TextStyle(fontSize: 16),)
        ],
      ),
    );
  }

}
