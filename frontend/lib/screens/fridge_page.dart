import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/hospital.dart';
import '../models/refrigerator.dart';
import 'editRefrigerator_page.dart';
import 'profile_page.dart';
import 'refrigerator_page.dart';

Future<List<Refrigerator>> getRefrigeratorsByHospitalID(int hospitalId) async {
  String hospital = hospitalId.toString();
  final response = await http.get(Uri.parse(
      "http://127.0.0.1:8000/logistics/getRefrigerators/$hospital"));

  if (response.statusCode == 200) {
    List<dynamic> refrigeratorsJson = json.decode(response.body);
    return refrigeratorsJson.map((json) {
      return Refrigerator.fromJson(json);
    }).toList();
  } else {
    throw Exception('Failed to load refrigerators');
  }
}

class RefrigeratorPage extends StatefulWidget {
  final Hospital hospital;

  const RefrigeratorPage({super.key, required this.hospital});

  @override
  State<RefrigeratorPage> createState() => _RefrigeratorPageState();
}

class _RefrigeratorPageState extends State<RefrigeratorPage> {
  late Future<List<Refrigerator>?> _refrigeratorsFuture;

  @override
  void initState() {
    super.initState();
    _refrigeratorsFuture = _loadRefrigerators();
  }

  Future<List<Refrigerator>?> _loadRefrigerators() async {
    try {
      List<Refrigerator> refrigerators = await getRefrigeratorsByHospitalID(widget.hospital.id!);
      return refrigerators;
    } catch (e) {
      print('Failed to fetch or save refrigerators: $e');
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
              widget.hospital.name,
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
      body: FutureBuilder<List<Refrigerator>?>(
        future: _refrigeratorsFuture,
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
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditRefrigeratorPage(refrigerator: snapshot.data![idx]),
                      ),
                    );
                    setState(() {
                      _refrigeratorsFuture = _loadRefrigerators();
                    });
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
          setState(() {
            _refrigeratorsFuture = _loadRefrigerators();
          });
        },
        tooltip: 'Synchronization',
        child: const Icon(Icons.sync),
      ),
    );
  }
}
