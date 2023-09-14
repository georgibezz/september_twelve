import 'package:admin/main.dart';
import 'package:admin/model/symptom.entity.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart'; // Import ObjectBox

class SymptomScreen extends StatefulWidget {
  @override
  _SymptomScreenState createState() => _SymptomScreenState();
}

class _SymptomScreenState extends State<SymptomScreen> {
  late final Box<Symptoms> _symptomBox; // Define a Box for Conditions
  List<Symptoms> _symptoms = [];

  @override
  void initState() {
    super.initState();
    _symptomBox = store.box<Symptoms>(); // Initialize the Condition Box
    _loadSymptoms(); // Load conditions from the database
  }

  Future<void> _loadSymptoms() async {
    _symptoms = _symptomBox.getAll();
    setState(() {});
  }

  void _addSymptom() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController nameController = TextEditingController();
        final TextEditingController descriptionController = TextEditingController();
        final TextEditingController causesController = TextEditingController();
        final TextEditingController complicationsController = TextEditingController();

        return AlertDialog(
          title: Text('Add Symptom'),
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
                  final newSymptom = Symptoms(
                    0, // You can set a unique ID, or ObjectBox will auto-generate one.
                    name,
                    description,
                    complications,
                    causes,
                  );

                  _symptomBox.put(newSymptom);
                  _loadSymptoms(); // Reload conditions after adding
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

  void _editSymptom(Symptoms symptom) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController nameController =
        TextEditingController(text: symptom.name);
        final TextEditingController descriptionController =
        TextEditingController(text: symptom.description);
        final TextEditingController causesController =
        TextEditingController(text: symptom.causes.join(', '));
        final TextEditingController complicationsController =
        TextEditingController(text: symptom.complications.join(', '));

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
                  final updatedSymptom = symptom
                    ..name = name
                    ..description = description
                    ..causes = causes
                    ..complications = complications;

                  _symptomBox.put(updatedSymptom);
                  _loadSymptoms(); // Reload conditions after editing
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

  void _viewSymptomDetails(Symptoms symptom) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Condition Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Name: ${symptom.name}'),
              Text('Description: ${symptom.description}'),
              Text('Causes: ${symptom.causes.join(', ')}'),
              Text('Complications: ${symptom.complications.join(', ')}'),
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

  void _deleteSymptom(Symptoms symptom) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Condition'),
          content: Text('Are you sure you want to delete this condition?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                _symptomBox.remove(symptom.id);
                _loadSymptoms(); // Reload conditions after deleting
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
        title: Text('Symptoms'),
      ),
      body: ListView.builder(
        itemCount: _symptoms.length,
        itemBuilder: (context, index) {
          final symptom = _symptoms[index];
          return ListTile(
            title: Text(symptom.name),
            subtitle: Text(symptom.description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _editSymptom(symptom);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteSymptom(symptom);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.visibility),
                  onPressed: () {
                    _viewSymptomDetails(symptom);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSymptom,
        child: Icon(Icons.add),
      ),
    );
  }
}
