import 'package:objectbox/objectbox.dart';

@Sync() //important
@Entity()
class Item {
  @Id()
  int id = 0;

  final String name;
  final String alsoCalled;
  final String partUsed;

  Item(this.name, this.alsoCalled, this.partUsed);
}