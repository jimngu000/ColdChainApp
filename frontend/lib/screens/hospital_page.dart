// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import '../models/district.dart';
import '../models/hospital.dart';
import 'profile_page.dart';
import 'refrigerator_page.dart';

Future<List<Hospital>> getHospitalsByDistrictID(int districtID) async {
  final response = await http.get(Uri.parse(
      "http://127.0.0.1:8000/logistics/getHospitalsByDistrictID?district_id=$districtID"));

  if (response.statusCode == 200) {
    List<dynamic> hospitalsJson = json.decode(response.body);
    return hospitalsJson.map((json) {
      return Hospital.fromJson(json);
    }).toList();
  } else {
    throw Exception('Failed to load hospitals');
  }
}

class HospitalPage extends StatefulWidget {
  final District district;

  const HospitalPage({super.key, required this.district});

  @override
  State<HospitalPage> createState() => _HospitalPageState();
}

class _HospitalPageState extends State<HospitalPage> {

  late Future<List<Hospital>?> _hospitalsFuture;

  @override
  void initState() {
    super.initState();
    _hospitalsFuture = _loadHospitals();
  }

  Future<List<Hospital>?> _loadHospitals() async {
    try {
      List<Hospital> hospitals = await getHospitalsByDistrictID(widget.district.id!);
      return hospitals;
    } catch (e) {
      print('Failed to fetch or save districts: $e');
      return Future.error('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.district.name,
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
      body: FutureBuilder<List<Hospital>?>(
        future: _hospitalsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (snapshot.hasData && snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, idx) => Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                elevation: 2.0,
                child: ListTile(
                  title: Text(
                    snapshot.data![idx].name,
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                  onTap: () async {
                    debugPrint('Hospital ListTile is tapped');
                    // navigate
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RefrigeratorPage(hospital: snapshot.data![idx])),
                    );
                  },
                ),
              ),
            );
          }
          return const Center(
            child: Text('No Data'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          debugPrint('Synchronization button pressed');
          // do some syn
        },
        tooltip: 'Synchronization',
        child: const Icon(Icons.sync),
      ),
    );
  }
}
