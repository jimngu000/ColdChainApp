import 'package:flutter/material.dart';

import '../models/hospital.dart';
import '../models/refrigerator.dart';
import '../utils/refrigerator_db_helper.dart';
import 'profile_page.dart';
import 'refrigerator_page.dart';

class HospitalPage extends StatefulWidget {
  final Hospital hospital;
  const HospitalPage({super.key, required this.hospital});
  @override
  State<HospitalPage> createState() => _HospitalPageState();
}

class _HospitalPageState extends State<HospitalPage> {
  final RefrigeratorDatabaseHelper _refrigeratorDatabaseHelper = RefrigeratorDatabaseHelper();
  int count = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            debugPrint('Pop back');
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.hospital.name, textAlign: TextAlign.center,),
            const Spacer(),
            IconButton(
              onPressed: () {
                debugPrint('hospital page to profile');
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
              icon: const Icon(Icons.person),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Refrigerator>?>(
        future: _refrigeratorDatabaseHelper.queryRefrigeratorsByColumnValue('hospital_id', widget.hospital.id),
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
                    debugPrint('Hospital to Refrigerator');
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RefrigeratorPage(refrigerator: snapshot.data![idx])),
                    );
                  },
                ),
              ),
            );
          }
          return const Center(child: Text('No Data'),);
        },
      ),
    );
  }

}