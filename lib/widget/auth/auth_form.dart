import 'package:firebase_study/widget/loading.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';

enum Roles {
  Admin,
  SalesRep,
}

class AuthForm extends StatefulWidget {
  final void Function({
    String email,
    String password,
    String fullName,
    String role,
    bool isLogin,
    BuildContext ctx,
  }) submitForm;
  final bool isLoading;

  const AuthForm(this.submitForm, this.isLoading);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  String _fullName;
  bool _isLogin = true;
  Roles _selectedRole = Roles.SalesRep;
  String _role;

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();

      widget.submitForm(
        email: _email,
        password: _password,
        fullName: _fullName,
        role: _role,
        isLogin: _isLogin,
        ctx: context,
      );
      print('isLogin: $_isLogin');
      print('FullName: $_fullName');
      print('Role: $_role');
      print('Email: $_email');
      print('Password: ${_password.hashCode}');
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // THE EMAIL FIELD
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: kPrimaryLightColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(40),
                ),
              ),
              child: TextFormField(
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
                  _email = value.trim();
                },
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            //THE FULL NAME FIELD
            if (!_isLogin)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  color: kPrimaryLightColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(40),
                  ),
                ),
                child: TextFormField(
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
                    _fullName = value.trim();
                  },
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    border: InputBorder.none,
                  ),
                ),
              ),
            if (!_isLogin)
              SizedBox(
                height: 12,
              ),
            // THE ROLES FIELD
            if (!_isLogin)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  color: kPrimaryLightColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(40),
                  ),
                ),
                child: DropdownButton(
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
                            break;
                        }
                      });
                    }),
              ),
            if (!_isLogin)
              SizedBox(
                height: 12,
              ),
            // THE PASS FIELD
            Container(
              key: ValueKey('password'),
              padding: EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: kPrimaryLightColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(40),
                ),
              ),
              child: TextFormField(
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value.isEmpty || value.length < 7) {
                    return 'Password must be atleast 7 characters';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value.trim();
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: InputBorder.none,
                ),
                obscureText: true,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            // THE SUBMIT BUTTON
            widget.isLoading
                ? Loading()
                : Material(
                    animationDuration: Duration(milliseconds: 400),
                    color: Colors.indigo,
                    borderRadius: BorderRadius.all(
                      Radius.circular(40),
                    ),
                    child: InkWell(
                      onTap: _trySubmit,
                      highlightColor: kPrimaryColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(40),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            _isLogin ? 'Sign In' : 'Create Account',
                            style: TextStyle(
                              color: kPrimaryLightColor,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            // ALREADY HAS ACCOUNT CHECK
            if (!widget.isLoading)
              FlatButton(
                child: Text(
                  _isLogin
                      ? 'Create new Acount'
                      : 'Already have an account? Login',
                  style: TextStyle(fontSize: 17, color: kPrimaryLightColor),
                ),
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                  });
                },
              )
          ],
        ),
      ),
    );
  }
}
