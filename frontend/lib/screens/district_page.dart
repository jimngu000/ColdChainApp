import 'package:flutter/material.dart';

import '../models/district.dart';
import '../models/hospital.dart';
import '../utils/hospital_db_helper.dart';
import 'hospital_page.dart';
import 'profile_page.dart';

class DistrictPage extends StatefulWidget {
  final District district;
  const DistrictPage({super.key, required this.district});

  @override
  State<DistrictPage> createState() => _DistrictPageState();
}

class _DistrictPageState extends State<DistrictPage> {
  final HospitalDatabaseHelper _hospitalDatabaseHelper = HospitalDatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            debugPrint('district page to menu page');
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.district.name, textAlign: TextAlign.center,),
            const Spacer(),
            IconButton(
              onPressed: () {
                debugPrint('district page to profile');
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
              icon: const Icon(Icons.person),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Hospital>?>(
        future: _hospitalDatabaseHelper.queryHospitalsByColumnValue('hospital_id', widget.district.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()),);
          }
          if (snapshot.hasData && snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, idx) => Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  elevation: 2.0,
                  child: ListTile(
                    title: Text(snapshot.data![idx].name,),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () async {
                      debugPrint('Hospital ListTile is tapped');
                      // navigate
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HospitalPage(hospital: snapshot.data![idx])),
                      );
                    },
                  ),
                ),
            );
          }
          return const Center(child: Text('No Data'),);
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