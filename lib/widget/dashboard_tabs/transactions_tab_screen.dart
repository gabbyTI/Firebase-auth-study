import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../loading.dart';

class TransationsTabScreen extends StatelessWidget {
  static const routeName = 'transactions-screen';
  final id;
  TransationsTabScreen(this.id);

  @override
  Widget build(BuildContext context) {
    //TODO Fix there where statement problem
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('transactions')
          .where('stationId', isEqualTo: id)
          .orderBy('createdAt', descending: true)
          .get(),
      builder: (context, transactionSnapshot) {
        if (transactionSnapshot.connectionState == ConnectionState.waiting) {
          return Loading();
        }
        if (transactionSnapshot.hasError) {
          print(transactionSnapshot.error.toString());
          return Center(
              child: Text('Error: ${transactionSnapshot.error.toString()}'));
        }
        final transations = transactionSnapshot.data.docs;
        if (transactionSnapshot.hasData) {
          print(transations.toString());
        }
        return ListView.builder(
          itemCount: transations.length,
          itemBuilder: (context, index) => FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(transations[index]['userId'])
                  // .where('stationId', isEqualTo: id.toString().trim())
                  .get(),
              builder: (context, userSnapshot) {
                final user = userSnapshot.data;
                return Card(
                  elevation: 2,
                  shadowColor: Colors.blue,
                  child: Material(
                    child: InkWell(
                      onTap: () async {
                        print(user['fullname']);
                        await showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.8,
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    color: Colors.indigoAccent,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 18),
                                          child: Text(
                                            'Transaction Details',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          icon: Icon(
                                            Icons.close_outlined,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                    height: 50,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          initialValue: transations[index]
                                                  ['commodity']
                                              .toString()
                                              .toUpperCase(),
                                          enabled: false,
                                          decoration: InputDecoration(
                                              labelText: 'Commodity',
                                              labelStyle: TextStyle(
                                                  color: Colors.indigo)),
                                        ),
                                        TextFormField(
                                          initialValue: user['fullname']
                                              .toString()
                                              .toUpperCase(),
                                          enabled: false,
                                          decoration: InputDecoration(
                                              labelText: 'Transaction by',
                                              labelStyle: TextStyle(
                                                  color: Colors.indigo)),
                                        ),
                                        TextField(),
                                        TextField(),
                                        TextField(),
                                        TextField(),
                                        TextField(),
                                        TextField(),
                                        TextField(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      highlightColor: Colors.white10,
                      child: ListTile(
                        title: Text(transations[index]['commodity']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('MMMM d, yyy').format(
                                DateTime.parse(
                                  transations[index]['date'],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              transations[index]['transaction_type']
                                  .toString()
                                  .toUpperCase(),
                            ),
                          ],
                        ),
                        isThreeLine: true,
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(transations[index]['amount'].toString()),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
        );
      },
    );
  }
}
