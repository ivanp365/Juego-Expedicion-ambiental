import '../models/bin_type.dart';
import '../models/waste_item.dart';

class BinsRepository {
  static const bins = [
    BinType(
      title: "Blanco",
      image: "assets/images/clasificaton/bins/blanco.png",
      type: WasteType.recyclable,
    ),

    BinType(
      title: "Verde",
      image: "assets/images/clasificaton/bins/verde.png",
      type: WasteType.organic,
    ),

    BinType(
      title: "Negro",
      image: "assets/images/clasificaton/bins/negro.png",
      type: WasteType.nonRecyclable,
    ),

    BinType(
      title: "Especial",
      image: "assets/images/clasificaton/bins/rojo.png",
      type: WasteType.hazardous,
    ),
  ];
}
