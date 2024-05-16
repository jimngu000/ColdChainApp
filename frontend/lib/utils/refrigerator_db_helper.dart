// Package imports:
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Project imports:
import '../models/refrigerator.dart';

class RefrigeratorDatabaseHelper {
  static RefrigeratorDatabaseHelper? _refrigeratorDatabaseHelper; // singleton helper

  String refrigeratorTable = 'refrigerator_table';
  String colId = 'id';
  String colHospitalId = 'hospital_id';
  String colUserId = 'user_id';
  String colName = 'name';
  String colManufacturer = 'manufacturer';
  String colTempMonitorInstalled = 'temp_monitor_installed';
  String colMonitorType = 'monitor_type';
  String colMonitorWorking = 'monitor_working';
  String colVoltageRegularInstalled = 'voltage_regular_installed';
  String colRegularType = 'regular_type';
  String colVaccineCount = 'vaccine_count';

  RefrigeratorDatabaseHelper._createInstance();

  factory RefrigeratorDatabaseHelper() {
    _refrigeratorDatabaseHelper ??= RefrigeratorDatabaseHelper._createInstance();
    return _refrigeratorDatabaseHelper!;
  }

  static Database? _database; // singleton database
  Future<Database> get database async =>
    _database ??= await initializeDatabase();


  Future<Database> initializeDatabase() async {
    try {
      String path = join(await getDatabasesPath(), 'refrigerators.db');
      var refrigeratorDatabase =
          await openDatabase(path, version: 1,
            onCreate: (db, version) async =>
            await db.execute("CREATE TABLE refrigerators($colId INTEGER PRIMARY KEY, $colHospitalId INTEGER, $colUserId INTEGER, $colName TEXT, $colManufacturer TEXT, $colTempMonitorInstalled INTEGER, $colMonitorType TEXT, $colMonitorWorking INTEGER, $colVoltageRegularInstalled INTEGER, $colRegularType TEXT, $colVaccineCount INTEGER);"),
          );
      return refrigeratorDatabase;
    } catch(e) {
      throw Exception('Error initializing database: $e');
    } 
  }

  Future<int> insertRefrigerator(Refrigerator refrigerator) async {
    Database db = await database;
    return await db.insert("refrigerators", refrigerator.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateRefrigerator(Refrigerator refrigerator) async {
    Database db = await database;
    return await db.update("refrigerators", refrigerator.toJson(),
      where: '$colId = ?',
      whereArgs: [refrigerator.id],
      conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deleteRefrigerator(Refrigerator refrigerator) async {
    Database db = await database;
    return await db.delete("refrigerators",
      where: '$colId = ?',
      whereArgs: [refrigerator.id],);
  }

  Future<List<Refrigerator>?> queryRefrigeratorsByColumnValue(String columnName, dynamic columnValue) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('refrigerators',
      where: '$columnName = ?',
      whereArgs: [columnValue],);
    return List.generate(maps.length, (index) => Refrigerator.fromJson(maps[index]));
  }

  Future<List<Refrigerator>?> getAllRefrigerators() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('refrigerators');

    if (maps.isEmpty) return null;
    return List.generate(maps.length, (index) => Refrigerator.fromJson(maps[index]));
  }

}
