import 'package:flutter/material.dart';
import 'main.dart';
import 'item.entity.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  void showItemDetails(BuildContext context, Item item) {
    // Show a dialog or navigate to a new screen to display item details.
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(item.name),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Also Called: ${item.alsoCalled}'),
              // Add more details here if needed
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item List'),
      ),
      body: StreamBuilder<List<Item>>(
        stream: store.box<Item>().query().watch(triggerImmediately: true).map((e) => e.find()),
        initialData: const <Item>[],
        builder: (_, snapshot) {
          final items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, index) {
              final item = items[index];
              return Card(
                child: ListTile(
                  title: Text(item.name),
                  onTap: () => showItemDetails(context, item), // Show details on tap
                ),
              );
            },
          );
        },
      ),
    );
  }
}
