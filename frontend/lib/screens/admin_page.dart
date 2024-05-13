import 'package:flutter/material.dart';

import '../models/managers.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class Manager {
  final int? id;
  final String name;

  Manager({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Manager.fromJson(Map<String, dynamic> json) => Manager(
    id: json['id'],
    name: json['name'],
  );

  @override
  String toString() {
    return 'Manager{id: $id, name: $name}';
  }
}

List<Manager> managers = [
  Manager(id: 1, name: 'John Doe'),
  Manager(id: 2, name: 'Jane Smith'),
  Manager(id: 3, name: 'Alice Johnson'),
];

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
  Manager? selectedManager;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('System Administrator '),
      ),
      body: ListView.builder(
        itemCount: managers.length,
        itemBuilder: (context, index) {
          final manager = managers[index];
          return ListTile(
            title: Text(manager.name),
            onTap: () {
              setState(() {
                selectedManager = manager;
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Assign/Reassign Manager'),
              content: DropdownButton<Manager>(
                value: selectedManager,
                hint: Text('Select a Manager'),
                onChanged: (manager) {
                  setState(() {
                    selectedManager = manager;
                  });
                },
                items: managers
                    .map<DropdownMenuItem<Manager>>(
                      (Manager manager) => DropdownMenuItem<Manager>(
                    value: manager,
                    child: Text(manager.name),
                  ),
                )
                    .toList(),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (selectedManager != null) {
                      print('Selected Manager: $selectedManager');
                      Navigator.of(context).pop();
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