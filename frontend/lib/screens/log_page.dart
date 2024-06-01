import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/log.dart';

class LogPage extends StatefulWidget {
  final Log log;

  const LogPage({super.key, required this.log});

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {

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
        title: Text(
          '''${widget.log.id} user id: ${widget.log.user}
              district id: ${widget.log.district} hospital id: ${widget.log.hospital}
              refrigerator id: ${widget.log.refrigerator} timestamp: ${widget.log.timestamp}''',
          textAlign: TextAlign.center,
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Text("Before Change:"),
            SizedBox(height: 16,),
            ListView(
              children: widget.log.previousValue.entries
                .map((entry) => ListTile(
                  title: Text(entry.key),
                  subtitle: Text(entry.value.toString()),
                  ))
                .toList(),
            ),
            SizedBox(height: 16,),
            Text("After Change:"),
            SizedBox(height: 16,),
            ListView(
              children: widget.log.newValue.entries
                .map((entry) => ListTile(
                  title: Text(entry.key),
                  subtitle: Text(entry.value.toString()),
                  ))
                .toList(),
            ),
          ],
        ),
      ),
    );
  }
}