import 'package:hive/hive.dart';

part 'stock.g.dart';

@HiveType(typeId: 0)
class Stock extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int units;

  @HiveField(2)
  double unitPrice;

  @HiveField(3)
  double totalPrice;
  
  @HiveField(4)
  String store; 

  Stock({
    required this.name,
    required this.units,
    required this.unitPrice,
    required this.store,
  }) : totalPrice = units * unitPrice;
}
