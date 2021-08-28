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
    return null;
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