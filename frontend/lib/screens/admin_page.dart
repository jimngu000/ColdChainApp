import 'package:flutter/material.dart';

//import '../models/managers.dart';

import 'package:http/http.dart' as http;
import 'package:logistics/models/hospital.dart';
import 'dart:convert';

import '../models/conflictlog.dart';
import '../models/log.dart';
import '../models/user.dart';
import '../models/access.dart';
import 'log_page.dart';

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
    List<User> users = [];
    for (int i = 0; i < userJson.length; i ++) {
      User tmp = User.fromJson(userJson[i]);
      if (tmp.username != "admin") {
        users.add(tmp);
      }
    }
    return users;
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

Future<List<Log>> getAllLog() async {
  final response =
  await http.get(Uri.parse("http://10.0.2.2:8000/logistics/getLog"));
  if (response.statusCode == 200) {
    List<dynamic> logJson = json.decode(response.body);
    return logJson.map((j) {
      return Log.fromJson(j);
    }).toList();
  } else {
    throw Exception("Fail to load log");
  }
}

Future<List<int>> getAllConflict() async {
  final response =
  await http.get(Uri.parse("http://10.0.2.2:8000/logistics/getConflictLog"));
  if (response.statusCode == 200) {
    List<dynamic> logJson = json.decode(response.body);
    List<ConflictLog> conflicts = logJson.map((j) {
      return ConflictLog.fromJson(j);
    }).toList();
    List<int> logIds = [];
    for (int i = 0; i < conflicts.length; i ++) {
      logIds.add(conflicts[i].log);
    }
    return logIds;
  } else {
    throw Exception("Fail to load conflict log");
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
  late Future<List<Access>?> _accessFuture;
  late Future<List<Log>?> _logFuture;
  late Future<List<int>?> _conflictFuture;
  late Future<List<Hospital>?> _hospitalsFuture;
  late Future<List<User>?> _usersFuture;
  bool _isAccessExpanded = false;
  bool _isLogExpanded = false;
  bool _isConflictLogExpanded = false;

  @override
  void initState() {
    super.initState();
    _accessFuture = _loadAccess();
    _logFuture = _loadLog();
    _conflictFuture = _loadConflict();
    _hospitalsFuture = _loadHospitals();
    _usersFuture = _loadUsers();
  }

  @override
  void dispose() {
    super.dispose();
  }

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

  Future<List<Log>?> _loadLog() async {
    try {
      List<Log> log = await getAllLog();
      return log;
    } catch(e) {
      print('Failed to fetch or save log: $e');
      return Future.error('Failed to load data');
    }
  }

  Future <List<int>?> _loadConflict() async {
    try {
      List<int> log = await getAllConflict();
      return log;
    } catch(e) {
      print('Failed to fetch or save log: $e');
      return Future.error('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {

    void _cancel() {
      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('System Administrator '),
      ),
      body: //ListViewWithFutureAccess(futureList: accessList,),
        SingleChildScrollView(
          child: Column(
            children:[
              ListTile( // Access
                title: Text("Permission"),
                trailing: Icon(
                  _isAccessExpanded
                    ? Icons.expand_less
                    : Icons.expand_more,
                ),
                onTap: () {
                  setState(() {
                    _isAccessExpanded = !_isAccessExpanded;
                  });
                },
              ),
              if (_isAccessExpanded)
                FutureBuilder<List<Access>?>(
                  future: _accessFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (snapshot.hasData && snapshot.data != null) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, idx) => Card(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          elevation: 2.0,
                          child: ListTile(
                            // permission content
                            title: Text("${snapshot.data![idx].name} district id: ${snapshot.data![idx].district} hospital id: ${snapshot.data![idx].hospital}"),
                            onTap: null, // modify this if we want to do something with the permission
                          ),
                        ),
                      );
                    }
                    return const Center(child: Text('No Data'));
                  },
                ),
              ListTile( // logs
                title: Text("Log"),
                trailing: Icon(
                  _isLogExpanded
                    ? Icons.expand_less
                    : Icons.expand_more,
                ),
                onTap: () {
                  setState(() {
                    _isLogExpanded = !_isLogExpanded;
                  });
                },
              ),
              if (_isLogExpanded)
                FutureBuilder<List<Log>?>(
                  future: _logFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (snapshot.hasData && snapshot.data != null) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, idx) => Card(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          elevation: 2.0,
                          child: ListTile(
                            // log content
                            title: Text('''${snapshot.data![idx].id} user id: ${snapshot.data![idx].user}
                              district id: ${snapshot.data![idx].district} hospital id: ${snapshot.data![idx].hospital}
                              refrigerator id: ${snapshot.data![idx].refrigerator} timestamp: ${snapshot.data![idx].timestamp}'''),
                            onTap: () async {
                              debugPrint('admin page to log page');
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LogPage(log: snapshot.data![idx],),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }
                    return const Center(child: Text('No Logs'));
                  },
                ),
              ListTile( // conflicts
                title: Text("Conflicts"),
                trailing: Icon(
                  _isConflictLogExpanded
                    ? Icons.expand_less
                    : Icons.expand_more,
                ),
                onTap: () {
                  setState(() {
                    _isConflictLogExpanded = !_isConflictLogExpanded;
                  });
                },
              ),
              if (_isConflictLogExpanded)
                FutureBuilder<List<int>?>(
                  future: _conflictFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (snapshot.hasData && snapshot.data != null) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, idx) => Card(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          elevation: 2.0,
                          child: ListTile(
                            // permission content
                            title: Text("Log id: ${snapshot.data![idx]}"),
                            onTap: null, // modify this if we want to do something with the permission
                          ),
                        ),
                      );
                    }
                    return const Center(child: Text('No Data'));
                  },
                ),
            ]
          ),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Assign/Reassign Manager'),
              content: Row(
                children: [UserDropdownMenu(
                  selectedUser: selectedUser,
                  itemsFuture: _usersFuture,
                  onChanged: (value) {
                    setState(() {
                      selectedUser = value;
                    });
                  },
                ),
                SizedBox(width: 10,),
                HospitalDropdownMenu(
                  selectedHospital: selectedHospital,
                  itemsFuture: _hospitalsFuture,
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
                        _accessFuture = _loadAccess();
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
