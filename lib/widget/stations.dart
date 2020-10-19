import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_study/Screens/station_dashboard_screen.dart';
import 'package:firebase_study/providers/auth.dart';
import 'package:firebase_study/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Stations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<Auth>(context, listen: false).usersData;
    print('I am printing user station id here: ${userData['userStationId']}');
    return userData['isAdmin']
        ? _buildAdminView()
        : _buildNonAdminView(userStationId: userData['userStationId']);
  }

  FutureBuilder<DocumentSnapshot> _buildNonAdminView({String userStationId}) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('stations')
          .doc('$userStationId')
          .get(),
      // ignore: missing_return
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error'),
          );
        }
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Loading();
            break;
          case ConnectionState.done:
            return Card(
              elevation: 2,
              shadowColor: Colors.blue,
              child: Material(
                child: InkWell(
                  onTap: () {
                    print(userStationId);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            StationDashboardScreen(id: userStationId),
                      ),
                    );
                  },
                  highlightColor: Colors.white10,
                  child: ListTile(
                    title: Text(snapshot.data['label']),
                  ),
                ),
              ),
            );
            break;
        }
      },
    );
  }

  StreamBuilder<QuerySnapshot> _buildAdminView() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('stations').snapshots(),
      builder: (ctx, stationSnapshot) {
        if (stationSnapshot.connectionState == ConnectionState.waiting) {
          return Loading();
        }
        final stationsDoc = stationSnapshot.data.docs;
        return ListView.builder(
          itemCount: stationsDoc.length,
          itemBuilder: (context, index) => Card(
            elevation: 2,
            shadowColor: Colors.blue,
            child: Material(
              child: InkWell(
                onTap: () {
                  print(stationsDoc[index].id);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          StationDashboardScreen(id: stationsDoc[index].id),
                    ),
                  );
                },
                highlightColor: Colors.white10,
                child: ListTile(
                  title: Text(stationsDoc[index]['label']),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
