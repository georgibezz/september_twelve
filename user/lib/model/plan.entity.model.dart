import 'package:objectbox/objectbox.dart';

@Sync()
@Entity()
class Plan {
  @Id()
  int id = 0;
  String name;
  String description;
  String symptomOrCondition; // Store either symptom or condition name
  List<String> herbalAlternativeNames = []; // List of herbal alternative names
  List<String> howToUseList = []; // List of how to use instructions
  List<String> cautionList = []; // List of caution instructions

  Plan(
      this.name,
      this.description,
      this.symptomOrCondition,
      this.herbalAlternativeNames,
      this.howToUseList,
      this.cautionList,
      );
}
