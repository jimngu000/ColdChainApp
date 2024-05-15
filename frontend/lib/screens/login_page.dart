import 'package:flutter/material.dart';
import 'package:logistics/screens/admin_page.dart';

import '../models/user.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'district_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Logistics Login Page',
      home: LoginPage(),
    );
  }
}

class UserAuthenticator {
  Future<int> validateCredentials(String username, String password) async {
    try {
      var url = Uri.parse('http://localhost:8000/logistics/logIn/$username/$password');
      var response = await http.get(url);
      if (response.statusCode != 200) {
        return Future(() => -2);
      }
      return Future(() => int.parse(response.body));
    } catch (e) {
      print('Error: $e');
      return Future(() => -2);
    }
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final UserAuthenticator _authenticator = UserAuthenticator();

  @override
  void initState() {
    super.initState();
  }

  void _login() async {
    int isValid = await _authenticator.validateCredentials(
      _usernameController.text,
      _passwordController.text,
    );
    if (isValid == -1) {
      setState(() {
        print('Unauthorized with username: ${_usernameController.text} and password: ${_passwordController.text}');
      });
    } else if (isValid == -2) {
      setState(() {
        print('Server error with username: ${_usernameController.text} and password: ${_passwordController.text}');
      });
    } else {
      setState(() {
        print('Logging in with username: ${_usernameController.text} and password: ${_passwordController.text}');
        if (isValid == 1) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => DistrictPage()),
          );
        }
        if (isValid == 2) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => SystemAdministratorPage()),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Log In'),
            ),
          ],
        ),
      ),
    );
  }
}
