import 'package:objectbox/objectbox.dart';

@Sync()
@Entity()
class Item {
  @Id()
  int id = 0;

  final String name;
  final String alsoCalled;

  Item(this.name, this.alsoCalled);
}