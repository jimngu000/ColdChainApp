import 'package:http/http.dart' as http;
import 'dart:convert'

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> initializeDB() async {
  String path = await getDatabasesPath();
  return openDatabase(
    join(path, 'healthcare_facility.db'),
    onCreate: (database, version) async {
      await database.execute(
        "CREATE TABLE districts(id INTEGER PRIMARY KEY, name TEXT)",
      );
      await database.execute(
        "CREATE TABLE hospitals(id INTEGER PRIMARY KEY, name TEXT, districtId INTEGER, FOREIGN KEY(districtId) REFERENCES districts(id))",
      );
      await database.execute(
        "CREATE TABLE refrigerators(id INTEGER PRIMARY KEY, name TEXT, hospitalId INTEGER, FOREIGN KEY(hospitalId) REFERENCES hospitals(id))",
      );
    },
    version: 1,
  );
}


Future<void> fetchDataAndPopulateDB() async {
  var url = Uri.parse('https://your-backend-url/api/districts/');
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    await syncDataOnLogin(jsonResponse['districts']);
  } else {
    throw Exception('Failed to fetch data from the backend. Status code: ${response.statusCode}');
  }
}

// Given a list of districts, set up the
Future<void> syncDataOnLogin(List<dynamic> districts) async {
  final db = await initializeDB();
  Batch batch = db.batch();

  for (var district in districts) {
    int districtId = await db.insert('districts', {
      'id': district['id'],
      'name': district['name'],
    });

    for (var hospital in district['hospitals']) {
      int hospitalId = await db.insert('hospitals', {
        'id': hospital['id'],
        'name': hospital['name'],
        'districtId': districtId,
      });

      for (var refrigerator in hospital['refrigerators']) {
        batch.insert('refrigerators', {
          'id': refrigerator['id'],
          'name': refrigerator['name'],
          'hospitalId': hospitalId,
        });
      }
    }
  }

  await batch.commit(noResult: true);
}
