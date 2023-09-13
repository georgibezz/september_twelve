import 'package:flutter/material.dart';
import 'main.dart';
import 'item.entity.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController namecontroller;
  late final TextEditingController alsoCalledcontroller;

  @override
  void initState() {
    namecontroller = TextEditingController();
    alsoCalledcontroller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    namecontroller.dispose();
    alsoCalledcontroller.dispose();
    super.dispose();
  }

  void addToList() {
    store.box<Item>().put(Item(namecontroller.text,alsoCalledcontroller.text));
    namecontroller.text = '';
    alsoCalledcontroller.text = '';
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
                  child: TextField(controller: namecontroller),
                ),
                SizedBox(
                  height: 60,
                  width: 300,
                  child: TextField(controller: alsoCalledcontroller),
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
          return ListView(
            children: snapshot.data!.map((item) {
              return Card(
                child: ListTile(
                  title: Text(item.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => removeSelectedItem(item),
                  ),
                ),
              );
            }).toList(),
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