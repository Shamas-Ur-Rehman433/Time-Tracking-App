import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetrackingapp/Screen/HomeScreen.dart'; // Ensure correct path
import 'package:timetrackingapp/TimeEntryProvider.dart'; // Ensure correct path

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimeEntryProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Time Tracking App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}
