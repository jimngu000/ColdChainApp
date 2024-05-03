import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left),
          onPressed: () async {
            debugPrint('Pop back');
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(child: Placeholder(),),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              child: Text('Some personal info'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              child: ElevatedButton(
                child: const Text('Sign out'),
                onPressed: () {
                  debugPrint('Sign out button pressed');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}