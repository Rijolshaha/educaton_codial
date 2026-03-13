import 'package:flutter/material.dart';
import '../../../models/dashboard_model.dart';
import '../../../constants/app_colors.dart';
import '../../../services/config/app_theme.dart';

class CoinOpportunitiesSection extends StatelessWidget {
  final List<CoinOpportunity> opportunities;
  const CoinOpportunitiesSection({super.key, required this.opportunities});

  IconData _iconForKey(String key) {
    switch (key) {
      case 'lightning':
        return Icons.bolt;
      case 'bookopen':
        return Icons.auto_stories_outlined;
      case 'target':
        return Icons.track_changes;
      default:
        return Icons.menu_book_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text('✨', style: TextStyle(fontSize: 18)),
            SizedBox(width: 6),
            Text('Coin topish imkoniyatlari', style: AppTextStyles.sectionTitle),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
          ),
          itemCount: opportunities.length,
          itemBuilder: (context, index) {
            final opp = opportunities[index];
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Color(opp.color),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    _iconForKey(opp.icon),
                    color: Color(opp.iconColor),
                    size: 22,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        opp.title,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        opp.value,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(opp.iconColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}