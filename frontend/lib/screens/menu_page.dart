import 'package:flutter/material.dart';

import '../models/district.dart';
import '../utils/district_db_helper.dart';
import 'district_page.dart';
import 'profile_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final DistrictDatabaseHelper _districtDatabaseHelper = DistrictDatabaseHelper();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('CountryName', textAlign: TextAlign.center,),
            const Spacer(),
            IconButton(
              onPressed: () {
                debugPrint('Move to profile');
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
              icon: const Icon(Icons.person),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<District>?>(
        future: _districtDatabaseHelper.getAllDistricts(),
        builder:(context, snapshot) {
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
                  title: Text(snapshot.data![idx].name),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                  onTap: () async {
                    debugPrint('menu page to district page');
                    await Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DistrictPage(district: snapshot.data![idx])),
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