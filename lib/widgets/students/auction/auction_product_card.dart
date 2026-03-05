import 'package:flutter/material.dart';
import '../../../models/auction_model.dart';

class AuctionProductCard extends StatelessWidget {
  final AuctionProduct product;
  const AuctionProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Image with badges
        Stack(children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: product.imageUrl != null
                ? Image.network(
              product.imageUrl!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _defaultImage(),
            )
                : _defaultImage(),
          ),
          // Category badge (top left)
          Positioned(
            top: 12, left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
              ),
              child: Text(product.category,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
            ),
          ),
          // Offline badge (top right)
          if (product.isOffline)
            Positioned(
              top: 12, right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('Offline auксion',
                    style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
              ),
            ),
        ]),

        // Info
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(product.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(product.description,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.4)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: Colors.grey.shade200),
            ),
            Text("Boshlang'ich narx:",
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
            const SizedBox(height: 6),
            Row(children: [
              // Coin icon
              Stack(children: [
                Container(
                  width: 28, height: 28,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFB800),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.monetization_on, color: Colors.white, size: 18),
                ),
                Positioned(
                  right: 0, bottom: 0,
                  child: Container(
                    width: 14, height: 14,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF8C00),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ]),
              const SizedBox(width: 8),
              Text(
                _formatNumber(product.startingPrice),
                style: const TextStyle(
                  color: Color(0xFFFF8C00),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]),
          ]),
        ),
      ]),
    );
  }

  Widget _defaultImage() => Container(
    height: 200, width: double.infinity,
    color: Colors.grey.shade200,
    child: Icon(Icons.image_outlined, color: Colors.grey.shade400, size: 48),
  );

  String _formatNumber(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}