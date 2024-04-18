import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Cold Chain App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 10, 156, 234)),
        ),
        home: const HomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  int selectedPage = 1;

  void goToLoginPage() {selectedPage = 0; notifyListeners();}
  void goToDistrictManagerPage() {selectedPage = 1; notifyListeners();}
  void goToHospitalPage() {selectedPage = 2; notifyListeners();}
  void goToProfilePage() {selectedPage = 3; notifyListeners();}
  void goToMenuPage() {selectedPage = 4; notifyListeners();}
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String districtName = "DistrictName2";

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    int selectedPage = appState.selectedPage;
    Widget page;
    switch (selectedPage) {
      case 0: page = const LoginPage();
      case 1: page = DistrictManagerPage(hospitals: List<String>.generate(100, (i) => 'Hospital $i'), districtName: districtName,);
      case 2: page = HospitalPage(districtName: districtName);
      default: throw UnimplementedError('No Widget for $selectedPage');
    }

    return SafeArea(child: page);
  }
}

// bug
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('This is the title.', textDirection: TextDirection.ltr,),
        Expanded(child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [ElevatedButton(onPressed: null, child: Text('Sign up'),),
                     SizedBox(width: 10,),
                     ElevatedButton(onPressed: null, child: Text('Sign in'),),],),
          ),],
    );
  }
}

class DistrictManagerPage extends StatelessWidget {
  final List<String> hospitals;
  final String districtName;

  const DistrictManagerPage({super.key, required this.hospitals, required this.districtName});

  @override
  Widget build(BuildContext context) {
    var title = Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [Text(districtName), const Icon(Icons.person)],);
    var appState = context.watch<MyAppState>();
    
    return Scaffold(
      appBar: AppBar(title: title),
      body: ListView.builder(
        itemCount: hospitals.length,
        prototypeItem: ListTile(leading: ElevatedButton.icon(onPressed: () {appState.goToHospitalPage();}, icon: const Icon(Icons.local_hospital), label: Text(hospitals.first)),
                                ),
        itemBuilder: (context, idx) {
          return ListTile(leading: ElevatedButton.icon(onPressed: () {appState.goToHospitalPage();}, icon: const Icon(Icons.local_hospital), label: Text(hospitals[idx])),
                          );
        }),
    );
  }
}

class HospitalPage extends StatefulWidget {
  final String districtName;
  const HospitalPage({super.key, required this.districtName});
  

  @override
  State<HospitalPage> createState() => _HospitalPageState();
}

class _HospitalPageState extends State<HospitalPage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      appBar: AppBar(leading: IconButton(onPressed: () {appState.goToDistrictManagerPage();}, icon: const Icon(Icons.chevron_left_sharp),),
                     title: Text(widget.districtName,)),
      body: Container(child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InfoView(feature: 'id',),
          InfoView(feature: 'location',),
          InfoView(feature: 'other info',),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(onPressed: null, child: Text('Edit'),),
              SizedBox(width: 10,),
              ElevatedButton(onPressed: null, child: Text('Save'),),
            ],
          ),
        ],),
      ),
    );
  }
}

class InfoView extends StatelessWidget {
  final String feature;
  const InfoView({
    super.key,
    required this.feature,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Text('$feature: '));
  }
}