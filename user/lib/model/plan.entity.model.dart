import 'package:objectbox/objectbox.dart';

@Sync()
@Entity()
class Plan {
  @Id()
  int id = 0;
  String name;
  String description;
  String symptomOrCondition; // Store either symptom or condition name
  List<String> herbalAlternatives = []; // List of herbal alternatives
  List<String> howToUse;
  String caution;

  Plan(
      this.name,
      this.description,
      this.symptomOrCondition,
     this.herbalAlternatives,
    this.howToUse,
  this.caution,
  );
}
