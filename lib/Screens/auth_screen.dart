import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../widget/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var isLoading = false;

  Future<void> _submitAuthenticationForm(
      {String email,
      String password,
      String fullName,
      String role,
      bool isLogin,
      BuildContext ctx}) async {
    final auth = Provider.of<Auth>(context, listen: false);
    UserCredential userCredential;

    try {
      setState(() {
        isLoading = true;
      });
      if (isLogin) {
        print('Login');
        userCredential = await auth.login(email: email, password: password);
      } else {
        print('create new');
        userCredential = await auth.createUser(
          email: email,
          password: password,
        );
        print(userCredential.user.uid);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user.uid)
            .set(
          {
            'email': email,
            'fullname': fullName,
            'isAdmin': role == 'admin' ? true : false,
          },
        );
      }
    } catch (e) {
      var message = 'An Error Occurred';
      if (e.message != null) {
        message = e.message;
      }

      //stops loading when there is an error
      setState(() {
        isLoading = false;
      });

      // _showErrorDialog(message);
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthenticationForm, isLoading),
    );
  }
}
