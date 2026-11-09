enum RewardRequestStatus {
  pending, // طلب جديد
  review,  // قيد المراجعة
  ready,   // جاهزة للاستلام
  received // تم الاستلام
}

extension RewardRequestStatusX on RewardRequestStatus {
  String get labelArabic {
    switch (this) {
      case RewardRequestStatus.pending:
        return 'طلب جديد';
      case RewardRequestStatus.review:
        return 'قيد المراجعة';
      case RewardRequestStatus.ready:
        return 'جاهزة للاستلام';
      case RewardRequestStatus.received:
        return 'تم الاستلام';
    }
  }
}

class RewardRequest {
  const RewardRequest({
    required this.id,
    required this.rewardId,
    required this.rewardTitle,
    required this.cost,
    required this.status,
    required this.createdAt,
    required this.pickupInstructions,
  });

  final String id;
  final String rewardId;
  final String rewardTitle;
  final int cost;
  final RewardRequestStatus status;
  final DateTime createdAt;
  final String pickupInstructions;

  RewardRequest copyWith({
    String? id,
    String? rewardId,
    String? rewardTitle,
    int? cost,
    RewardRequestStatus? status,
    DateTime? createdAt,
    String? pickupInstructions,
  }) {
    return RewardRequest(
      id: id ?? this.id,
      rewardId: rewardId ?? this.rewardId,
      rewardTitle: rewardTitle ?? this.rewardTitle,
      cost: cost ?? this.cost,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      pickupInstructions: pickupInstructions ?? this.pickupInstructions,
    );
  }

  factory RewardRequest.fromMap(String id, Map<String, dynamic> map) {
    final dynamic rawDate = map['createdAt'];
    final DateTime date;
    if (rawDate is DateTime) {
      date = rawDate;
    } else if (rawDate is String) {
      date = DateTime.tryParse(rawDate) ?? DateTime.now();
    } else {
      date = DateTime.now();
    }

    final String statusString = map['status'] as String? ?? 'pending';
    final RewardRequestStatus status = RewardRequestStatus.values.firstWhere(
      (RewardRequestStatus e) => e.name == statusString,
      orElse: () => RewardRequestStatus.pending,
    );

    return RewardRequest(
      id: id,
      rewardId: map['rewardId'] as String? ?? '',
      rewardTitle: map['rewardTitle'] as String? ?? '',
      cost: (map['cost'] as num?)?.toInt() ?? 0,
      status: status,
      createdAt: date,
      pickupInstructions: map['pickupInstructions'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
    'rewardId': rewardId,
    'rewardTitle': rewardTitle,
    'cost': cost,
    'status': status.name,
    'createdAt': createdAt.toIso8601String(),
    'pickupInstructions': pickupInstructions,
  };
}
