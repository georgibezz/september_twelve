import 'package:flutter/material.dart';
import 'package:user/components/bottom.nav.bar.dart';
import 'package:user/constants/enums.dart';
import 'package:user/model/plan.entity.model.dart'; // Import your Plan model

class PlanDetailPage extends StatefulWidget {
  final String? planName;
  final String? herbalAlternative;

  const PlanDetailPage({Key? key, this.planName, this.herbalAlternative}) : super(key: key);

  @override
  _PlanDetailPageState createState() => _PlanDetailPageState();
}

class _PlanDetailPageState extends State<PlanDetailPage> {
  String selectedTab = 'Information';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.planName ?? 'Plan Details'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 32),
                const SizedBox(width: 8),
                Text(
                  widget.planName ?? 'Plan Details',
                  style: const TextStyle(fontSize: 24),
                ),
              ],
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildTabButton('Information', Icons.info_outline),
              buildTabButton('Herbal Alternatives', Icons.nature_people),
              buildTabButton('Instructions', Icons.how_to_vote),
              buildTabButton('Caution', Icons.warning_amber),
              buildTabButton('Reviews', Icons.comment),
            ],
          ),
          const Divider(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: buildSelectedTabContent(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.remedy),
    );
  }

  Widget buildTabButton(String tabName, IconData iconData) {
    bool isSelected = selectedTab == tabName;
    Color? iconColor = Colors.white;

    if (isSelected) {
      switch (tabName) {
        case 'Information':
          iconColor = Colors.green[300];
          break;
        case 'Herbal Alternatives':
          iconColor = Colors.brown[300];
          break;
        case 'Instructions':
          iconColor = Colors.blue[300];
          break;
        case 'Caution':
          iconColor = Colors.yellow[300];
          break;
        case 'Reviews':
          iconColor = Colors.pink[300];
          break;
        default:
          break;
      }
    }

    return InkWell(
      onTap: () {
        setState(() {
          selectedTab = isSelected ? '' : tabName;
        });
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: isSelected ? iconColor : Colors.grey,
            child: Icon(
              iconData,
              color: isSelected ? Colors.white : iconColor,
            ),
          ),
          Visibility(
            visible: isSelected,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(tabName),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSelectedTabContent() {
    switch (selectedTab) {
      case 'Information':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${widget.planName ?? ""}'),
            Text('Description: ${widget.planName != null ? getPlanDescription(widget.planName!) : ""}'),
          ],
        );
      case 'Herbal Alternatives':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.planName != null && widget.herbalAlternative != null)
              Text('Herbal Alternative: ${widget.herbalAlternative}'),
          ],
        );
      case 'Instructions':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.herbalAlternative != null)
              Text('How to Use: ${getHowToUseForHerbalAlternative(widget.herbalAlternative!)}'),
          ],
        );
      case 'Caution':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.herbalAlternative != null)
              Text('Caution: ${getCautionForHerbalAlternative(widget.herbalAlternative!)}'),
          ],
        );
      case 'Reviews':
        return const Text('Functionality not yet implemented.');
      default:
        return const SizedBox.shrink();
    }
  }

  // Implement functions to fetch description, how to use, and caution based on plan name and herbal alternative
  String getPlanDescription(String planName) {
    // Fetch plan description based on planName from the server
    // Replace with your server data retrieval logic
    return "Plan description for $planName";
  }

  String getHowToUseForHerbalAlternative(String herbalAlternative) {
    // Fetch how to use instructions based on herbalAlternative from the server
    // Replace with your server data retrieval logic
    return "How to use instructions for $herbalAlternative";
  }

  String getCautionForHerbalAlternative(String herbalAlternative) {
    // Fetch caution instructions based on herbalAlternative from the server
    // Replace with your server data retrieval logic
    return "Caution for $herbalAlternative";
  }
}
