import 'package:admin/main.dart';
import 'package:admin/model/plan.entity.model.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';

class PlanScreen extends StatefulWidget {
  @override
  _PlanScreenState createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  late final Box<Plan> _planBox; // Define a Box for Plans
  List<Plan> _plans = [];

  @override
  void initState() {
    super.initState();
    _planBox = store.box<Plan>(); // Initialize the Plan Box
    _loadPlans(); // Load plans from the database
  }

  Future<void> _loadPlans() async {
    _plans = _planBox.getAll();
    setState(() {});
  }

  void _addPlan() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController nameController = TextEditingController();
        final TextEditingController descriptionController = TextEditingController();
        final TextEditingController symptomOrConditionController = TextEditingController();
        final List<String> herbalAlternatives = [];
        final List<String> howToUse = [];
        final TextEditingController cautionController = TextEditingController();

        return AlertDialog(
          title: Text('Add Plan'),
          content: SingleChildScrollView(
            child: Column(
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
                  controller: symptomOrConditionController,
                  decoration: InputDecoration(labelText: 'Symptom or Condition'),
                ),
                Text('Herbal Alternatives:'),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(labelText: 'Herbal Alternative'),
                        onChanged: (value) {
                          herbalAlternatives.add(value);
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {});
                      },
                    ),
                  ],
                ),
                Text('How to Use:'),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(labelText: 'How to Use'),
                        onChanged: (value) {
                          howToUse.add(value);
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {});
                      },
                    ),
                  ],
                ),
                TextField(
                  controller: cautionController,
                  decoration: InputDecoration(labelText: 'Caution'),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final String name = nameController.text;
                final String description = descriptionController.text;
                final String symptomOrCondition = symptomOrConditionController.text;
                final String caution = cautionController.text;

                if (name.isNotEmpty && (symptomOrCondition.isNotEmpty || herbalAlternatives.isNotEmpty)) {
                  final newPlan = Plan(
                    name,
                    description,
                    symptomOrCondition,
                    herbalAlternatives,
                    howToUse,
                    caution,
                  );

                  _planBox.put(newPlan);
                  _loadPlans(); // Reload plans after adding
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

  void _editPlan(Plan plan) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController nameController = TextEditingController(text: plan.name);
        final TextEditingController descriptionController = TextEditingController(text: plan.description);
        final TextEditingController symptomOrConditionController = TextEditingController(text: plan.symptomOrCondition);
        final List<String> herbalAlternatives = plan.herbalAlternatives;
        final List<String> howToUse = plan.howToUse;
        final TextEditingController cautionController = TextEditingController(text: plan.caution);

        return AlertDialog(
          title: Text('Edit Plan'),
          content: SingleChildScrollView(
            child: Column(
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
                  controller: symptomOrConditionController,
                  decoration: InputDecoration(labelText: 'Symptom or Condition'),
                ),
                Text('Herbal Alternatives:'),
                Column(
                  children: herbalAlternatives.map((herbalAlternative) {
                    return Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: TextEditingController(text: herbalAlternative),
                            decoration: InputDecoration(labelText: 'Herbal Alternative'),
                            onChanged: (value) {
                              herbalAlternatives[herbalAlternatives.indexOf(herbalAlternative)] = value;
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            herbalAlternatives.remove(herbalAlternative);
                            setState(() {});
                          },
                        ),
                      ],
                    );
                  }).toList(),
                ),
                Text('How to Use:'),
                Column(
                  children: howToUse.map((instruction) {
                    return Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: TextEditingController(text: instruction),
                            decoration: InputDecoration(labelText: 'How to Use'),
                            onChanged: (value) {
                              howToUse[howToUse.indexOf(instruction)] = value;
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            howToUse.remove(instruction);
                            setState(() {});
                          },
                        ),
                      ],
                    );
                  }).toList(),
                ),
                TextField(
                  controller: cautionController,
                  decoration: InputDecoration(labelText: 'Caution'),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final String name = nameController.text;
                final String description = descriptionController.text;
                final String symptomOrCondition = symptomOrConditionController.text;
                final String caution = cautionController.text;

                if (name.isNotEmpty && (symptomOrCondition.isNotEmpty || herbalAlternatives.isNotEmpty)) {
                  final updatedPlan = plan
                    ..name = name
                    ..description = description
                    ..symptomOrCondition = symptomOrCondition
                    ..herbalAlternatives = herbalAlternatives
                    ..howToUse = howToUse
                    ..caution = caution;

                  _planBox.put(updatedPlan);
                  _loadPlans(); // Reload plans after editing
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

  void _viewPlanDetails(Plan plan) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Plan Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Name: ${plan.name}'),
                Text('Description: ${plan.description}'),
                Text('Symptom or Condition: ${plan.symptomOrCondition}'),
                Text('Herbal Alternatives:'),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: plan.herbalAlternatives.map((herbalAlternative) {
                    return Text('- $herbalAlternative');
                  }).toList(),
                ),
                Text('How to Use:'),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: plan.howToUse.map((instruction) {
                    return Text('- $instruction');
                  }).toList(),
                ),
                Text('Caution: ${plan.caution}'),
                // Add more plan attributes here
              ],
            ),
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

  void _deletePlan(Plan plan) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Plan'),
          content: Text('Are you sure you want to delete this plan?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                _planBox.remove(plan.id);
                _loadPlans(); // Reload plans after deleting
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
        title: Text('Plans'),
      ),
      body: ListView.builder(
        itemCount: _plans.length,
        itemBuilder: (context, index) {
          final plan = _plans[index];
          return ListTile(
            title: Text(plan.name),
            subtitle: Text(plan.symptomOrCondition),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _editPlan(plan);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deletePlan(plan);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.visibility),
                  onPressed: () {
                    _viewPlanDetails(plan);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPlan,
        child: Icon(Icons.add),
      ),
    );
  }
}
