import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';

import 'package:cat_feed/feed.dart';
import 'package:cat_feed/toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Future<Feed> fetchFeeds() async {
  final response = await http.get(Uri.parse("http://127.0.0.1:8000/api/Feed/"));
  // final response = await http.get(Uri.parse("http://10.0.2.2:8000/api/Feed/"));

  if (response.statusCode == 200) {
    return Feed.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load feeds');
  }
}

void feedCat(feedType) async {
  final response = await http.post(Uri.parse("http://127.0.0.1:8000/api/Feed/"), body: {'feedType': feedType});
  // final response = await http.post(Uri.parse("http://10.0.2.2:8000/api/Feed/"), body: {'feedType': feedType});
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Feed> futureFeed;
  final DateTime now = DateTime.now().add(Duration(hours: 2));
  Color bg_color = const Color.fromARGB(255, 95, 204, 255);
  Color text_color = Colors.black;

  @override
  void initState() {
    super.initState();
    if(now.hour - 12 > 0) {
      bg_color = const Color.fromARGB(255, 0, 42, 114);
      text_color = Colors.white;
    }
    futureFeed = fetchFeeds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bg_color,
        title: Text(
          style: TextStyle(color: text_color),
          widget.title
        ),
      ),
      backgroundColor: bg_color,
      body: FutureBuilder<Feed>(
        future: futureFeed,
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            final feed = snapshot.data!;
            return ListView(
              children: feed.feeds.entries.map((entry) {
                final feedItem = entry.value;
                return ListTile(
                  title: Text(
                    style: TextStyle(color: text_color),
                    feedItem.type
                    ),
                  trailing: ToggleSwitch(
                    feedItem: feedItem, 
                    onToggle: (bool value) {
                      if(value) {
                        feedCat(feedItem.type);
                      };
                    },
                  ),
                );
              }).toList(),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
