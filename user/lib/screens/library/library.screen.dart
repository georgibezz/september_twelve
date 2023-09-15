import 'package:flutter/material.dart';
import 'package:user/model/item.entity.dart';
import 'package:user/objectbox.g.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  Store? _store;
  Box<Item>? itemBox;
  late Stream<List<Item>> stream;

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

      itemBox = store.box<Item>();
      stream = itemBox!.query().watch(triggerImmediately: true).map((query) => query.find().toList());

      setState(() {}); // Add this line to trigger a rebuild with the initialized stream
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Items'),
      ),
      body: Center(
        child: StreamBuilder<List<Item>>(
          stream: stream,
          initialData: const <Item>[],
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }

            final items = snapshot.data ?? [];

            if (items.isEmpty) {
              return Text("No items available.");
            }

            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  child: ListTile(
                    title: Text(item.name),
                    subtitle: Text('Also Called: ${item.alsoCalled}'),
                    onTap: () {
                      // Navigate to the item detail page when tapped
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ItemDetailPage(item: item),
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

class ItemDetailPage extends StatefulWidget {
  final Item item;

  const ItemDetailPage({Key? key, required this.item}) : super(key: key);

  @override
  _ItemDetailPageState createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  String selectedTab = 'Information';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.name),
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
                  widget.item.name,
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
              buildTabButton('Usages', Icons.medical_information_outlined),
              buildTabButton('Precautions', Icons.warning_amber),
              buildTabButton('Reviews', Icons.comment),
              buildTabButton('Additional Information', Icons.add_box), // Add this tab
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
        case 'Usages':
          iconColor = Colors.blue[300];
          break;
        case 'Precautions':
          iconColor = Colors.yellow[300];
          break;
        case 'Reviews':
          iconColor = Colors.pink[300];
          break;
        case 'Additional Information':
          iconColor = Colors.orange[300];
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
            Text('Name: ${widget.item.name}'),
            Text('Also Called: ${widget.item.alsoCalled}'),
            Text('Part Used: ${widget.item.partUsed}'),
            Text('Source: ${widget.item.source}'),
          ],
        );
      case 'Usages':
        return Text('Usages:\n${widget.item.uses}');
      case 'Precautions':
        return Text('Precautions:\n${widget.item.caution}');
      case 'Reviews':
        return const Text('Functionality not yet implemented.');
      case 'Additional Information':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Forms Available: ${widget.item.formsAvailable}'),
            Text('Consumer Information: ${widget.item.consumerInfo}'),
            Text('References: ${widget.item.references}'),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

