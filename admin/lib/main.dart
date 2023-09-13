import 'dart:io';
import 'package:admin/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'screen/library/item.screen.dart';
import 'package:objectbox/objectbox.dart';

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
      home: HomePage(), //navigate to first page
    );
  }
}