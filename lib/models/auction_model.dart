import '../services/config/api_config.dart';

enum AuctionStatus { kutilmoqda, yakunlangan }

class AuctionProduct {
  final String id;
  final String title;        // backend `name`
  final String description;
  final String category;     // backendda yo'q — faqat ko'rsatish uchun
  final int startingPrice;   // backend `point_cost`
  final int amount;          // backend `amount` (soni)
  final String? imageUrl;    // backend `image`
  final String auctionId;    // backend `auction` (FK)
  final bool isOffline;

  AuctionProduct({
    required this.id,
    required this.title,
    required this.description,
    this.category = '',
    required this.startingPrice,
    this.amount = 1,
    this.imageUrl,
    this.auctionId = '',
    this.isOffline = true,
  });

  factory AuctionProduct.fromJson(Map<String, dynamic> j) {
    int asInt(dynamic v) =>
        v is num ? v.toInt() : int.tryParse('${v ?? ''}') ?? 0;
    final img = (j['image'] ?? '').toString();
    return AuctionProduct(
      id: '${j['id'] ?? ''}',
      title: (j['name'] ?? '').toString(),
      description: (j['description'] ?? '').toString(),
      startingPrice: asInt(j['point_cost']),
      amount: asInt(j['amount']),
      imageUrl: img.isEmpty ? null : ApiConfig.absoluteUrl(img),
      auctionId: '${j['auction'] ?? ''}',
    );
  }

  AuctionProduct copyWith({
    String? title,
    String? description,
    String? category,
    int? startingPrice,
    int? amount,
    String? imageUrl,
    String? auctionId,
  }) {
    return AuctionProduct(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      startingPrice: startingPrice ?? this.startingPrice,
      amount: amount ?? this.amount,
      imageUrl: imageUrl ?? this.imageUrl,
      auctionId: auctionId ?? this.auctionId,
      isOffline: isOffline,
    );
  }
}

class AuctionEvent {
  final String id;
  final String title;
  final DateTime eventDate;
  final String description;
  final String location;     // backendda yo'q — faqat ko'rsatish uchun
  final List<AuctionProduct> products;
  final List<String> rules;  // backendda yo'q
  final AuctionStatus status;
  final bool isActive;       // backend `is_active`

  AuctionEvent({
    required this.id,
    required this.title,
    required this.eventDate,
    required this.description,
    this.location = '',
    required this.products,
    this.rules = const [],
    this.status = AuctionStatus.kutilmoqda,
    this.isActive = true,
  });

  factory AuctionEvent.fromJson(Map<String, dynamic> j) {
    final data = (j['data'] ?? '').toString();
    final time = (j['time'] ?? '00:00:00').toString();
    DateTime date;
    try {
      date = DateTime.parse('${data}T$time');
    } catch (_) {
      date = DateTime.now();
    }
    final active = j['is_active'] == true;
    final prods = ((j['products'] as List?) ?? const [])
        .whereType<Map>()
        .map((e) => AuctionProduct.fromJson(e.cast<String, dynamic>()))
        .toList();
    return AuctionEvent(
      id: '${j['id'] ?? ''}',
      title: (j['title'] ?? '').toString(),
      description: (j['description'] ?? '').toString(),
      eventDate: date,
      products: prods,
      isActive: active,
      status: active ? AuctionStatus.kutilmoqda : AuctionStatus.yakunlangan,
    );
  }

  AuctionEvent copyWith({
    String? title,
    DateTime? eventDate,
    String? description,
    String? location,
    List<AuctionProduct>? products,
    List<String>? rules,
    AuctionStatus? status,
    bool? isActive,
  }) {
    return AuctionEvent(
      id: id,
      title: title ?? this.title,
      eventDate: eventDate ?? this.eventDate,
      description: description ?? this.description,
      location: location ?? this.location,
      products: products ?? this.products,
      rules: rules ?? this.rules,
      status: status ?? this.status,
      isActive: isActive ?? this.isActive,
    );
  }

  String get statusLabel => isActive ? 'Faol' : 'Faol emas';
}

// ─── Mock Data ────────────────────────────────────────────────────────────────

