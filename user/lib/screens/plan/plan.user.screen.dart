import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:user/model/plan.entity.model.dart';
import 'package:user/objectbox.g.dart';

class PlanScreen extends StatefulWidget {
  @override
  _PlanScreenState createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  late final Store _store;
  late final Box<Plan> _planBox;
  late Stream<List<Plan>> _stream;

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

      _planBox = store.box<Plan>();
      _stream = _planBox.query().watch(triggerImmediately: true).map((query) => query.find().toList());

      setState(() {}); // Add this line to trigger a rebuild with the initialized stream
    });
  }

  @override
  void dispose() {
    super.dispose();
    _store.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plans'),
      ),
      body: Center(
        child: StreamBuilder<List<Plan>>(
          stream: _stream,
          initialData: const <Plan>[],
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }

            final plans = snapshot.data ?? [];

            if (plans.isEmpty) {
              return Text("No plans available.");
            }

            return ListView.builder(
              itemCount: plans.length,
              itemBuilder: (context, index) {
                final plan = plans[index];
                return Card(
                  child: ListTile(
                    title: Text(plan.name),
                    subtitle: Text('Symptom or Condition: ${plan.symptomOrCondition}'),
                    onTap: () {
                      // Navigate to the plan detail page when tapped
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PlanDetailPage(plan: plan),
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
}

class PlanDetailPage extends StatefulWidget {
  final Plan plan;

  const PlanDetailPage({Key? key, required this.plan}) : super(key: key);

  @override
  _PlanDetailPageState createState() => _PlanDetailPageState();
}

class _PlanDetailPageState extends State<PlanDetailPage> {
  String selectedTab = 'Information';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.plan.name),
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
                  widget.plan.name,
                  style: const TextStyle(fontSize: 24),
                ),
              ],
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildTabButton('Information', Icons.info_outline),
              buildTabButton('Herbal Alternative', Icons.nature_people),
              buildTabButton('Instructions', Icons.how_to_vote),
              buildTabButton('Caution', Icons.warning_amber),
              buildTabButton('Reviews', Icons.comment), // Add this tab
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
        case 'Information':
          iconColor = Colors.green[300];
          break;
        case 'Herbal Alternative':
          iconColor = Colors.brown[300];
          break;
        case 'Instructions':
          iconColor = Colors.blue[300];
          break;
        case 'Caution':
          iconColor = Colors.yellow[300];
          break;
        case 'Reviews':
          iconColor = Colors.pink[300];
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
            Text('Name: ${widget.plan.name}'),
            Text('Description: ${widget.plan.description}'),
          ],
        );
      case 'Herbal Alternative':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the list of herbal alternatives here
            for (final herbalAlternative in widget.plan.herbalAlternativeNames)
              Text('Herbal Alternative: $herbalAlternative'),
          ],
        );
      case 'Instructions':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the list of instructions here
            for (final instruction in widget.plan.howToUseList)
              Text('How to Use: $instruction'),
          ],
        );
      case 'Caution':
        return Text('Caution:\n${widget.plan.cautionList}');
      case 'Reviews':
        return const Text('Functionality not yet implemented.');
      default:
        return const SizedBox.shrink();
    }
  }
}
