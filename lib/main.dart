import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_study/Screens/auth_screen.dart';
import 'package:provider/provider.dart';
// 09073090711
import './Screens/stations_overview_screen.dart';
import 'package:flutter/material.dart';

import './providers/auth.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => Auth())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Firebase.initializeApp();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: Text('Loading...'),
              ),
            );
          }
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: Center(
                    child: Text('Loading...2'),
                  ),
                );
              }
              if (userSnapshot.hasData) {
                final uid = FirebaseAuth.instance.currentUser.uid;
                Provider.of<Auth>(context, listen: false)
                    .storeUserDataLocally(uid)
                    .then((value) {
                  print(userSnapshot.data.uid);
                });
                return StationsOverviewScreen(userSnapshot.data.uid);
              }
              return AuthScreen();
            },
          );
        },
      ),
    );
  }
}
