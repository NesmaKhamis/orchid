import 'package:flutter/material.dart';

import '../../data/models/reward_request.dart';
import 'status_chip.dart';

class RequestStatusChip extends StatelessWidget {
  const RequestStatusChip({
    super.key,
    required this.status,
  });

  final RewardRequestStatus status;

  @override
  Widget build(BuildContext context) {
    final StatusChipTone tone = switch (status) {
      RewardRequestStatus.pending => StatusChipTone.info,
      RewardRequestStatus.review => StatusChipTone.warning,
      RewardRequestStatus.ready => StatusChipTone.success,
      RewardRequestStatus.received => StatusChipTone.info,
    };

    return StatusChip(
      label: status.labelArabic,
      tone: tone,
    );
  }
}
