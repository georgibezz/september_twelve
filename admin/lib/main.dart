import 'dart:io';
import 'package:flutter/material.dart';
import 'home.screen.dart';
import 'package:admin/objectbox.g.dart';

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