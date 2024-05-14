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
  List<dynamic> users = [];

  Future<bool> fetchUsers() async {
    try {
      var url = Uri.parse('http://localhost:8000/logistics/getAllUserInfo');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        users = json.decode(response.body);
        return true;
      }
      return false;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  int validateCredentials(String username, String password) {
    for (var user in users) {
      if (user['fields']['username'] == username && user['fields']['password'] == password) {
        if (user['fields']['is_system_admin']) {
          return 2; // admin
        }
        return 1; // DM
      }
    }
    return -1; // Unauthorized
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
    _authenticator.fetchUsers();
  }

  void _login() async {
    int isValid = _authenticator.validateCredentials(
      _usernameController.text,
      _passwordController.text,
    );
    if (isValid == -1) {
      setState(() {
        print('Failed to log in with username: ${_usernameController.text} and password: ${_passwordController.text}');
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
