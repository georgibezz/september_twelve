import 'package:admin/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:admin/model/condition.entity.dart'; // Update with your actual import

class ConditionsPage extends StatefulWidget {
  @override
  _ConditionsPageState createState() => _ConditionsPageState();
}

class _ConditionsPageState extends State<ConditionsPage> {
  late final Store _store;
  late final Box<Conditions> _conditionBox;
  late List<Conditions> _conditions;

  @override
  void initState() {
    super.initState();
    _store = Store(getObjectBoxModel());
    _conditionBox = Box<Conditions>(_store);
    _loadConditions();
  }

  Future<void> _loadConditions() async {
    _conditions = await _conditionBox.getAll();
    setState(() {});
  }

  @override
  void dispose() {
    _store.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conditions Listing'),
      ),
      body: ListView.builder(
        itemCount: _conditions.length,
        itemBuilder: (context, index) {
          final condition = _conditions[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(condition.name),
              subtitle: Text(condition.description),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showEditDialog(context, condition);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteCondition(condition);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add condition screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddConditionPage(
                onAdditionComplete: () {
                  _loadConditions();
                },
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _deleteCondition(Conditions condition) {
    _conditionBox.remove(condition.id);
    _loadConditions();
  }

  Future<void> showEditDialog(BuildContext context, Conditions condition) async {
    final TextEditingController nameController = TextEditingController(text: condition.name);
    final TextEditingController descriptionController = TextEditingController(text: condition.description);

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Edit Condition Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                // Update condition values
                condition.name = nameController.text;
                condition.description = descriptionController.text;

                // Update condition in the database
                await _conditionBox.put(condition);

                // Close the dialog
                Navigator.pop(context);
                _loadConditions();
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
  }
}

class AddConditionPage extends StatefulWidget {
  final VoidCallback onAdditionComplete;

  const AddConditionPage({required this.onAdditionComplete});

  @override
  _AddConditionPageState createState() => _AddConditionPageState();
}

class _AddConditionPageState extends State<AddConditionPage> {
  late final Store _store;
  late final Box<Conditions> _conditionBox;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _store = Store(getObjectBoxModel());
    _conditionBox = Box<Conditions>(_store);
  }

  @override
  void dispose() {
    _store.close();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Condition'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _addCondition();
              },
              child: const Text('Add Condition to Database'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addCondition() async {
    final String name = _nameController.text.trim();
    final String description = _descriptionController.text.trim();

    if (name.isNotEmpty && description.isNotEmpty) {
      final Conditions newCondition = Conditions(0, name, description, [], []);
      await _conditionBox.put(newCondition);
      widget.onAdditionComplete();
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('Name and Description are required fields.'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
