import '../services/config/api_config.dart';

// ─── BookStatus enum ─────────────────────────────────────────────────────────
// Barcha rollar (o'quvchi kitoblari + ommaviy profil) uchun yagona holatlar.

enum BookStatus {
  oqiyapman,
  tugatdim,
  rejalashtirilgan;

  String get label {
    switch (this) {
      case BookStatus.oqiyapman:        return "O'qiyapman";
      case BookStatus.tugatdim:         return 'Tugatdim';
      case BookStatus.rejalashtirilgan: return 'Rejalashtirilgan';
    }
  }
}

// ─── BookModel ───────────────────────────────────────────────────────────────
// Yagona model: kitoblarni boshqarish (book_page) va ommaviy profil shu modeldan
// foydalanadi.

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

  String get statusLabel => status.label;

  /// "dd.MM.yyyy" — UI da ko'rsatish uchun
  String get startDateLabel => _fmtDate(startDate);

  /// Tugamagan bo'lsa null
  String? get endDateLabel => endDate == null ? null : _fmtDate(endDate!);

  static String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.'
      '${d.month.toString().padLeft(2, '0')}.'
      '${d.year}';

  /// Backend `Book` — `{id, title, author, description, start_date, end_date,
  /// book_photo, status, student}`.
  factory BookModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? s) {
      if (s == null || s.isEmpty) return null;
      return DateTime.tryParse(s);
    }

    final photo = (json['book_photo'] ?? '').toString();
    final start = parseDate((json['start_date'] ?? '').toString());
    return BookModel(
      id: '${json['id'] ?? ''}',
      title: (json['title'] ?? '').toString(),
      author: (json['author'] ?? '').toString(),
      startDate: start ?? DateTime.now(),
      endDate: parseDate((json['end_date'] ?? '').toString()),
      status: statusFromApi((json['status'] ?? '').toString()),
      coverUrl: photo.isEmpty ? null : ApiConfig.absoluteUrl(photo),
      summary: (json['description'] ?? '').toString(),
    );
  }

  /// API status → enum.
  static BookStatus statusFromApi(String raw) {
    final s = raw.toLowerCase();
    if (s.contains('tugat')) return BookStatus.tugatdim;
    if (s.contains('reja')) return BookStatus.rejalashtirilgan;
    return BookStatus.oqiyapman;
  }

  /// Enum → API status string.
  String get statusApi {
    switch (status) {
      case BookStatus.tugatdim:
        return 'Tugatim';
      case BookStatus.rejalashtirilgan:
        return 'Rejalashtirilgan';
      case BookStatus.oqiyapman:
        return "O'qiyapman";
    }
  }

  static String _isoDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  /// POST/PATCH form-data maydonlari.
  Map<String, String> toFormFields({required String studentId}) {
    return {
      'title': title,
      'author': author,
      'description': summary,
      'start_date': _isoDate(startDate),
      if (endDate != null) 'end_date': _isoDate(endDate!),
      'status': statusApi,
      'student': studentId,
    };
  }
}