final List<AuctionEvent> mockAuctionEvents = [
  AuctionEvent(
    id: 'a1',
    title: 'Fevral 2026 Mega Auksioni',
    eventDate: DateTime(2026, 2, 28, 15, 0),
    description:
    "Fevral oyining eng yirik auксioni. Ajoyib sovg'alar va dasturlash uchun zarur mahsulotlar!",
    location: "CODIAL Ta'lim Markazi, Toshkent",
    status: AuctionStatus.kutilmoqda,
    rules: [
      "Auксion har oyning oxirida o'tkaziladi",
      "Faqat yig'ilgan coinlaringiz bilan ishtirok etishingiz mumkin",
      "Auксion jarayoni ochiq va adolatli tarzda o'tkaziladi",
      "Yutuqchi mahsulotni auксion oxirida oladi",
      "Sarflangan coinlar qaytarilmaydi",
    ],
    products: [
      AuctionProduct(id: 'p1',  title: 'MacBook Air M2',               description: 'Dasturlash uchun mukammal noutbuk, 13 dyuymli ekran, 8GB RAM',      category: 'Texnologiya', startingPrice: 50000),
      AuctionProduct(id: 'p2',  title: 'iPad Pro 12.9"',               description: 'Zamonaviy planshet, dizayn va dasturlash uchun ideal',               category: 'Texnologiya', startingPrice: 35000),
      AuctionProduct(id: 'p3',  title: 'iPhone 15 Pro',                description: "Eng so'nggi iPhone modeli, 256GB xotira",                            category: 'Texnologiya', startingPrice: 45000),
      AuctionProduct(id: 'p4',  title: 'AirPods Pro 2',                description: 'Podcast va musiqa tinglash uchun, shovqinni bekor qilish funksiyasi bilan', category: 'Audio', startingPrice: 8000),
      AuctionProduct(id: 'p5',  title: 'Mexanik Klaviatura RGB',       description: 'RGB yoritgichli, mexanik tugmalar, dasturchilar uchun',               category: 'Aksesuar',   startingPrice: 3500),
      AuctionProduct(id: 'p6',  title: 'Gaming Mouse Logitech',        description: 'Yuqori aniqlikdagi gaming sichqoncha',                                category: 'Aksesuar',   startingPrice: 2000),
      AuctionProduct(id: 'p7',  title: 'Samsung Galaxy Watch 6',       description: 'Aqlli soat, sport va salomatlik uchun',                               category: 'Texnologiya', startingPrice: 12000),
      AuctionProduct(id: 'p8',  title: "Dasturlash Kitoblari To'plami",description: "10 ta eng mashhur dasturlash kitoblari, o'zbek va ingliz tillarida",   category: 'Ta\'lim',    startingPrice: 1500),
      AuctionProduct(id: 'p9',  title: 'Sony Headphones WH-1000XM5',  description: 'Premium quloqchin, shovqinni bekor qilish',                            category: 'Audio',      startingPrice: 10000),
      AuctionProduct(id: 'p10', title: 'iPad Mini',                    description: "Kompakt planshet, kitob o'qish va qayd olish uchun",                  category: 'Texnologiya', startingPrice: 18000),
      AuctionProduct(id: 'p11', title: 'Webcam Logitech 4K',           description: '4K sifatli veb-kamera, online darslar uchun',                         category: 'Aksesuar',   startingPrice: 4500),
      AuctionProduct(id: 'p12', title: 'Powerbank 20000mAh',           description: 'Kuchli quvvat banki, telefon va planshetlar uchun',                    category: 'Aksesuar',   startingPrice: 800),
    ],
  ),

  AuctionEvent(
    id: 'a2',
    title: 'Yanvar 2026 Auksioni',
    eventDate: DateTime(2026, 1, 31, 14, 0),
    description:
    "Yanvar oyining eng zo'r sovg'alari. O'quvchilar o'z coinlarini sarflab ajoyib mukofotlarga ega bo'lishdi.",
    location: "CODIAL Ta'lim Markazi, Toshkent",
    status: AuctionStatus.yakunlangan,
    rules: [],
    products: [
      AuctionProduct(id: 'p13', title: 'Gaming Monitor 27"',   description: '144Hz, Full HD gaming monitor',      category: 'Texnologiya', startingPrice: 15000),
      AuctionProduct(id: 'p14', title: 'Bluetooth Speaker JBL', description: 'Portativ kuchli ovozli karnay',      category: 'Audio',       startingPrice: 3000),
      AuctionProduct(id: 'p15', title: 'USB Hub 7 Port',        description: 'Noutbuk uchun 7 portli USB hub',     category: 'Aksesuar',    startingPrice: 600),
    ],
  ),

  AuctionEvent(
    id: 'a3',
    title: 'Dekabr 2025 Yangi Yil Auksioni',
    eventDate: DateTime(2025, 12, 25, 16, 0),
    description:
    "Yangi Yilga bag'ishlangan maxsus auksion tadbirida ko'plab qiziqarli sovg'alar.",
    location: "CODIAL Ta'lim Markazi, Toshkent",
    status: AuctionStatus.yakunlangan,
    rules: [],
    products: [],
  ),
];