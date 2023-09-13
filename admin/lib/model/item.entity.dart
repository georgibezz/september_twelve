import 'package:objectbox/objectbox.dart';

@Sync() //important
@Entity()
class Item {
  @Id()
  int id = 0;

  String name;
  String alsoCalled;
  String partUsed;

  Item(this.name, this.alsoCalled, this.partUsed);
}