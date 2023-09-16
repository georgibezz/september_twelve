import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:user/components/bottom.nav.bar.dart';
import 'package:user/constants/enums.dart';
import 'package:user/model/symptom.entity.dart';
import 'package:user/objectbox.g.dart';
import 'package:user/components/home.screen.header.dart';
import 'package:user/screens/plan/symptom.herbal.listing.dart'; // Import your custom header

class SymptomsScreen extends StatefulWidget {
  const SymptomsScreen({Key? key}) : super(key: key);

  @override
  _SymptomsScreenState createState() => _SymptomsScreenState();
}

class _SymptomsScreenState extends State<SymptomsScreen> {
  Store? _store;
  Box<Symptoms>? symptomsBox;
  late Stream<List<Symptoms>> stream;
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

      symptomsBox = store.box<Symptoms>();
      stream = symptomsBox!.query().watch(triggerImmediately: true).map((query) => query.find().toList());

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
                    hintText: 'Search Symptoms',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    // Filter the symptoms based on user input
                    final filteredSymptoms = stream.map((list) => list.where((symptom) =>
                        symptom.name.toLowerCase().contains(value.toLowerCase()))).toList();
                    // Update the UI with filtered symptoms
                    setState(() {});
                  },
                ),
              ),
              StreamBuilder<List<Symptoms>>(
                stream: stream,
                initialData: const <Symptoms>[],
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }

                  final items = snapshot.data ?? [];

                  if (items.isEmpty) {
                    return Text("No symptoms available.");
                  }

                  final filteredItems = items;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final symptom = filteredItems[index];
                      return Card(
                        child: ListTile(
                          title: Text(symptom.name),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SymptomHerbalListing(symptom: symptom),
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
