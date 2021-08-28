import 'package:flutter/material.dart';
import 'package:herewego/services/auth_service.dart';

class HomePage extends StatefulWidget {
  static final String id = "home_page";
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Home"),
      ),
      body: Center(
        child: MaterialButton(
          onPressed: (){
            //AuthService.signUpUser(context, name, email, password)
          },
          color: Colors.deepOrange,
          child: Text("Logout", style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}
