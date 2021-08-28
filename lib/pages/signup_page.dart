import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:herewego/pages/signin_page.dart';
import 'package:herewego/services/auth_service.dart';
import 'package:herewego/services/prefs_service.dart';
import 'package:herewego/services/utils_service.dart';

import 'home_page.dart';

class SignUpPage extends StatefulWidget {
  static final String id = "signup_page";
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  var isLoading = false;

  var fullnameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  _doSignUp(){
    String name = fullnameController.text.toString().trim();
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    if(name.isEmpty || email.isEmpty || password.isEmpty) return;

    setState(() {
      isLoading = true;
    });
    AuthService.signUpUser(context, name, email, password).then((firebaseUser) => {
      _getFirebaseUser(firebaseUser!),
    });
  }

  _getFirebaseUser(User firebaseUser) async {
    setState(() {
      isLoading = false;
    });
    if (firebaseUser != null) {
      await Prefs.saveUserId(firebaseUser.uid);
      Navigator.pushReplacementNamed(context, HomePage.id);
    } else {
      Utils.fireToast("Check your informations");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: fullnameController,
              decoration: InputDecoration(
                hintText: "Fullname",
                hintStyle: TextStyle(color: Colors.grey)
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Email",
                hintStyle: TextStyle(color: Colors.grey)
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Password",
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            SizedBox(height: 10,),
            // #SignUp
            Container(
              height: 45,
              width: double.infinity,
              child: MaterialButton(
                onPressed: (){
                  _doSignUp();
                },
                child: Text("Sign Up", style: TextStyle(color: Colors.white, letterSpacing: 1),),
                color: Color.fromARGB(255, 226, 82, 65),
              ),
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Already have an account?", style: TextStyle(fontSize: 16),),
                TextButton(
                  onPressed: (){
                    Navigator.pushReplacementNamed(context, SignInPage.id);
                  },
                  child: Text("Sign In", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                ),
                SizedBox(width: 10,)
              ],
            )

          ],
        ),
      ),
    );
  }
}
