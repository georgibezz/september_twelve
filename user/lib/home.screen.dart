import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart'; // Import your 'Item' entity
import 'package:user/model/item.entity.dart';
import 'objectbox.g.dart'; // Import your generated objectbox file

class UserHomePage extends StatefulWidget {
  const UserHomePage({Key? key}) : super(key: key);

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  Store? _store;
  Box<Item>? itemBox;
  Stream? stream;

  final adminAppServerIp = '137.158.109.230'; // Replace with the admin app's server IP
  final adminAppServerPort = '9999'; // Replace with the admin app's server port

  @override
  void initState() {
    super.initState();
    openStore().then((Store store) {
      _store = store;
      Sync.client(
        store,
        'ws://$adminAppServerIp:$adminAppServerPort', // Use the admin app's server details
        SyncCredentials.none(),
      ).start();

      itemBox = store.box<Item>();
      stream = _store?.watch<Item>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Items'), // Change the title as needed
      ),
      body: Center(
        child: StreamBuilder<void>(
            stream: stream,
            builder: (context, AsyncSnapshot<void> snapshot) {
              List<Item>? items =
                  itemBox?.getAll().toList() ?? [];
              if (items.isNotEmpty) {
                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    final item = items[index];
                    return Card(
                      child: ListTile(
                        title: Text(item.name),
                        subtitle: Text('Also Called: ${item.alsoCalled}'),
                      ),
                    );
                  },
                  itemCount: items.length,
                );
              }

              if (snapshot.hasError) {
                return const Text("Error");
              }

              return const CircularProgressIndicator();
            }),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _store?.close();
  }
}
