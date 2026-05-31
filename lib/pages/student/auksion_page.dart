import 'package:flutter/material.dart';
import '../../models/auction_model.dart';
import '../../constants/app_colors.dart';
import '../../services/auction_service.dart';
import '../../widgets/students/auction/auction_countdown_card.dart';
import '../../widgets/students/auction/auction_offline_info.dart';
import '../../widgets/students/auction/auction_product_card.dart';
import '../../widgets/students/auction/auction_rules_card.dart';

class AuctionPage extends StatefulWidget {
  const AuctionPage({super.key});

  @override
  State<AuctionPage> createState() => _AuctionPageState();
}

class _AuctionPageState extends State<AuctionPage> {
  final _service = AuctionService();
  bool _loading = true;
  AuctionEvent? _event;

  static const _defaultRules = [
    "Auksion belgilangan vaqtda o'tkaziladi",
    "Faqat yig'ilgan coinlaringiz bilan ishtirok etishingiz mumkin",
    "Auksion jarayoni ochiq va adolatli tarzda o'tkaziladi",
    "Yutuqchi mahsulotni auksion oxirida oladi",
    "Sarflangan coinlar qaytarilmaydi",
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final events = await _service.fetchAuctions();
    if (!mounted) return;
    AuctionEvent? active;
    for (final e in events) {
      if (e.isActive) {
        active = e;
        break;
      }
    }
    active ??= events.isNotEmpty ? events.first : null;
    setState(() {
      _event = active;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: AppColors.scaffold,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    final event = _event;
    if (event == null) {
      return Scaffold(
        backgroundColor: AppColors.scaffold,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Faol auksion topilmadi',
                  style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 12),
              TextButton(onPressed: _load, child: const Text('Qayta urinish')),
            ],
          ),
        ),
      );
    }

    final rules = event.rules.isNotEmpty ? event.rules : _defaultRules;

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _load,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Auksion',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text("Coinlaringizga ajoyib sovg'alar sotib oling!",
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey.shade600)),
                      ]),
                ),
              ),
              SliverToBoxAdapter(
                child: AuctionCountdownCard(event: event),
              ),
              SliverToBoxAdapter(
                child: AuctionOfflineInfo(event: event),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
                  child: Text('Auksion mahsulotlari',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              if (event.products.isEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: Text('Mahsulotlar topilmadi',
                          style: TextStyle(color: AppColors.textSecondary)),
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) => AuctionProductCard(product: event.products[i]),
                    childCount: event.products.length,
                  ),
                ),
              SliverToBoxAdapter(
                child: AuctionRulesCard(rules: rules),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        ),
      ),
    );
  }
}
