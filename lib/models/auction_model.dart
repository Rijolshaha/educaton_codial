class AuctionProduct {
  final String id;
  final String title;
  final String description;
  final String category;
  final int startingPrice;
  final String? imageUrl;
  final bool isOffline;

  const AuctionProduct({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.startingPrice,
    this.imageUrl,
    this.isOffline = true,
  });
}

class AuctionEvent {
  final String title;
  final DateTime eventDate;
  final String description;
  final String location;
  final List<AuctionProduct> products;
  final List<String> rules;

  const AuctionEvent({
    required this.title,
    required this.eventDate,
    required this.description,
    required this.location,
    required this.products,
    required this.rules,
  });
}