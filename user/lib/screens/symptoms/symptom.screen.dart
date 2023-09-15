import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:user/model/symptom.entity.dart';
import 'package:user/objectbox.g.dart';

class SymptomScreen extends StatefulWidget {
  const SymptomScreen({Key? key}) : super(key: key);

  @override
  State<SymptomScreen> createState() => _SymptomScreenState();
}

class _SymptomScreenState extends State<SymptomScreen> {
  Store? _store;
  Box<Symptoms>? symptomBox;
  late Stream<List<Symptoms>> stream;

  final adminAppServerIp = '137.158.109.230'; // Replace with the admin app's server IP
  final adminAppServerPort = '9999'; // Replace with the admin app's server port

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

      symptomBox = store.box<Symptoms>();
      stream = symptomBox!.query().watch(triggerImmediately: true).map((query) => query.find().toList());

      setState(() {}); // Add this line to trigger a rebuild with the initialized stream
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Symptoms'),
      ),
      body: Center(
        child: StreamBuilder<List<Symptoms>>(
          stream: stream,
          initialData: const <Symptoms>[],
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }

            final item = snapshot.data ?? [];

            if (item.isEmpty) {
              return Text("No symptoms available.");
            }

            return ListView.builder(
              itemCount: item.length,
              itemBuilder: (context, index) {
                final symptoms = item[index];
                return Card(
                  child: ListTile(
                    title: Text(symptoms.name),
                    subtitle: Text('Description: ${symptoms.description}'),
                    onTap: () {
                      // Navigate to the item detail page when tapped
                    Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SymptomDetailPage(symptom: symptoms,),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _store?.close();
  }
}

class SymptomDetailPage extends StatefulWidget {
  final Symptoms symptom;

  const SymptomDetailPage({Key? key, required this.symptom}) : super(key: key);

  @override
  _SymptomDetailPageState createState() => _SymptomDetailPageState();
}

class _SymptomDetailPageState extends State<SymptomDetailPage> {
  String selectedTab = 'Information';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.symptom.name),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 32),
                const SizedBox(width: 8),
                Text(
                  widget.symptom.name,
                  style: const TextStyle(fontSize: 24),
                ),
              ],
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildTabButton('Description', Icons.medical_information_outlined),
              buildTabButton('Causes', Icons.warning_amber),
              buildTabButton('Complications', Icons.comment),

            ],
          ),
          const Divider(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: buildSelectedTabContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTabButton(String tabName, IconData iconData) {
    bool isSelected = selectedTab == tabName;
    Color? iconColor = Colors.white;

    if (isSelected) {
      switch (tabName) {
        case 'Description':
          iconColor = Colors.green[300];
          break;
        case 'Causes':
          iconColor = Colors.blue[300];
          break;
        case 'Complications':
          iconColor = Colors.yellow[300];
          break;
        default:
          break;
      }
    }

    return InkWell(
      onTap: () {
        setState(() {
          selectedTab = isSelected ? '' : tabName;
        });
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: isSelected ? iconColor : Colors.grey,
            child: Icon(
              iconData,
              color: isSelected ? Colors.white : iconColor,
            ),
          ),
          Visibility(
            visible: isSelected,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(tabName),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSelectedTabContent() {
    switch (selectedTab) {
      case 'Information':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${widget.symptom.name}'),
            Text('Description: ${widget.symptom.description}'),

          ],
        );
      case 'Causes':
        return Text('Causes:\n${widget.symptom.causes}');
      case 'Complications':
        return Text('Complications:\n${widget.symptom.complications}');
      default:
        return const SizedBox.shrink();
    }
  }
}
