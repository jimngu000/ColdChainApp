import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
  String districtName = "DistrictName";

  void goToLoginPage() {selectedPage = 0; notifyListeners();}
  void goToDistrictManagerPage() {selectedPage = 1; notifyListeners();}
  void goToHospitalPage() {selectedPage = 2; notifyListeners();}
  void goToProfilePage() {selectedPage = 3; notifyListeners();}
  void goToMenuPage() {selectedPage = 4; notifyListeners();}

  void fetchData() async {
    var url = Uri.parse('http://127.0.0.1:8000/logistics/0/getHospitalCount/');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        print('Data fetched successfully:');
        print(response.body);
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Caught error: $e');
    }
  }
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
      case 3: page = ProfilePage();
      case 4: page = MenuPage();
      default: throw UnimplementedError('No Widget for $selectedPage');
    }

    return SafeArea(child: page);
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Name of the App')),
      body: Center(
        child: LoginForm(),
      ),
    );
  }
}

class DistrictManagerPage extends StatelessWidget {
  final List<String> hospitals;
  final String districtName;

  const DistrictManagerPage({super.key, required this.hospitals, required this.districtName});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var title = Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [IconButton(onPressed: () {appState.goToMenuPage();}, icon: Icon(Icons.menu)),
                                 Text(districtName),
                                 IconButton(onPressed: () {appState.goToProfilePage();}, icon: Icon(Icons.person)),
                                ],);
    
    return Scaffold(
      appBar: AppBar(title: title),
      body: Column(
        children: <Widget>[Expanded(
          child: ListView.builder(
            itemCount: hospitals.length,
            itemBuilder: (context, idx) {
              return ListTile(leading: ElevatedButton.icon(onPressed: () {appState.goToHospitalPage();}, icon: const Icon(Icons.local_hospital), label: Text(hospitals[idx])),
                              );
            }),
          ),
          ElevatedButton(onPressed: () {appState.fetchData();}, child: Text('Synchronization'),),
          const SizedBox(height: 10,),
        ],
      ),
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

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      appBar: AppBar(leading: IconButton(onPressed: () {appState.goToDistrictManagerPage();}, icon: Icon(Icons.arrow_back_ios_new),),),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(radius: 50,),
                SizedBox(height: 20,),
                Text('Name'),
                SizedBox(height: 10,),
                Text("id:"),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: null, child: Text('Sign out'),),),),
        ],
      ),
    );
  }
}

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    int numOfDistrict = 10;
    String districtName = 'DistrctName';
    return Scaffold(
      appBar: AppBar(title: const Text('CountryName')),
      body: ListView.builder(
        itemCount: numOfDistrict,
        itemBuilder: (context, index) {
          return ListTile(leading: ElevatedButton(onPressed: () {appState.goToDistrictManagerPage();}, child: Text('$districtName $index')),);
        },),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final userController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    userController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              controller: userController,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter user.';
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              controller: passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter password.';
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [ElevatedButton(
                onPressed: null,
                child: const Text('Sign up')),
              const SizedBox(width: 10,),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // call a server or save the info in a database
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('call a server or save the info in a database')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Wrong user or password.')),
                    );
                  }
                }, child: const Text('Sign in')),],
            ),
          )],
        ),
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
