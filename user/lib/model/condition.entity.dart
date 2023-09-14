import 'package:objectbox/objectbox.dart';

@Sync()
@Entity()
class Conditions {
  @Id()
  int id = 0;

  String name;
  String description;
  List<String> causes;
  List<String> complications;
  bool isSelected = false; // Add this line

  Conditions(
    this.id,
    this.name,
    this.description,
    this.complications,
    this.causes,
  );
}
