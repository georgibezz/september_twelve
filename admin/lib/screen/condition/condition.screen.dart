import 'package:admin/main.dart';
import 'package:admin/model/condition.entity.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart'; // Import ObjectBox

class ConditionScreen extends StatefulWidget {
  @override
  _ConditionScreenState createState() => _ConditionScreenState();
}

class _ConditionScreenState extends State<ConditionScreen> {
  late final Box<Conditions> _conditionBox; // Define a Box for Conditions
  List<Conditions> _conditions = [];

  @override
  void initState() {
    super.initState();
    _conditionBox = store.box<Conditions>(); // Initialize the Condition Box
    _loadConditions(); // Load conditions from the database
  }

  Future<void> _loadConditions() async {
    _conditions = _conditionBox.getAll();
    setState(() {});
  }

  void _addCondition() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController nameController = TextEditingController();
        final TextEditingController descriptionController = TextEditingController();
        final TextEditingController causesController = TextEditingController();
        final TextEditingController complicationsController = TextEditingController();

        return AlertDialog(
          title: Text('Add Condition'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: causesController,
                decoration: InputDecoration(labelText: 'Causes (comma-separated)'),
              ),
              TextField(
                controller: complicationsController,
                decoration:
                InputDecoration(labelText: 'Complications (comma-separated)'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final String name = nameController.text;
                final String description = descriptionController.text;
                final List<String> causes =
                causesController.text.split(',').map((e) => e.trim()).toList();
                final List<String> complications = complicationsController.text
                    .split(',')
                    .map((e) => e.trim())
                    .toList();

                if (name.isNotEmpty && description.isNotEmpty) {
                  final newCondition = Conditions(
                    0, // You can set a unique ID, or ObjectBox will auto-generate one.
                    name,
                    description,
                    complications,
                    causes,
                  );

                  _conditionBox.put(newCondition);
                  _loadConditions(); // Reload conditions after adding
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _editCondition(Conditions condition) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController nameController =
        TextEditingController(text: condition.name);
        final TextEditingController descriptionController =
        TextEditingController(text: condition.description);
        final TextEditingController causesController =
        TextEditingController(text: condition.causes.join(', '));
        final TextEditingController complicationsController =
        TextEditingController(text: condition.complications.join(', '));

        return AlertDialog(
          title: Text('Edit Condition'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: causesController,
                decoration: InputDecoration(labelText: 'Causes (comma-separated)'),
              ),
              TextField(
                controller: complicationsController,
                decoration:
                InputDecoration(labelText: 'Complications (comma-separated)'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final String name = nameController.text;
                final String description = descriptionController.text;
                final List<String> causes =
                causesController.text.split(',').map((e) => e.trim()).toList();
                final List<String> complications = complicationsController.text
                    .split(',')
                    .map((e) => e.trim())
                    .toList();

                if (name.isNotEmpty && description.isNotEmpty) {
                  final updatedCondition = condition
                    ..name = name
                    ..description = description
                    ..causes = causes
                    ..complications = complications;

                  _conditionBox.put(updatedCondition);
                  _loadConditions(); // Reload conditions after editing
                  Navigator.pop(context);
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _viewConditionDetails(Conditions condition) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Condition Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Name: ${condition.name}'),
              Text('Description: ${condition.description}'),
              Text('Causes: ${condition.causes.join(', ')}'),
              Text('Complications: ${condition.complications.join(', ')}'),
              // Add more condition attributes here
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _deleteCondition(Conditions condition) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Condition'),
          content: Text('Are you sure you want to delete this condition?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                _conditionBox.remove(condition.id);
                _loadConditions(); // Reload conditions after deleting
                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
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
        title: Text('Conditions'),
      ),
      body: ListView.builder(
        itemCount: _conditions.length,
        itemBuilder: (context, index) {
          final condition = _conditions[index];
          return ListTile(
            title: Text(condition.name),
            subtitle: Text(condition.description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _editCondition(condition);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteCondition(condition);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.visibility),
                  onPressed: () {
                    _viewConditionDetails(condition);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCondition,
        child: Icon(Icons.add),
      ),
    );
  }
}
