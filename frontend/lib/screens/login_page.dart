import 'package:flutter/material.dart';
import 'package:logistics/main.dart';
import 'package:logistics/screens/admin_page.dart';

import '../models/district.dart';
import '../models/hospital.dart';
import '../models/refrigerator.dart';
import '../models/user.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../utils/district_db_helper.dart';
import '../utils/hospital_db_helper.dart';
import '../utils/refrigerator_db_helper.dart';
import 'district_page.dart';
import 'globals.dart' as globals;

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

Future<List<District>> getAllDistricts() async {
  final response =
  await http.get(Uri.parse("http://10.0.2.2:8000/logistics/getAllDistricts"));
  if (response.statusCode == 200) {
    List<dynamic> districtsJson = json.decode(response.body);
    return districtsJson.map((json) {
      return District.fromJson(json);
    }).toList();
  } else {
    throw Exception('Failed to load districts');
  }
}

Future<List<Hospital>> getAllHospitals() async {
  final response =
  await http.get(Uri.parse("http://10.0.2.2:8000/logistics/getAllHospitals"));
  if (response.statusCode == 200) {
    List<dynamic> hospitalsJson = json.decode(response.body);
    return hospitalsJson.map((json) {
      return Hospital.fromJson(json);
    }).toList();
  } else {
    throw Exception('Failed to load hospitals');
  }
}

Future<List<Refrigerator>> getFridgeByUserId() async {
  String userId = globals.userId.toString();
  var url = Uri.parse("http://10.0.2.2:8000/logistics/getFridgeAssignments/$userId");
  final response = await http.get(url);
  if (response.statusCode == 200) {
    List<dynamic> fridgesJson = json.decode(response.body);
    return fridgesJson.map((json) {
      return Refrigerator.fromJson(json);
    }).toList();
  } else {
    throw Exception('Failed to load some fridges');
  }
}

class UserAuthenticator {
  Future<int> validateCredentials(String username, String password) async {
    try {
      var url = Uri.parse('http://10.0.2.2:8000/logistics/logIn/$username/$password');
      var response = await http.get(url);
      if (response.statusCode != 200) {
        return Future(() => -2);
      }
      var strArr = response.body.split(",");
      print(response.body);//del
      globals.userId = int.parse(strArr[0]);
      globals.username = strArr[1];
      return Future(() => int.parse(strArr[2]));
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

  /*
  Future<List<District>?> _loadDistricts() async {
    try {
      // Fetch districts from the API
      List<District> districts = await getAllDistricts();
      return districts;
    } catch (e) {
      print('Failed to fetch or save districts: $e');
      return Future.error('Failed to load data');
    }
  }
  */

  void load_local_db() async {
    // all districts and hospitals and necessary fridges
    try {
      List<District> districts = await getAllDistricts();
      List<Hospital> hospitals = await getAllHospitals();
      List<Refrigerator> fridges = await getFridgeByUserId();
      if (districts.isNotEmpty) {
        final DistrictDatabaseHelper dDBHelper = DistrictDatabaseHelper();
        districts.map((a) {dDBHelper.insertDistrict(a);});
      }
      if (hospitals.isNotEmpty) {
        final HospitalDatabaseHelper hDBHelper = HospitalDatabaseHelper();
        hospitals.map((a) {hDBHelper.insertHospital(a);});
      }
      if (fridges.isNotEmpty) {
        final RefrigeratorDatabaseHelper rDBHelper = RefrigeratorDatabaseHelper();
        fridges.map((a) {rDBHelper.insertRefrigerator(a);});
      }
    } catch (e) {
      print('Failed to fetch or save db: $e');
    }
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
          load_local_db();
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
