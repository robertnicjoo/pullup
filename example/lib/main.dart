import 'package:flutter/material.dart';
import 'package:pullup/pullup.dart';

void main() => runApp(const MyApp());

/// Example application demonstrating the PullUpRefresh widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Pull Up Refresh Demo')),
        body: PullUpRefresh(
          // Enable automatic pull-up refresh every [pullDuration] milliseconds
          autoPull: true,
          pullDuration: 5000,

          // Customize indicator appearance
          indicatorColor: Colors.purple,
          indicatorSize: 40,
          slideDistance: 24.0,

          // Callback executed when pull-up refresh is triggered
          onRefresh: () async {
            debugPrint("Fetching new messages...");
            // Simulate network or data fetch delay
            await Future.delayed(const Duration(seconds: 2));
          },

          // Scrollable content inside PullUpRefresh
          child: Column(
            children: List.generate(
              30,
                  (index) => ListTile(title: Text('Message $index')),
            ),
          ),
        ),
      ),
    );
  }
}
