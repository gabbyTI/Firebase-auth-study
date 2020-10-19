import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_study/constants.dart';
import 'package:firebase_study/providers/auth.dart';
import 'package:firebase_study/widget/loading.dart';
import 'package:provider/provider.dart';

import '../widget/stations.dart';
import 'package:flutter/material.dart';

class StationsOverviewScreen extends StatelessWidget {
  final userId;

  const StationsOverviewScreen(this.userId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stations'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            offset: Offset(15.0, 40.0),
            onSelected: (value) {
              if (value == 'Logout') {
                Provider.of<Auth>(context, listen: false).logout();
              }
            },
            itemBuilder: (context) => <PopupMenuEntry>[
              PopupMenuItem(
                child: PopupMenuItem(
                  value: 'Logout',
                  child: Row(
                    children: [
                      Icon(
                        Icons.exit_to_app,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Logout'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
        future:
            FirebaseFirestore.instance.collection('users').doc(userId).get(),
        // ignore: missing_return
        builder: (ctx, userSnapshot) {
          if (userSnapshot.hasError) {
            return Center(
              child: Text('Error'),
            );
          }
          switch (userSnapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Loading();
              break;
            case ConnectionState.done:
              // final userData = userSnapshot.data;
              return Stations();
              break;
          }
        },
      ),
    );
  }
}
