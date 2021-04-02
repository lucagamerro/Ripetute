import 'package:hive/hive.dart';

part 'stat.g.dart';

@HiveType(typeId: 1)
class Stat {
  @HiveField(0)
  String tipo;

  @HiveField(1)
  String data;

  Stat(this.tipo, this.data);
}
