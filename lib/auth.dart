import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty_mobile_app/components/reusable/show_snack_bar.dart';
import 'package:hedieaty_mobile_app/pages/auth/sign_in.dart';
import 'package:hedieaty_mobile_app/static/data.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signUpWithEmailAndPassword(String email, String password,
      String name, String phone, BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        await storeUserProfile(user, name, email, phone);
      }

      Navigator.of(context).pop();
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      Navigator.of(context).pop();
      showSnackBarError(context, e.toString());
    }
  }

  Future<void> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.of(context).pop();
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      Navigator.of(context).pop();
      showSnackBarError(context, e.toString());
    }
  }

  Future<void> signOut(BuildContext context) async {
    await _firebaseAuth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const SignIn(),
      ),
      (route) => false,
    );
  }

  Future<void> storeUserProfile(
      User user, String name, String email, String phone) async {
    await _firestore.collection('Users').doc(user.uid).set({
      'id': user.uid,
      'name': name,
      'email': email,
      'phone': phone,
      'picture': StaticData.defaultUserImage,
      'preferences': '',
      'friends': [],
    });
  }

  Future<DocumentSnapshot> get currentUser async {
    User? user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('User is not signed in');
    }
    return await _firestore.collection('Users').doc(user.uid).get();
  }
}
