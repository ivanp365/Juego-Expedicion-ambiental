enum WasteType { organic, recyclable, hazardous, nonRecyclable }

class WasteItem {
  final String id;
  final String name;
  final WasteType type;
  final String image;

  const WasteItem({
    required this.id,
    required this.name,
    required this.type,
    required this.image,
  });
}
