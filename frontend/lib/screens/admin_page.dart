import 'package:flutter/material.dart';

//import '../models/managers.dart';

import 'package:http/http.dart' as http;
import 'package:logistics/models/hospital.dart';
import 'dart:convert';

import '../models/user.dart';
import '../models/access.dart';

Future<List<Hospital>> getAllHospitals() async {
  final response =
  await http.get(Uri.parse("http://10.0.2.2:8000/logistics/getAllHospitals"));
  if (response.statusCode == 200) {
    List<dynamic> hospitalJson = json.decode(response.body);
    return hospitalJson.map((json) {
      return Hospital.fromJson(json);
    }).toList();
  } else {
    throw Exception('Failed to load hospitals');
  }
}

Future<List<User>> getAllUserInfo() async {
  final response =
  await http.get(Uri.parse("http://10.0.2.2:8000/logistics/getAllUserInfo"));
  if (response.statusCode == 200) {
    List<dynamic> userJson = json.decode(response.body);
    return userJson.map((json) {
      return User.fromJson(json);
    }).toList();
  } else {
    throw Exception('Failed to load users');
  }
}

Future<List<Access>> getAllAccess() async {
  final response =
  await http.get(Uri.parse("http://10.0.2.2:8000/logistics/getAllAccess"));
  if (response.statusCode == 200) {
    List<dynamic> accessJson = json.decode(response.body);
    return accessJson.map((json) {
      return Access.fromJson(json);
    }).toList();
  } else {
    throw Exception('Failed to load access');
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manager Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SystemAdministratorPage(),
    );
  }
}

class SystemAdministratorPage extends StatefulWidget {
  @override
  _SystemAdministratorPageState createState() =>
      _SystemAdministratorPageState();
}

class _SystemAdministratorPageState extends State<SystemAdministratorPage> {
  User? selectedUser;
  Hospital? selectedHospital;
  late Future<List<Access>?> accessList;

  Future<List<Hospital>?> _loadHospitals() async {
    try {
      // Fetch hospitals from the API
      List<Hospital> hospitals = await getAllHospitals();
      return hospitals;
    } catch (e) {
      print('Failed to fetch or save hospitals: $e');
      return Future.error('Failed to load data');
    }
  }

  Future<List<User>?> _loadUsers() async {
    try {
      // Fetch users from the API
      List<User> users = await getAllUserInfo();
      return users;
    } catch (e) {
      print('Failed to fetch or save users: $e');
      return Future.error('Failed to load data');
    }
  }

  Future<List<Access>?> _loadAccess() async {
    try {
      // Fetch access from the API
      List<Access> access = await getAllAccess();
      return access;
    } catch (e) {
      print('Failed to fetch or save access: $e');
      return Future.error('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {

    void _cancel() {
      Navigator.of(context).pop();
    }

    accessList = _loadAccess();

    return Scaffold(
      appBar: AppBar(
        title: Text('System Administrator '),
      ),
      body: ListViewWithFutureAccess(futureList: accessList,),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Assign/Reassign Manager'),
              content: Row(
                children: [UserDropdownMenu(
                  selectedUser: selectedUser,
                  itemsFuture: _loadUsers(),
                  onChanged: (value) {
                    setState(() {
                      selectedUser = value;
                    });
                  },
                ),
                SizedBox(width: 10,),
                HospitalDropdownMenu(
                  selectedHospital: selectedHospital,
                  itemsFuture: _loadHospitals(),
                  onChanged: (value) {
                    setState(() {
                      selectedHospital = value;
                    });
                  },
                ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    if (selectedUser != null) {
                      print('Selected Manager: $selectedUser');
                      // update access db
                      Access newAccess = Access(name: selectedUser!.username, user: selectedUser!.id, hospital: selectedHospital!.id);
                      String jsonBody = jsonEncode(newAccess.toJson());
                      jsonBody = "[$jsonBody]";
                      final response = await http.post(
                        Uri.parse('http://10.0.2.2:8000/logistics/addAccess'),
                        headers: {
                          'Content-Type': 'application/json',
                        },
                        body: jsonBody,
                      );
                      setState(() {
                        accessList = _loadAccess();
                      });
                      print(response.body);
                      _cancel();
                    }
                  },
                  child: Text('Assign'),
                ),
              ],
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}


class HospitalDropdownMenu extends StatelessWidget {
  final Future<List<Hospital>?> itemsFuture;
  final Function(Hospital?) onChanged;
  final Hospital? selectedHospital;

  const HospitalDropdownMenu({
    required this.itemsFuture,
    required this.onChanged,
    required this.selectedHospital,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Hospital>?>(
      future: itemsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No items available');
        } else {
          return DropdownMenu<Hospital>(
            label: Text(selectedHospital?.name ?? "Choose a hospital"),
            onSelected: onChanged,
            dropdownMenuEntries: snapshot.data!.map<DropdownMenuEntry<Hospital>>((Hospital value) {
              return DropdownMenuEntry<Hospital>(
                value: value,
                label: value.name,
              );
            }).toList(),
          );
        }
      },
    );
  }
}

class UserDropdownMenu extends StatelessWidget {
  final Future<List<User>?> itemsFuture;
  final Function(User?) onChanged;
  final User? selectedUser;

  const UserDropdownMenu({
    required this.itemsFuture,
    required this.onChanged,
    required this.selectedUser,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>?>(
      future: itemsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No items available');
        } else {
          return DropdownMenu<User>(
            hintText: "Choose a user",
            label: Text(selectedUser?.username ?? "Choose a user"),
            onSelected: onChanged,
            dropdownMenuEntries: snapshot.data!.map<DropdownMenuEntry<User>>((User value) {
              return DropdownMenuEntry<User>(
                value: value,
                label: value.username,
              );
            }).toList(),
          );
        }
      },
    );
  }
}

class ListViewWithFutureAccess extends StatelessWidget {
  final Future<List<Access>?> futureList;

  ListViewWithFutureAccess({required this.futureList});

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder<List<Access>?>(
      future: futureList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text("${snapshot.data![index].name} district id: ${snapshot.data![index].district} hospital id: ${snapshot.data![index].hospital}"),
                ),
              );
            },
          );
        } else {
          return Center(child: Text('No data available'));
        }
      },
    );
  }
}