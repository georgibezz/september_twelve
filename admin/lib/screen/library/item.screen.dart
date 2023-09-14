import 'package:flutter/material.dart';
import '../../main.dart';
import '../../model/item.entity.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({Key? key}) : super(key: key);

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  late final TextEditingController nameController;
  late final TextEditingController alsoCalledController;
  late final TextEditingController partUsedController;
  late final TextEditingController sourceController;
  late final TextEditingController formsAvailableController;
  late final TextEditingController usesController;
  late final TextEditingController cautionController;
  late final TextEditingController consumerInfoController;
  late final TextEditingController referencesController;

  @override
  void initState() {
    nameController = TextEditingController();
    alsoCalledController = TextEditingController();
    partUsedController = TextEditingController();
    sourceController = TextEditingController();
    formsAvailableController = TextEditingController();
    usesController = TextEditingController();
    cautionController = TextEditingController();
    consumerInfoController = TextEditingController();
    referencesController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    alsoCalledController.dispose();
    partUsedController.dispose();
    sourceController.dispose();
    formsAvailableController.dispose();
    usesController.dispose();
    cautionController.dispose();
    consumerInfoController.dispose();
    referencesController.dispose();
    super.dispose();
  }

  void addToList() {
    store.box<Item>().put(Item(nameController.text,alsoCalledController.text,partUsedController.text, sourceController.text, formsAvailableController.text, usesController.text, cautionController.text, consumerInfoController.text, referencesController.text));
    nameController.text = '';
    alsoCalledController.text = '';
    partUsedController.text = '';
    sourceController.text = '';
    formsAvailableController.text = '';
    usesController.text = '';
    cautionController.text = '';
    consumerInfoController.text ='';
    referencesController.text = '';
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
                      controller: nameController,
                      decoration: InputDecoration(
                      hintText: 'Name of item'),
                  ),
                ),
                SizedBox(
                  height: 60,
                  width: 300,
                  child: TextField(controller: alsoCalledController,
                    decoration: InputDecoration(
                        hintText: 'Alternative Name'),
                  ),
                ),
                SizedBox(
                  height: 60,
                  width: 300,
                  child: TextField(
                    controller: partUsedController,
                    decoration: InputDecoration(
                    hintText: 'Part Used'),
                 ),
                ),
                SizedBox(
                  height: 60,
                  width: 300,
                  child: TextField(controller: sourceController,
                    decoration: InputDecoration(
                        hintText: 'Where was it sourced'),
                  ),
                ),
                SizedBox(
                  height: 60,
                  width: 300,
                  child: TextField(controller: formsAvailableController,
                    decoration: InputDecoration(
                        hintText: 'Different forms available'),
                  ),
                ),
                SizedBox(
                  height: 60,
                  width: 300,
                  child: TextField(controller: usesController,
                    decoration: InputDecoration(
                        hintText: 'Can be used for:'),
                  ),
                ),
                SizedBox(
                  height: 60,
                  width: 300,
                  child: TextField(controller: cautionController,
                    decoration: InputDecoration(
                        hintText: 'Cations'),
                  ),
                ),
                SizedBox(
                  height: 60,
                  width: 300,
                  child: TextField(controller: consumerInfoController,
                    decoration: InputDecoration(
                        hintText: 'Consumer information'),
                  ),
                ),
                SizedBox(
                  height: 60,
                  width: 300,
                  child: TextField(controller: referencesController,
                    decoration: InputDecoration(
                        hintText: 'References'),
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
    final TextEditingController sourceController = TextEditingController(text: item.source);
    final TextEditingController formsAvailableController = TextEditingController(text: item.formsAvailable);
    final TextEditingController usesController = TextEditingController(text: item.uses);
    final TextEditingController cautionController = TextEditingController(text: item.caution);
    final TextEditingController consumerInfoController = TextEditingController(text: item.consumerInfo);
    final TextEditingController referencesController = TextEditingController(text: item.references);
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
                  TextField(
                    controller: formsAvailableController,
                    decoration: InputDecoration(labelText: 'Forms Availible'),
                  ),
                  TextField(
                    controller: sourceController,
                    decoration: InputDecoration(labelText: 'Source'),
                  ),
                  TextField(
                    controller: usesController,
                    decoration: InputDecoration(labelText: 'Uses'),
                  ),
                  TextField(
                    controller: cautionController,
                    decoration: InputDecoration(labelText: 'Caution'),
                  ),
                  TextField(
                    controller: consumerInfoController,
                    decoration: InputDecoration(labelText: 'Consumer Infromation'),
                  ),
                  TextField(
                    controller: referencesController,
                    decoration: InputDecoration(labelText: 'References'),
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
                    item.formsAvailable = formsAvailableController.text;
                    item.source = sourceController.text;
                    item.uses = usesController.text;
                    item.caution = cautionController.text;
                    item.consumerInfo = consumerInfoController.text;
                    item.references = referencesController.text;

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