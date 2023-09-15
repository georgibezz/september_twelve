import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:user/model/condition.entity.dart';
import 'package:user/objectbox.g.dart';

class ConditionScreen extends StatefulWidget {
  const ConditionScreen({Key? key}) : super(key: key);

  @override
  State<ConditionScreen> createState() => _ConditionScreenState();
}

class _ConditionScreenState extends State<ConditionScreen> {
  Store? _store;
  Box<Conditions>? conditionBox;
  late Stream<List<Conditions>> stream;

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

      conditionBox = store.box<Conditions>();
      stream = conditionBox!.query().watch(triggerImmediately: true).map((query) => query.find().toList());

      setState(() {}); // Add this line to trigger a rebuild with the initialized stream
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conditions'),
      ),
      body: Center(
        child: StreamBuilder<List<Conditions>>(
          stream: stream,
          initialData: const <Conditions>[],
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }

            final item = snapshot.data ?? [];

            if (item.isEmpty) {
              return Text("No conditions available.");
            }

            return ListView.builder(
              itemCount: item.length,
              itemBuilder: (context, index) {
                final conditions = item[index];
                return Card(
                  child: ListTile(
                    title: Text(conditions.name),
                    subtitle: Text('Description: ${conditions.description}'),
                    onTap: () {
                      // Navigate to the item detail page when tapped
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ConditionDetailPage(condition: conditions,),
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

class ConditionDetailPage extends StatefulWidget {
  final Conditions condition;

  const ConditionDetailPage({Key? key, required this.condition}) : super(key: key);

  @override
  _ConditionDetailPageState createState() => _ConditionDetailPageState();
}

class _ConditionDetailPageState extends State<ConditionDetailPage> {
  String selectedTab = 'Information';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.condition.name),
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
                  widget.condition.name,
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
            Text('Name: ${widget.condition.name}'),
            Text('Description: ${widget.condition.description}'),

          ],
        );
      case 'Causes':
        return Text('Causes:\n${widget.condition.causes}');
      case 'Complications':
        return Text('Complications:\n${widget.condition.complications}');
      default:
        return const SizedBox.shrink();
    }
  }
}
