import 'dart:io';
import 'package:admin/objectbox.g.dart';
import 'package:admin/screen/condition/condition.screen.dart';
import 'package:admin/screen/plan/plan.screen.dart';
import 'package:admin/screen/symptom/symptom.screen.dart';
import 'package:flutter/material.dart';
import 'screen/library/item.screen.dart';

late final Store store;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  store = await openStore();
  if (Sync.isAvailable()) {
    Sync.client(
      store,
      Platform.isAndroid ? 'ws://137.158.109.230:9999' : 'ws://137.158.109.230:9999',
      SyncCredentials.none(),
    ).start();
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    store.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
                    builder: (context) => ItemPage(), // Navigate to ItemsPage
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