import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

import 'launch_cell.dart';
import '../classes/launch.dart';

class LaunchList extends StatelessWidget {
  final String url;

  LaunchList(this.url);

  Future<List<Launch>> fetchPost() async {
    final response = await http.get(url);

    List jsonDecoded = json.decode(response.body);
    return jsonDecoded.map((m) => Launch.fromJson(m)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<Launch>>(
        future: fetchPost(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              if (!snapshot.hasError) {
                final List<Launch> launches = snapshot.data;
                return ListView.builder(
                  key: PageStorageKey(url),
                  padding:
                      const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                  itemCount: launches.length,
                  itemBuilder: (context, index) {
                    return LaunchCell(launches[index]);
                  },
                );
              } else
                return const Text("Couldn't connect to server...");
          }
        },
      ),
    );
  }
}
