import 'package:flutter/material.dart';
import 'package:pullup/pullup.dart';

void main() => runApp(const MyApp());

/// Example app demonstrating PullUpRefresh with pagination (30 items per load)
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final int totalItems = 100; // Total number of items
  final int pageSize = 30;    // Items per "page"
  List<int> items = [];       // Current loaded items

  @override
  void initState() {
    super.initState();
    _loadMoreItems(); // Load initial 30 items
  }

  /// Simulates fetching the next "page" of items
  Future<void> _loadMoreItems() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    setState(() {
      final nextItems = List.generate(
        pageSize,
            (index) => items.length + index,
      ).where((item) => item < totalItems).toList();

      items.addAll(nextItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Pull Up Refresh Demo')),
        body: PullUpRefresh(
          autoPull: false, // optional: set true if you want auto-refresh
          triggerDistance: 60,
          indicatorColor: Colors.purple,
          indicatorSize: 40,
          slideDistance: 24.0,
          onRefresh: _loadMoreItems, // Trigger load next page on pull-up
          child: Column(
            children: [
              ...items.map(
                    (index) => ListTile(title: Text('Message $index')),
              ),
              // Show "End of list" message if all items are loaded
              if (items.length >= totalItems)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: Text('All items loaded')),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
