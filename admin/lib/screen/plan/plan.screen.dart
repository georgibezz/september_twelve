import 'package:admin/main.dart';
import 'package:admin/model/plan.entity.model.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart'; // Import the Plan entity

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
        final TextEditingController commonlyUsedDrugsController = TextEditingController();
        final TextEditingController herbalAlternativeController = TextEditingController();
        final TextEditingController howToUseController = TextEditingController();
        final TextEditingController cautionController = TextEditingController();

        return AlertDialog(
          title: Text('Add Plan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: commonlyUsedDrugsController,
                decoration: InputDecoration(labelText: 'Commonly Used Drugs'),
              ),
              TextField(
                controller: herbalAlternativeController,
                decoration: InputDecoration(labelText: 'Herbal Alternative'),
              ),
              TextField(
                controller: howToUseController,
                decoration: InputDecoration(labelText: 'How to Use'),
              ),
              TextField(
                controller: cautionController,
                decoration: InputDecoration(labelText: 'Caution'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final String name = nameController.text;
                final String commonlyUsedDrugs = commonlyUsedDrugsController.text;
                final String herbalAlternative = herbalAlternativeController.text;
                final String howToUse = howToUseController.text;
                final String caution = cautionController.text;

                if (name.isNotEmpty) {
                  final newPlan = Plan(
                    name,
                    commonlyUsedDrugs,
                    herbalAlternative,
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
        final TextEditingController nameController =
        TextEditingController(text: plan.name);
        final TextEditingController commonlyUsedDrugsController =
        TextEditingController(text: plan.commonlyUsedDrugs);
        final TextEditingController herbalAlternativeController =
        TextEditingController(text: plan.herbalAlternative);
        final TextEditingController howToUseController =
        TextEditingController(text: plan.howToUse);
        final TextEditingController cautionController =
        TextEditingController(text: plan.caution);

        return AlertDialog(
          title: Text('Edit Plan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: commonlyUsedDrugsController,
                decoration: InputDecoration(labelText: 'Commonly Used Drugs'),
              ),
              TextField(
                controller: herbalAlternativeController,
                decoration: InputDecoration(labelText: 'Herbal Alternative'),
              ),
              TextField(
                controller: howToUseController,
                decoration: InputDecoration(labelText: 'How to Use'),
              ),
              TextField(
                controller: cautionController,
                decoration: InputDecoration(labelText: 'Caution'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final String name = nameController.text;
                final String commonlyUsedDrugs = commonlyUsedDrugsController.text;
                final String herbalAlternative = herbalAlternativeController.text;
                final String howToUse = howToUseController.text;
                final String caution = cautionController.text;

                if (name.isNotEmpty) {
                  final updatedPlan = plan
                    ..name = name
                    ..commonlyUsedDrugs = commonlyUsedDrugs
                    ..herbalAlternative = herbalAlternative
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
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Name: ${plan.name}'),
              Text('Commonly Used Drugs: ${plan.commonlyUsedDrugs}'),
              Text('Herbal Alternative: ${plan.herbalAlternative}'),
              Text('How to Use: ${plan.howToUse}'),
              Text('Caution: ${plan.caution}'),
              // Add more plan attributes here
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
            subtitle: Text(plan.commonlyUsedDrugs),
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
