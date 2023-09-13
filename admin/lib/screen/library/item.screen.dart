import 'package:flutter/material.dart';
import '../../main.dart';
import '../../model/item.entity.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController namecontroller;
  late final TextEditingController alsoCalledcontroller;
  late final TextEditingController partUsedController;

  @override
  void initState() {
    namecontroller = TextEditingController();
    alsoCalledcontroller = TextEditingController();
    partUsedController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    namecontroller.dispose();
    alsoCalledcontroller.dispose();
    partUsedController.dispose();
    super.dispose();
  }

  void addToList() {
    store.box<Item>().put(Item(namecontroller.text,alsoCalledcontroller.text,partUsedController.text));
    namecontroller.text = '';
    alsoCalledcontroller.text = '';
    partUsedController.text = '';
    Navigator.pop(context);
  }

  void removeSelectedItem(Item item) {
    store.box<Item>().remove(item.id);
  }

  void addToListDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return Center(
          child: Material(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 60,
                  width: 300,
                  child: TextField(
                      controller: namecontroller,
                      decoration: InputDecoration(
                      hintText: 'Name of item'),
                  ),
                ),
                SizedBox(
                  height: 60,
                  width: 300,
                  child: TextField(controller: alsoCalledcontroller,
                    decoration: InputDecoration(
                        hintText: 'Alternative Name'),
                  ),
                ),
            SizedBox(
              height: 60,
              width: 300,
              child: TextField(controller: partUsedController,
                decoration: InputDecoration(
                    hintText: 'Part Used'),
              ),
            ),
                ElevatedButton(
                  onPressed: addToList,
                  child: const Text('add'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  void showItemDetailsDialog(BuildContext context, Item item) {
    final TextEditingController nameController = TextEditingController(text: item.name);
    final TextEditingController alsoCalledController = TextEditingController(text: item.alsoCalled);
    final TextEditingController partUsedController = TextEditingController(text: item.partUsed);

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit Item Details'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: alsoCalledController,
                    decoration: InputDecoration(labelText: 'Also Called'),
                  ),
                  TextField(
                    controller: partUsedController,
                    decoration: InputDecoration(labelText: 'Part Used'),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    // Update item values
                    item.name = nameController.text;
                    item.alsoCalled = alsoCalledController.text;
                    item.partUsed = partUsedController.text;

                    // Update item in the database
                    store.box<Item>().put(item);

                    // Close the dialog
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  final stream = store
      .box<Item>()
      .query()
      .watch(triggerImmediately: true)
      .map((e) => e.find());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Item>>(
        stream: stream,
        initialData: const <Item>[],
        builder: (_, snapshot) {
          final items = snapshot.data ?? [];
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return GestureDetector(
                onTap: () => showItemDetailsDialog(context,item), // Show details dialog when tapped
                child: Card(
                  child: ListTile(
                    title: Text(item.name),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => removeSelectedItem(item),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: addToListDialog,
      ),
    );
  }
}