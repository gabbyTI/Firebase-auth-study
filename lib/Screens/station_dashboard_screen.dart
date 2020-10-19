import 'package:firebase_study/Screens/edit_user_screen.dart';
import 'package:firebase_study/widget/dashboard_tabs/employee_users_tab_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../widget/dashboard_tabs/add_shipment_tab_screen.dart';
import '../widget/dashboard_tabs/sales_tab_screen.dart';
import '../widget/dashboard_tabs/transactions_tab_screen.dart';
import '../providers/auth.dart';
// import 'package:intl/intl.dart';

class StationDashboardScreen extends StatefulWidget {
  final String id;
  static const routeName = 'station-dashboard-screen';

  const StationDashboardScreen({Key key, this.id}) : super(key: key);

  @override
  _StationDashboardScreenState createState() => _StationDashboardScreenState();
}

class _StationDashboardScreenState extends State<StationDashboardScreen> {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pages = [
      {
        'page': SalesTabScreen(widget.id),
        'title':
            'Sales Record Date: ${DateFormat('MMMM d, yyy').format(DateTime.now())}',
      },
      {
        'page': TransationsTabScreen(widget.id),
        'title': 'Transactions',
      },
      {
        'page': AddShipmentTabScreen(widget.id),
        'title': 'New Shipment',
      },
      {
        'page': EmployeeUserTabScreen(widget.id),
        'title': 'Users',
      },
    ];
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<Auth>(context, listen: false).usersData;
    final isAdmin = userData['isAdmin'];
    // ignore: unused_local_variable
    final size = MediaQuery.of(context).size;
    final appBar = AppBar(
      title: FittedBox(
        child: Text(_pages[_selectedPageIndex]['title']),
      ),
      actions: [
        if (_selectedPageIndex == 3)
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditUserScreen(),
                  ));
            },
            icon: Icon(
              Icons.add,
              size: 30,
            ),
          )
      ],
    );
    return Scaffold(
      appBar: appBar,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        unselectedItemColor: Colors.indigo[200],
        onTap: _selectPage,
        // type: BottomNavigationBarType.shifting,
        currentIndex: _selectedPageIndex,
        selectedItemColor: Theme.of(context).accentColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Make sales',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Transactions',
          ),
          if (isAdmin)
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(Icons.add_box),
              label: 'Add Shipments',
            ),
          if (isAdmin)
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(Icons.supervised_user_circle),
              label: 'Users',
            ),
        ],
      ),
      body: _pages[_selectedPageIndex]['page'],
    );
  }
}
