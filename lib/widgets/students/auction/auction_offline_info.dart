import 'package:flutter/material.dart';
import '../../../models/auction_model.dart';

class AuctionOfflineInfo extends StatelessWidget {
  final AuctionEvent event;
  const AuctionOfflineInfo({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFBFCAFF), width: 1),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.info_outline, color: Color(0xFF4F6EF7), size: 20),
          const SizedBox(width: 8),
          const Text('Offline Auксion',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E3A8A))),
        ]),
        const SizedBox(height: 8),
        Text(
          "Auксion offline tarzda o'tkaziladi. Ishtirok etish uchun belgilangan vaqtda markazga tashrif buyuring.",
          style: TextStyle(color: Colors.grey.shade700, fontSize: 13, height: 1.5),
        ),
        const SizedBox(height: 8),
        Row(children: [
          const Icon(Icons.location_on_outlined, color: Color(0xFF4F6EF7), size: 16),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              'Manzil: ${event.location}',
              style: const TextStyle(
                color: Color(0xFF4F6EF7),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ]),
      ]),
    );
  }
}