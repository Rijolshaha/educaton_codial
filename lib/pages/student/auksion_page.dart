import 'package:flutter/material.dart';
import '../../models/auction_model.dart';
import '../../constants/app_colors.dart';
import '../../widgets/students/auction/auction_countdown_card.dart';
import '../../widgets/students/auction/auction_offline_info.dart';
import '../../widgets/students/auction/auction_product_card.dart';
import '../../widgets/students/auction/auction_rules_card.dart';

class AuctionPage extends StatelessWidget {
  const AuctionPage({super.key});

  static final AuctionEvent _event = AuctionEvent(
    id: 'a1',                              // ← FIX
    title: 'Fevral 2026 Mega Auксioni',
    eventDate: DateTime(2026, 2, 28, 15, 0),
    description: "Fevral oyining eng yirik auксioni. Ajoyib sovg'alar va dasturlash uchun zarur mahsulotlar!",
    location: "CODIAL Ta'lim Markazi, Toshkent",
    status: AuctionStatus.kutilmoqda,      // ← FIX
    rules: [
      "Auксion har oyning oxirida o'tkaziladi",
      "Faqat yig'ilgan coinlaringiz bilan ishtirok etishingiz mumkin",
      "Auксion jarayoni ochiq va adolatli tarzda o'tkaziladi",
      "Yutuqchi mahsulotni auксion oxirida oladi",
      "Sarflangan coinlar qaytarilmaydi",
    ],
    products: [
      AuctionProduct(
        id: '1',
        title: 'MacBook Air M2',
        description: 'Dasturlash uchun mukammal noutbuk, 13 dyuymli ekran, 8GB RAM',
        category: 'Texnologiya',
        startingPrice: 50000,
        imageUrl: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=600',
      ),
      AuctionProduct(
        id: '2',
        title: 'iPad Pro 12.9"',
        description: 'Zamonaviy planshet, dizayn va dasturlash uchun ideal',
        category: 'Texnologiya',
        startingPrice: 35000,
        imageUrl: 'https://images.unsplash.com/photo-1544244015-0df4512a2b1e?w=600',
      ),
      AuctionProduct(
        id: '3',
        title: 'iPhone 15 Pro',
        description: "Eng so'nggi iPhone modeli, 256GB xotira",
        category: 'Texnologiya',
        startingPrice: 45000,
        imageUrl: 'https://images.unsplash.com/photo-1696446701796-da61b3b4d03e?w=600',
      ),
      AuctionProduct(
        id: '4',
        title: 'AirPods Pro 2',
        description: 'Podcast va musiqa tinglash uchun, shovqinni bekor qilish funksiyasi bilan',
        category: 'Audio',
        startingPrice: 8000,
        imageUrl: 'https://images.unsplash.com/photo-1606741965429-02919b2a4f6e?w=600',
      ),
      AuctionProduct(
        id: '5',
        title: 'Powerbank 20000mAh',
        description: 'Kuchli quvvat banki, telefon va planshetlar uchun',
        category: 'Aksesuar',
        startingPrice: 800,
        imageUrl: 'https://images.unsplash.com/photo-1609091839311-d5365f9ff1c5?w=600',
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Auксion',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text("Coinlaringizga ajoyib sovg'alar sotuvoling!",
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                ]),
              ),
            ),

            // ── Countdown card ──
            SliverToBoxAdapter(
              child: AuctionCountdownCard(event: _event),
            ),

            // ── Offline info ──
            SliverToBoxAdapter(
              child: AuctionOfflineInfo(event: _event),
            ),

            // ── Products header ──
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
                child: Text('Auксion mahsulotlari',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),

            // ── Product cards ──
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (_, i) => AuctionProductCard(product: _event.products[i]),
                childCount: _event.products.length,
              ),
            ),

            // ── Rules ──
            SliverToBoxAdapter(
              child: AuctionRulesCard(rules: _event.rules),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }
}