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

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController symptomOrConditionController = TextEditingController();
  final TextEditingController herbalAlternativeNameController = TextEditingController();
  final TextEditingController howToUseController = TextEditingController();
  final TextEditingController cautionController = TextEditingController();
  final List<String> herbalAlternativeNames = []; // Initialize the list
  final List<String> howToUseList = []; // Initialize the list
  final List<String> cautionList = []; // Initialize the list

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
                ListTile(
                  title: Text('Select Type:'),
                  contentPadding: EdgeInsets.all(0),
                  trailing: DropdownButton<String>(
                    value: symptomOrConditionController.text,
                    onChanged: (value) {
                      setState(() {
                        symptomOrConditionController.text = value!;
                      });
                    },
                    items: ['Symptom', 'Condition'].map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 16),
                Text('Herbal Alternatives:'),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: herbalAlternativeNameController,
                            decoration: InputDecoration(labelText: 'Name'),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            final name = herbalAlternativeNameController.text;
                            final howToUse = howToUseController.text;
                            final caution = cautionController.text;

                            if (name.isNotEmpty) {
                              herbalAlternativeNames.add(name);
                              howToUseList.add(howToUse);
                              cautionList.add(caution);

                              herbalAlternativeNameController.clear();
                              howToUseController.clear();
                              cautionController.clear();

                              setState(() {});
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Column(
                      children: List.generate(herbalAlternativeNames.length, (index) {
                        return Card(
                          child: ListTile(
                            title: Text(herbalAlternativeNames[index]),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('How to Use: ${howToUseList[index]}'),
                                Text('Caution: ${cautionList[index]}'),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                herbalAlternativeNames.removeAt(index);
                                howToUseList.removeAt(index);
                                cautionList.removeAt(index);
                                setState(() {});
                              },
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
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

                if (name.isNotEmpty) {
                  final newPlan = Plan(
                    name,
                    description,
                    symptomOrCondition,
                    herbalAlternativeNames,
                    howToUseList,
                    cautionList,
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
        final TextEditingController symptomOrConditionController =
        TextEditingController(text: plan.symptomOrCondition);
        final List<String> herbalAlternativeNames = plan.herbalAlternativeNames;
        final List<String> howToUseList = plan.howToUseList;
        final List<String> cautionList = plan.cautionList;

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
                ListTile(
                  title: Text('Select Type:'),
                  contentPadding: EdgeInsets.all(0),
                  trailing: DropdownButton<String>(
                    value: symptomOrConditionController.text,
                    onChanged: (value) {
                      setState(() {
                        symptomOrConditionController.text = value!;
                      });
                    },
                    items: ['Symptom', 'Condition'].map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 16),
                Text('Herbal Alternatives:'),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: herbalAlternativeNameController,
                            decoration: InputDecoration(labelText: 'Name'),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            final name = herbalAlternativeNameController.text;
                            final howToUse = howToUseController.text;
                            final caution = cautionController.text;

                            if (name.isNotEmpty) {
                              herbalAlternativeNames.add(name);
                              howToUseList.add(howToUse);
                              cautionList.add(caution);

                              herbalAlternativeNameController.clear();
                              howToUseController.clear();
                              cautionController.clear();

                              setState(() {});
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Column(
                      children: List.generate(herbalAlternativeNames.length, (index) {
                        return Card(
                          child: ListTile(
                            title: Text(herbalAlternativeNames[index]),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('How to Use: ${howToUseList[index]}'),
                                Text('Caution: ${cautionList[index]}'),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                herbalAlternativeNames.removeAt(index);
                                howToUseList.removeAt(index);
                                cautionList.removeAt(index);
                                setState(() {});
                              },
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
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

                if (name.isNotEmpty) {
                  final updatedPlan = Plan(
                    name,
                    description,
                    symptomOrCondition,
                    herbalAlternativeNames,
                    howToUseList,
                    cautionList,
                  );

                  updatedPlan.id = plan.id; // Preserve the ID
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
                  children: List.generate(plan.herbalAlternativeNames.length, (index) {
                    return ListTile(
                      title: Text(plan.herbalAlternativeNames[index]),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('How to Use: ${plan.howToUseList[index]}'),
                          Text('Caution: ${plan.cautionList[index]}'),
                        ],
                      ),
                    );
                  }),
                ),
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
