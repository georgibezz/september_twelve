import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:user/components/bottom.nav.bar.dart';
import 'package:user/constants/enums.dart';
import 'package:user/model/condition.entity.dart';
import 'package:user/objectbox.g.dart';
import 'package:user/components/home.screen.header.dart';
import 'package:user/screens/plan/condition.herbal.listing.dart'; // Import your custom header

class ConditionsScreen extends StatefulWidget {
  const ConditionsScreen({Key? key}) : super(key: key);

  @override
  _ConditionsScreenState createState() => _ConditionsScreenState();
}

class _ConditionsScreenState extends State<ConditionsScreen> {
  Store? _store;
  Box<Conditions>? conditionsBox;
  late Stream<List<Conditions>> stream;
  final searchController = TextEditingController();

  final adminAppServerIp = '137.158.109.230';
  final adminAppServerPort = '9999';

  @override
  void initState() {
    super.initState();
    openStore().then((Store store) {
      _store = store;
      Sync.client(
        store,
        'ws://$adminAppServerIp:$adminAppServerPort',
        SyncCredentials.none(),
      ).start();

      conditionsBox = store.box<Conditions>();
      stream = conditionsBox!.query().watch(triggerImmediately: true).map((query) => query.find().toList());

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: HomeHeader(), // Use HomeHeader as the app bar
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search Conditions',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    // Filter the conditions based on user input
                    final filteredConditions = stream.map((list) => list.where((condition) =>
                        condition.name.toLowerCase().contains(value.toLowerCase()))).toList();
                    // Update the UI with filtered conditions
                    setState(() {});
                  },
                ),
              ),
              StreamBuilder<List<Conditions>>(
                stream: stream,
                initialData: const <Conditions>[],
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }

                  final items = snapshot.data ?? [];

                  if (items.isEmpty) {
                    return Text("No conditions available.");
                  }

                  final filteredItems = items;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final condition = filteredItems[index];
                      return Card(
                        child: ListTile(
                          title: Text(condition.name),
                          onTap: () {
                            Navigator.of(context).push(
                            MaterialPageRoute(
                            builder: (context) => ConditionHerbalListing(condition: condition),
                            ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.remedy),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _store?.close();
  }
}
