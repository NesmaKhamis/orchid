class RewardItem {
  const RewardItem({
    required this.id,
    required this.title,
    required this.description,
    required this.cost,
    required this.imageAsset,
    required this.stock,
    required this.pickupInstructions,
    this.emoji = '🎁',
  });

  final String id;
  final String title;
  final String description;
  final int cost;
  final String imageAsset;
  final int stock;
  final String pickupInstructions;
  final String emoji;

  bool get isOutOfStock => stock <= 0;

  RewardItem copyWith({
    String? id,
    String? title,
    String? description,
    int? cost,
    String? imageAsset,
    int? stock,
    String? pickupInstructions,
    String? emoji,
  }) {
    return RewardItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      cost: cost ?? this.cost,
      imageAsset: imageAsset ?? this.imageAsset,
      stock: stock ?? this.stock,
      pickupInstructions: pickupInstructions ?? this.pickupInstructions,
      emoji: emoji ?? this.emoji,
    );
  }

  factory RewardItem.fromMap(String id, Map<String, dynamic> map) {
    return RewardItem(
      id: id,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      cost: (map['cost'] as num?)?.toInt() ?? 0,
      imageAsset: map['imageAsset'] as String? ?? '',
      stock: (map['stock'] as num?)?.toInt() ?? 0,
      pickupInstructions: map['pickupInstructions'] as String? ?? '',
      emoji: map['emoji'] as String? ?? '🎁',
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
    'title': title,
    'description': description,
    'cost': cost,
    'imageAsset': imageAsset,
    'stock': stock,
    'pickupInstructions': pickupInstructions,
    'emoji': emoji,
  };
}
