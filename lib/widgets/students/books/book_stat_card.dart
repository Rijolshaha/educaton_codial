import 'package:flutter/material.dart';

class BookStatCard extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final IconData icon;
  final bool small;

  const BookStatCard({
    super.key,
    required this.label,
    required this.count,
    required this.color,
    required this.icon,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: small ? 14 : 16,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: small ? 12 : 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$count',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: small ? 26 : 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: small ? 20 : 24),
          ),
        ],
      ),
    );
  }
}