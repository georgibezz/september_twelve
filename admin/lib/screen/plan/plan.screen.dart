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
    String selectedType = 'Symptom'; // Set an initial value

    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController herbalAlternativeNameController = TextEditingController();
        final TextEditingController herbalAlternativeHowToUseController = TextEditingController();
        final TextEditingController herbalAlternativeCautionController = TextEditingController();

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
                    value: selectedType, // Use the selectedType variable
                    onChanged: (value) {
                      setState(() {
                        selectedType = value!;
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
                SizedBox(height: 16),
                Text('Add Herbal Alternative:'),
                TextField(
                  controller: herbalAlternativeNameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: herbalAlternativeHowToUseController,
                  decoration: InputDecoration(labelText: 'How to Use'),
                ),
                TextField(
                  controller: herbalAlternativeCautionController,
                  decoration: InputDecoration(labelText: 'Caution'),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    final name = herbalAlternativeNameController.text;
                    final howToUse = herbalAlternativeHowToUseController.text;
                    final caution = herbalAlternativeCautionController.text;

                    if (name.isNotEmpty && howToUse.isNotEmpty && caution.isNotEmpty) {
                      herbalAlternativeNames.add(name);
                      howToUseList.add(howToUse);
                      cautionList.add(caution);

                      herbalAlternativeNameController.clear();
                      herbalAlternativeHowToUseController.clear();
                      herbalAlternativeCautionController.clear();

                      setState(() {});
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final String name = nameController.text;
                final String description = descriptionController.text;

                if (selectedType.isNotEmpty && name.isNotEmpty) {
                  final newPlan = Plan(
                    name,
                    description,
                    selectedType, // Use the selected type
                    herbalAlternativeNames,
                    howToUseList,
                    cautionList,
                  );

                  _planBox.put(newPlan);
                  _loadPlans(); // Reload plans after adding
                  Navigator.pop(context);
                } else {
                  // Handle the case where the type or name is empty.
                  // You can show an error message or inform the user.
                  print('Invalid type or empty name.');
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
    final TextEditingController editNameController = TextEditingController(text: plan.name);
    final TextEditingController editDescriptionController = TextEditingController(text: plan.description);
    final TextEditingController editSymptomOrConditionController = TextEditingController(text: plan.symptomOrCondition);

    // Create controllers for herbal alternative fields
    final List<TextEditingController> herbalAlternativeNameControllers = [];
    final List<TextEditingController> howToUseControllers = [];
    final List<TextEditingController> cautionControllers = [];

    for (int i = 0; i < plan.herbalAlternativeNames.length; i++) {
      herbalAlternativeNameControllers.add(TextEditingController(text: plan.herbalAlternativeNames[i]));
      howToUseControllers.add(TextEditingController(text: plan.howToUseList[i]));
      cautionControllers.add(TextEditingController(text: plan.cautionList[i]));
    }

    int selectedHerbalAlternativeIndex = -1; // To keep track of the selected herbal alternative

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit Plan'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: editNameController,
                      decoration: InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      controller: editDescriptionController,
                      decoration: InputDecoration(labelText: 'Description'),
                    ),
                    ListTile(
                      title: Text('Select Type:'),
                      contentPadding: EdgeInsets.all(0),
                      trailing: DropdownButton<String>(
                        value: editSymptomOrConditionController.text,
                        onChanged: (value) {
                          setState(() {
                            editSymptomOrConditionController.text = value!;
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
                      children: List.generate(plan.herbalAlternativeNames.length, (index) {
                        return Column(
                          children: [
                            ListTile(
                              title: Text(plan.herbalAlternativeNames[index]),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('How to Use: ${plan.howToUseList[index]}'),
                                  Text('Caution: ${plan.cautionList[index]}'),
                                ],
                              ),
                              onTap: () {
                                // Set the selected index when a herbal alternative is tapped
                                setState(() {
                                  selectedHerbalAlternativeIndex = index;
                                });
                              },
                            ),
                            if (index == selectedHerbalAlternativeIndex)
                              Column(
                                children: [
                                  TextField(
                                    controller: herbalAlternativeNameControllers[index],
                                    decoration: InputDecoration(labelText: 'Name'),
                                  ),
                                  TextField(
                                    controller: howToUseControllers[index],
                                    decoration: InputDecoration(labelText: 'How to Use'),
                                  ),
                                  TextField(
                                    controller: cautionControllers[index],
                                    decoration: InputDecoration(labelText: 'Caution'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      final name = herbalAlternativeNameControllers[index].text;
                                      final howToUse = howToUseControllers[index].text;
                                      final caution = cautionControllers[index].text;

                                      if (name.isNotEmpty && howToUse.isNotEmpty && caution.isNotEmpty) {
                                        // Update the values in the plan
                                        plan.herbalAlternativeNames[index] = name;
                                        plan.howToUseList[index] = howToUse;
                                        plan.cautionList[index] = caution;
                                      }

                                      setState(() {
                                        selectedHerbalAlternativeIndex = -1; // Deselect after saving
                                      });
                                    },
                                    child: Text('Save'),
                                  ),
                                ],
                              ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    final String name = editNameController.text;
                    final String description = editDescriptionController.text;
                    final String symptomOrCondition = editSymptomOrConditionController.text;

                    if (['Symptom', 'Condition'].contains(symptomOrCondition) && name.isNotEmpty) {
                      final updatedPlan = Plan(
                        name,
                        description,
                        symptomOrCondition,
                        plan.herbalAlternativeNames,
                        plan.howToUseList,
                        plan.cautionList,
                      );

                      updatedPlan.id = plan.id; // Preserve the ID
                      _planBox.put(updatedPlan);
                      _loadPlans(); // Reload plans after editing
                      Navigator.pop(context);
                    } else {
                      // Handle the case where an invalid value is selected.
                      // You can show an error message or inform the user.
                      print('Invalid symptom or condition value or empty name.');
                    }
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
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
