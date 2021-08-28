import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:herewego/pages/signin_page.dart';
import 'package:herewego/services/prefs_service.dart';
import 'package:herewego/services/utils_service.dart';

class AuthService{
  static final _auth = FirebaseAuth.instance;

  static Future<User?> signInUser(BuildContext context, String email, String password) async {
    try {
      _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user =  _auth.currentUser!;
      print(user.toString());
      return user;
    }  on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          {
            Utils.fireToast('Email is not valid');
          } break;
        case 'user-disabled':
          {
          Utils.fireToast('Account is not active');
          } break;
        case 'user-not-found':
          {
          Utils.fireToast( 'No user found');
          } break;
        case 'wrong-password':
          {
          Utils.fireToast( 'wrong password');
          } break;
        default:
          {
          Utils.fireToast( 'Unexpected error!');
          }
      }
    }
    //return null;
  }

  static Future<User?> signUpUser(BuildContext context, String name, String email, String password) async {
    try {
      var authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = authResult.user;
      print(user.toString());
      return user;
    }  on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          {
            Utils.fireToast('Email is not valid');
          } break;
        case 'user-disabled':
          {
            Utils.fireToast('Account is not active');
          } break;
        case 'user-not-found':
          {
          Utils.fireToast('No user found');
          } break;
        case 'wrong-password':
          {
          Utils.fireToast('wrong password');
          } break;
        default:
          {
          Utils.fireToast('Unexpected error!');
          }
      }
    }
    return null;
  }

  static void signOutUser(BuildContext context) {
    _auth.signOut();
    Prefs.removeUserId().then((value) {
      Navigator.pushReplacementNamed(context, SignInPage.id);
    });
  }
}

/*
class AuthService {

  static final _auth = FirebaseAuth.instance;

  static Future<UserCredential?> signInUser(BuildContext context, String email, String password) async {

    FirebaseApp secondaryApp = Firebase.app('SecondaryApp');
    FirebaseAuth _auth = FirebaseAuth.instanceFor(app: secondaryApp);
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);


    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: "barry.allen@example.com",
          password: "SuperSecretPassword!"
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }

  }
}
*/
/*
class AuthService {
  static final _auth = FirebaseAuth.instance;

  createUser(email, password) async {
    try{
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      _auth.create
    } catch(e) {
      print("Xatolik_SignUp: $e");

    }
  }

  loginUser(email, password) async {
    try{
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch(e) {
      print("Xatolik_login: $e");
    }
  }

}
*/