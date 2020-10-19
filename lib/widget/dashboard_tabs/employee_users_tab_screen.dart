import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../loading.dart';

class EmployeeUserTabScreen extends StatelessWidget {
  static const routeName = 'employee-user-tab-screen';
  final id;
  EmployeeUserTabScreen(this.id);

  @override
  Widget build(BuildContext context) {
    print('station ID ...........................$id');
    // return Container();
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('stationId', isEqualTo: id)
          .orderBy('fullname')
          .orderBy('isAdmin', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading();
        }
        if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Center(child: Text('Error: ${snapshot.error.toString()}'));
        }
        if (snapshot.hasData) {
          print(snapshot.data.docs.toString());
        }
        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) => Card(
            elevation: 2,
            shadowColor: Colors.blue,
            child: Material(
              child: InkWell(
                onTap: () {
                  print(snapshot.data.docs[index].id);
                },
                highlightColor: Colors.white10,
                child: ListTile(
                  title: Text(snapshot.data.docs[index]['fullname']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(snapshot.data.docs[index]['email']),
                      SizedBox(
                        height: 5,
                      ),
                      Text(snapshot.data.docs[index]['isAdmin']
                          ? 'Admin'
                          : 'Sales Rep'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
