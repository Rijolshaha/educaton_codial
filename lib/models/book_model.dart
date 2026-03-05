enum BookStatus { oqiyapman, tugatdim }

class BookModel {
  final String id;
  final String title;
  final String author;
  final DateTime startDate;
  final DateTime? endDate;
  final BookStatus status;
  final String? coverUrl;
  final String summary;

  const BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.startDate,
    this.endDate,
    required this.status,
    this.coverUrl,
    this.summary = '',
  });

  BookModel copyWith({
    String? title,
    String? author,
    DateTime? startDate,
    DateTime? endDate,
    BookStatus? status,
    String? coverUrl,
    String? summary,
  }) {
    return BookModel(
      id: id,
      title: title ?? this.title,
      author: author ?? this.author,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      coverUrl: coverUrl ?? this.coverUrl,
      summary: summary ?? this.summary,
    );
  }

  String get statusLabel =>
      status == BookStatus.oqiyapman ? "O'qiyapman" : 'Tugatdim';
}