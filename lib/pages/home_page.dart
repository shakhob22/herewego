import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:herewego/model/post_model.dart';
import 'package:herewego/services/auth_service.dart';
import 'package:herewego/pages/detail_page.dart';
import 'package:herewego/services/prefs_service.dart';
import 'package:herewego/services/rtdb_service.dart';

class HomePage extends StatefulWidget {
  static final String id = "home_page";
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  List<Post> items = [];
  
  @override
  void initState() {
    super.initState();
    isLoading = true;
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
      RTDBService.getPosts(id!).then((posts) =>
      {
        _respPosts(posts),
      });
    }
  }


  _respPosts(List<Post> posts) async {
    setState(() {
      items = posts;
      isLoading = false;
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
              setState(() {
                isLoading = true;
                _apiGetPosts();
              });
            },
            icon: Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: (){
              AuthService.signOutUser(context);
            },
            icon: Icon(Icons.exit_to_app),
          )
        ],
      ),
      
      body: Stack(
        children: [
          ListView.builder(
            itemCount: items.length,
            itemBuilder: (ctx, i) {
              return itemOfList(items[i]);
            },
          ),
          isLoading == true ?
          Center(child: CircularProgressIndicator()) :
          SizedBox.shrink()
        ],
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
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 250,
            width: double.infinity,
            child: post.img_url != null ?
            Image.network(post.img_url!,fit: BoxFit.cover,):
            Image.asset("assets/images/ic_default.png", fit: BoxFit.cover,),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text(post.firstname!+" ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              Text(post.lastname!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _menu()
                    //Icon(Icons.more_vert)
                  ],
                )
              )
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
  Widget _menu() {
    return PopupMenuButton<int>(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))
      ),
      itemBuilder: (context) => [
        PopupMenuItem<int>(
            value: 0,
            child: Row(
              children: [
                Icon(Icons.add),
                SizedBox(width: 5,),
                Text("Add new post", style: TextStyle(color: Colors.green),)
              ],
            )
        ),
        PopupMenuItem<int>(
            value: 1,
            child: Row(
              children: [
                Icon(Icons.delete),
                SizedBox(width: 5,),
                Text("Delete current post", style: TextStyle(color: Colors.orange),)
              ],
            )
        ),
        PopupMenuDivider(),
        PopupMenuItem<int>(
            value: 2,
            child: Row(
              children: [
                Icon(Icons.cleaning_services_rounded),
                SizedBox(width: 5,),
                Text("Delete all posts", style: TextStyle(color: Colors.red),)
              ],
            )
        ),
      ],
      child: Icon(Icons.more_vert)
    );
  }
  
}
