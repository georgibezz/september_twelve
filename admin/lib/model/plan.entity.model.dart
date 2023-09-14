import 'package:objectbox/objectbox.dart';

@Sync()
@Entity()
class Plan {
  @Id()
  int id = 0;
  String name;
  String commonlyUsedDrugs;
  String herbalAlternative;
  String howToUse;
  String caution;

  Plan(
      this.name,
      this.commonlyUsedDrugs,
      this.herbalAlternative,
      this.howToUse,
      this.caution,
      );
}