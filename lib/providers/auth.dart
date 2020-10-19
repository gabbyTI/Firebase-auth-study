import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

class Auth with ChangeNotifier {
  bool _isAdmin;
  String _userStationId;
  String _userFullname;

  Map<String, dynamic> get usersData {
    return {
      'isAdmin': _isAdmin,
      'userStationId': _userStationId.trim(),
      'userFullname': _userFullname.trim(),
    };
  }

  Future<UserCredential> login({String email, String password}) async {
    await Firebase.initializeApp();
    final _auth = FirebaseAuth.instance;
    UserCredential userCredential;
    userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    await storeUserDataLocally(userCredential.user.uid);
    print('i am logging you in');
    return userCredential;
  }

  Future<UserCredential> createUser({String email, String password}) async {
    await Firebase.initializeApp();
    final _auth = FirebaseAuth.instance;
    UserCredential userCredential;

    userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    await storeUserDataLocally(userCredential.user.uid);
    print('i am creating new user');
    return userCredential;
  }

  Future<void> storeUserDataLocally(String uid) async {
    final authUser =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    // debugPrint('Initializing user data: ${authUser.data()['fullname']}');
    // if (_isAdmin != null || _isAdmin.toString().isNotEmpty) _isAdmin = null;
    // if (_userStationId != null || _userStationId.toString().isNotEmpty)
    //   _userStationId = null;
    // if (_userFullname != null || _userFullname.toString().isNotEmpty)
    //   _userFullname = null;
    _isAdmin = authUser.data()['isAdmin'];
    _userStationId = authUser.data()['stationId'];
    _userFullname = authUser.data()['fullname'];
    debugPrint('inserted $_userStationId');
    return 'success';
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      debugPrint('Logging you out');
      _isAdmin = null;
      _userStationId = null;
      _userFullname = null;
    } catch (e) {
      debugPrint('Error logging out: ${e.message.toString()}');
      throw e;
    }
  }
}
