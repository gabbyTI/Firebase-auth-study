import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_study/widget/loading.dart';
import 'package:flutter/material.dart';

class SalesTabScreen extends StatefulWidget {
  final id;
  static const routeName = 'sales-screen';

  const SalesTabScreen(this.id);

  @override
  _SalesTabScreenState createState() => _SalesTabScreenState();
}

class _SalesTabScreenState extends State<SalesTabScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('stations')
          .doc(widget.id.trim())
          .snapshots()
          .first,
      // ignore: missing_return
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Loading();
            break;
          case ConnectionState.done:
            break;
        }
        if (snapshot.hasError) return Center(child: Text('Error'));
        if (snapshot.hasData) {
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(border: Border.all()),
                // padding: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                height: (size.height * 0.25),
                // decoration: BoxDecoration(color: Colors.black54),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              FittedBox(child: Text('Fuel Total')),
                              FittedBox(
                                  child: Text('${snapshot.data['fuelTotal']}')),
                              FittedBox(child: Text('litres')),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              FittedBox(child: Text('Kerosene Total')),
                              FittedBox(
                                  child: Text('${snapshot.data['keroTotal']}')),
                              FittedBox(child: Text('litres')),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              FittedBox(child: Text('Diesel Total')),
                              FittedBox(
                                  child:
                                      Text('${snapshot.data['dieselTotal']}')),
                              FittedBox(child: Text('litres')),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  // margin: EdgeInsets.only(top: size.height * 0.25),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      RaisedButton(
                        child: Text('MAKE FUEL SALE'),
                        onPressed: () {},
                      ),
                      RaisedButton(
                        child: Text('MAKE KERO SALE'),
                        onPressed: () {},
                      ),
                      RaisedButton(
                        child: Text('MAKE DIESEL SALE'),
                        onPressed: () async {
                          // if (true) return;
                          await FirebaseFirestore.instance
                              .collection('transactions')
                              .doc()
                              .set(
                            {
                              'stationId': widget.id,
                              'commodity': 'diesel',
                              'transaction_type': 'sale',
                              'amount': 12,
                              'date': DateTime.now().toIso8601String(),
                              'userId': FirebaseAuth.instance.currentUser.uid,
                              'createdAt': Timestamp.now(),
                            },
                          );
                          debugPrint('recorded new transaction');
                          var total = snapshot.data['dieselTotal'];
                          var newTotal = total - 12;
                          await FirebaseFirestore.instance
                              .collection('stations')
                              .doc(widget.id.trim())
                              .set(
                            {'dieselTotal': newTotal},
                            SetOptions(merge: true),
                          );
                          setState(() {});
                          debugPrint('recorded new transaction');
                        },
                      )
                    ],
                  ),
                  height: size.height * 0.75,
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
