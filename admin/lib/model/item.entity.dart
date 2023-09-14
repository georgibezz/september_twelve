import 'package:objectbox/objectbox.dart';

@Sync() //important
@Entity()
class Item {
  @Id()
  int id = 0;

  String name;
  String alsoCalled;
  String partUsed;
  String source;
  String formsAvailable;
  String uses;
  String caution;
  String consumerInfo;
  String references;

  Item(this.name, this.alsoCalled, this.partUsed, this.source, this.formsAvailable, this.uses, this.caution, this.consumerInfo,this.references);
}