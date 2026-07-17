enum WasteType { recyclable, organic, nonRecyclable, hazardous }

class WasteItem {
  final String id;
  final String name;
  final String image;
  final WasteType type;

  const WasteItem({
    required this.id,
    required this.name,
    required this.image,
    required this.type,
  });
}
