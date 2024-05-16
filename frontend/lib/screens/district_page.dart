// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:http/http.dart' as http;
import 'package:logistics/models/refrigerator.dart';
import 'package:logistics/screens/hospital_page.dart';

// Project imports:
import '../models/access.dart';
import '../models/district.dart';
import '../models/hospital.dart';
import 'allDistrict_page.dart';
import 'profile_page.dart';
import 'globals.dart' as globals;
import 'refrigerator_page.dart';

Future<List<District>> getAllDistricts() async {
  String userId = globals.userId.toString();
  final response =
  await http.get(Uri.parse("http://10.0.2.2:8000/logistics/getDistrictAssignments/$userId"));
  if (response.statusCode == 200) {
    List<dynamic> districtsJson = json.decode(response.body);
    return districtsJson.map((json) {
      return District.fromJson(json);
    }).toList();
  } else {
    throw Exception('Failed to load districts');
  }
}

Future<Hospital?> getOneHospital(int id) async {
  if (id == -1) return null;
  String h_id = id.toString();
  final response =
  await http.get(Uri.parse("http://10.0.2.2:8000/logistics/getOneHospital/$h_id"));
  if (response.statusCode == 200) {
    List<dynamic> hJson = json.decode(response.body);
    List<Hospital> tmp = hJson.map((e) {
      return Hospital.fromJson(e);
    }).toList();
    return tmp.first;
  } else {
    throw Exception('Failed to load access');
  }
}

Future<List<Hospital>> getAccessHospitalAssignments() async {
  String userId = globals.userId.toString();
  List<Access> tmp;
  final response =
  await http.get(Uri.parse("http://10.0.2.2:8000/logistics/getAccessHospitalAssignments/$userId"));
  if (response.statusCode == 200) {
    List<dynamic> accessJson = json.decode(response.body);
    tmp = accessJson.map((json) {
      return Access.fromJson(json);
    }).toList();
  } else {
    throw Exception('Failed to load access');
  }

  List<Hospital> res = [];

  for (Access t in tmp) {
    late Future<Hospital?> h = getOneHospital(t.hospital ?? -1);
    if (h != null) res.add(h as Hospital);
  }
  return res;
}

class DistrictPage extends StatefulWidget {
  const DistrictPage({super.key});

  @override
  State<DistrictPage> createState() => _DistrictPageState();
}

class _DistrictPageState extends State<DistrictPage> {
  late Future<List<District>?> _districtsFuture;
  late Future<List<Hospital>?> _accessFuture;

  @override
  void initState() {
    super.initState();
    _districtsFuture = _loadDistricts();
    _accessFuture = _loadAccess();
  }

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

  Future<List<Hospital>?> _loadAccess() async {
    try {
      // Fetch districts from the API
      List<Hospital> districts = await getAccessHospitalAssignments();
      return districts;
    } catch (e) {
      print('Failed to fetch or save access: $e');
      return Future.error('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    String username = globals.username;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'District Assignments for $username',
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
              icon: const Icon(Icons.person),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<District>?>(
              future: _districtsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.hasData && snapshot.data != null) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, idx) => Card(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      elevation: 2.0,
                      child: ListTile(
                        title: Text(snapshot.data![idx].name),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                        onTap: () async {
                          debugPrint('menu page to district page');
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  HospitalPage(district: snapshot.data![idx]),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
                return const Center(child: Text('No Data'));
              },
            ),
          ),

          // from Access
          Expanded(
            child: FutureBuilder<List<Hospital>?>(
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
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, idx) => Card(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      elevation: 2.0,
                      child: ListTile(
                        title: Text(snapshot.data![idx].name),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                        onTap: () async {
                          debugPrint('menu page to district page');
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RefrigeratorPage(hospital: snapshot.data![idx])
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
                return const Center(child: Text('No Data'));
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => AllDistrictPage()),
              );
            },
            child: Text('See All Districts'),
          ),
        ],
      ),
    );
  }
}
