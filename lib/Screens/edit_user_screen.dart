import 'package:flutter/material.dart';

enum Roles {
  Admin,
  SalesRep,
}

class EditUserScreen extends StatefulWidget {
  final stationId;

  const EditUserScreen({Key key, this.stationId}) : super(key: key);

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _form = GlobalKey<FormState>();
  Roles _selectedRole = Roles.SalesRep;
  String _role;
  var _isSuperAdmin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.black38,
            height: MediaQuery.of(context).size.height,
          ),
          Container(
            decoration: BoxDecoration(border: Border.all()),
            padding: const EdgeInsets.all(20.0),
            child: Form(
              // autovalidate: true,
              key: _form,
              child: Column(
                children: [
                  TextFormField(
                    key: ValueKey('email'),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value.isEmpty ||
                          !value.contains(RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      // _email = value.trim();
                    },
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                    ),
                  ),
                  TextFormField(
                    key: ValueKey('full_name'),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value.isEmpty ||
                          value.length < 4 ||
                          !value.trim().contains(' ')) {
                        return 'Please enter your correct info';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      // _fullName = value.trim();
                    },
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      // border: InputBorder.none,
                    ),
                  ),
                  TextFormField(
                    key: ValueKey('phone'),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value.isEmpty || value.length < 11) {
                        return 'Please enter your correct number';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      // _fullName = value.trim();
                    },
                    decoration: InputDecoration(
                      labelText: 'Phone number',
                      // border: InputBorder.none,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DropdownButton(
                      key: ValueKey('role'),
                      isExpanded: true,
                      value: _selectedRole,
                      items: [
                        DropdownMenuItem(
                          child: Text('Admin Role'),
                          value: Roles.Admin,
                        ),
                        DropdownMenuItem(
                          child: Text("Sales Rep"),
                          value: Roles.SalesRep,
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedRole = value;
                          switch (_selectedRole) {
                            case Roles.Admin:
                              _role = 'admin';
                              break;
                            case Roles.SalesRep:
                              _role = 'salesRep';
                              _isSuperAdmin = false;
                              break;
                          }
                        });
                      }),
                  TextFormField(
                    key: ValueKey('password'),
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return 'Password must be atleast 7 characters';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      // _password = value.trim();
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
                      // border: InputBorder.none,
                    ),
                    obscureText: true,
                  ),
                  TextFormField(
                    key: ValueKey('confirm_password'),
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return 'Password must be atleast 7 characters';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      // _password = value.trim();
                    },
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      // border: InputBorder.none,
                    ),
                    obscureText: true,
                  ),
                  if (_selectedRole == Roles.Admin)
                    SizedBox(
                      height: 20,
                    ),
                  if (_selectedRole == Roles.Admin)
                    Row(
                      children: [
                        Checkbox(
                          key: ValueKey('super'),
                          onChanged: (bool value) {
                            setState(() {
                              _isSuperAdmin = value;
                            });
                          },
                          value: _isSuperAdmin,
                        ),
                        Text(
                          'Make user a super admin',
                          style: TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  Material(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(40),
                    ),
                    child: InkWell(
                      onTap: () {},
                      splashColor: Colors.indigo,
                      borderRadius: BorderRadius.all(
                        Radius.circular(40),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Create Account',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
