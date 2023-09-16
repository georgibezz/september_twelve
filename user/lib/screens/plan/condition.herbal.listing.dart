import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:user/components/bottom.nav.bar.dart';
import 'package:user/components/home.screen.header.dart';
import 'package:user/constants/enums.dart';
import 'package:user/model/condition.entity.dart';
import 'package:user/model/plan.entity.model.dart';
import 'package:user/objectbox.g.dart';
import 'package:user/screens/plan/plan.detail.screen.dart';

class ConditionHerbalListing extends StatefulWidget {
  final Conditions condition;

  const ConditionHerbalListing({Key? key, required this.condition}) : super(key: key);

  @override
  _ConditionHerbalListingState createState() => _ConditionHerbalListingState();
}

class _ConditionHerbalListingState extends State<ConditionHerbalListing> {
  Store? _store;
  Box<Plan>? _planBox;
  late Stream<List<Plan>> _stream;
  String? _selectedPlanName;
  String? _selectedHerbalAlternative;

  @override
  void initState() {
    super.initState();
    openStore().then((Store store) {
      _store = store;
      Sync.client(
        store,
        'ws://137.158.109.230:9999', // Replace with your server's IP and port
        SyncCredentials.none(),
      ).start();

      _planBox = store.box<Plan>();
      _stream = _planBox!.query().watch(triggerImmediately: true).map((query) => query.find().toList());

      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _store?.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: HomeHeader(),
      ),
      body: SafeArea(
        child: StreamBuilder<List<Plan>>(
          stream: _stream,
          initialData: const <Plan>[],
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }

            final plans = snapshot.data ?? [];
            final herbalAlternatives = <String>[];

            if (_selectedPlanName == null) {
              for (final plan in plans) {
                if (plan.symptomOrCondition.toLowerCase() == widget.condition.name.toLowerCase()) {
                  herbalAlternatives.addAll(plan.herbalAlternativeNames);
                }
              }
            } else {
              // Display herbal alternatives for the selected plan
              final selectedPlan = plans.firstWhere(
                    (plan) => plan.name.toLowerCase() == _selectedPlanName!.toLowerCase(),
              );
              herbalAlternatives.addAll(selectedPlan.herbalAlternativeNames);
            }

            if (herbalAlternatives.isEmpty) {
              return Center(child: Text("No herbal alternatives available."));
            }

            return ListView.builder(
              itemCount: herbalAlternatives.length,
              itemBuilder: (context, index) {
                final herbalAlternative = herbalAlternatives[index];
                return Card(
                  child: ListTile(
                    title: Text(herbalAlternative),
                    onTap: () {
                      setState(() {
                        _selectedHerbalAlternative = herbalAlternative;
                      });
                      // Navigate to PlanDetailPage with the selected herbal alternative
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlanDetailPage(
                            planName: _selectedPlanName,
                            herbalAlternative: _selectedHerbalAlternative,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.remedy),
    );
  }
}
