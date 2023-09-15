import 'package:flutter/material.dart';
import 'package:user/home.page.dart';
import 'package:user/screens/library/library.screen.dart';
import 'package:user/screens/plan/plan.user.screen.dart';
import 'package:user/screens/symptoms/symptom.screen.dart';

import 'screens/condition/condition.user.screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(), // Navigate to ItemsPage
                  ),
                );
              },
              child: const Text('Items'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        ConditionScreen(), // Navigate to SymptomsPage
                  ),
                );
              },
              child: const Text('Condition'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        SymptomScreen(), // Navigate to SymptomsPage
                  ),
                );
              },
              child: const Text('Symptoms'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        PlanScreen(), // Navigate to SymptomsPage
                  ),
                );
              },
              child: const Text('Plans'),
            ),
          ],
        ),
      ),
    );
  }
}