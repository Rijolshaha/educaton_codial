// ─── BookStatus enum ─────────────────────────────────────────────────────────

enum BookStatus {
  tugatdi,
  oqilyabdi,
  rejalashtirilgan;

  String get label {
    switch (this) {
      case BookStatus.tugatdi:          return "Tugatdi";
      case BookStatus.oqilyabdi:        return "O'qilyabdi";
      case BookStatus.rejalashtirilgan: return "Rejalashtirilgan";
    }
  }
}

// ─── BookModel ───────────────────────────────────────────────────────────────

class BookModel {
  final int    id;
  final String title;
  final String author;
  final String startDate;   // "yyyy-MM-dd" formatida String
  final String? endDate;    // tugamagan bo'lsa null
  final BookStatus status;
  final String summary;

  const BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.startDate,
    this.endDate,
    required this.status,
    required this.summary,
  });
}

// ─── StudentModel ─────────────────────────────────────────────────────────────

class StudentModel {
  final int    id;
  final int    rank;
  final String name;
  final String group;
  final int    coins;
  final int    gain;
  final String email;
  final List<BookModel> books;
  final String avatarColor;   // "#RRGGBB"
  final String avatarEmoji;

  const StudentModel({
    required this.id,
    required this.rank,
    required this.name,
    required this.group,
    required this.coins,
    required this.gain,
    required this.email,
    this.books = const [],
    required this.avatarColor,
    required this.avatarEmoji,
  });
}

// ─── GroupModel ───────────────────────────────────────────────────────────────

class GroupModel {
  final int    id;
  final int    rank;
  final String name;
  final String teacher;
  final int    studentCount;
  final int    avgCoins;
  final int    totalCoins;
  final int    growth;

  const GroupModel({
    required this.id,
    required this.rank,
    required this.name,
    required this.teacher,
    required this.studentCount,
    required this.avgCoins,
    required this.totalCoins,
    required this.growth,
  });
}

// ─── Students — Haftalik ──────────────────────────────────────────────────────

const List<StudentModel> studentsHaftalik = [
  StudentModel(id: 1,  rank: 1,  name: "Abbos Qodirov",        group: "Kiberxavfsizlik 05", coins: 3450, gain: 350, email: "abbos@codial.uz",        avatarColor: "#4ECDC4", avatarEmoji: "👩",
    books: [
      BookModel(id: 1, title: "The Art of Deception", author: "Kevin Mitnick",
          startDate: "2026-01-20", endDate: "2026-02-10",
          status: BookStatus.tugatdi,
          summary: "Mashhur xaker Kevin Mitnick tomonidan yozilgan ijtimoiy injiniring va xavfsizlik haqida kitob."),
    ],
  ),
  StudentModel(id: 2,  rank: 2,  name: "Anvar Karimov",         group: "Flutter 12",          coins: 3380, gain: 345, email: "anvar@codial.uz",        avatarColor: "#FF6B6B", avatarEmoji: "👨"),
  StudentModel(id: 3,  rank: 3,  name: "Malika Yusupova",       group: "Frontend 28",         coins: 3350, gain: 340, email: "malika@codial.uz",       avatarColor: "#F0B27A", avatarEmoji: "👧"),
  StudentModel(id: 4,  rank: 4,  name: "Laylo Sharipova",       group: "Kiberxavfsizlik 05",  coins: 3280, gain: 330, email: "laylo@codial.uz",        avatarColor: "#BB8FCE", avatarEmoji: "👩"),
  StudentModel(id: 5,  rank: 5,  name: "Hasanali Turdialiyev",  group: "Backend 36",          coins: 3250, gain: 325, email: "hasanali@codial.uz",     avatarColor: "#45B7D1", avatarEmoji: "🧔"),
  StudentModel(id: 6,  rank: 6,  name: "Jahon Samadov",         group: "Flutter 15",          coins: 3210, gain: 335, email: "jahon@codial.uz",        avatarColor: "#96CEB4", avatarEmoji: "👦"),
  StudentModel(id: 7,  rank: 7,  name: "Zafar Tursunov",        group: "Kiberxavfsizlik 08",  coins: 3130, gain: 320, email: "zafar@codial.uz",        avatarColor: "#F7DC6F", avatarEmoji: "👨"),
  StudentModel(id: 8,  rank: 8,  name: "Otabek Salimov",        group: "Frontend 28",         coins: 3120, gain: 315, email: "otabek@codial.uz",       avatarColor: "#82E0AA", avatarEmoji: "🧑"),
  StudentModel(id: 9,  rank: 9,  name: "Dilnoza Ahmadova",      group: "Backend 42",          coins: 3100, gain: 310, email: "dilnoza@codial.uz",      avatarColor: "#F1948A", avatarEmoji: "👩"),
  StudentModel(id: 10, rank: 10, name: "Rustam Normatov",       group: "Kiberxavfsizlik 05",  coins: 3050, gain: 305, email: "rustam@codial.uz",       avatarColor: "#AED6F1", avatarEmoji: "👨"),
  StudentModel(id: 11, rank: 11, name: "Munisa Abdullayeva",    group: "Flutter 15",          coins: 3040, gain: 310, email: "munisa@codial.uz",       avatarColor: "#DDA0DD", avatarEmoji: "👧"),
  StudentModel(id: 12, rank: 12, name: "Shohruh Ismoilov",      group: "Frontend 31",         coins: 2980, gain: 295, email: "shohruh@codial.uz",      avatarColor: "#98D8C8", avatarEmoji: "🧑"),
  StudentModel(id: 13, rank: 13, name: "Madina Mahmudova",      group: "Kiberxavfsizlik 08",  coins: 2970, gain: 300, email: "madina@codial.uz",       avatarColor: "#FFEAA7", avatarEmoji: "👩"),
  StudentModel(id: 14, rank: 14, name: "Muhammadmuso Alijonov", group: "Backend 36",          coins: 2950, gain: 275, email: "muhammadmuso@codial.uz", avatarColor: "#85C1E9", avatarEmoji: "👦"),
  StudentModel(id: 15, rank: 15, name: "Bekzod Ismatov",        group: "Flutter 12",          coins: 2950, gain: 295, email: "bekzod@codial.uz",       avatarColor: "#A9DFBF", avatarEmoji: "🧔"),
  StudentModel(id: 16, rank: 16, name: "Feruza Normatova",      group: "Frontend 28",         coins: 2940, gain: 290, email: "feruza@codial.uz",       avatarColor: "#BB8FCE", avatarEmoji: "👩"),
  StudentModel(id: 17, rank: 17, name: "Sardorbek Olimov",      group: "Backend 42",          coins: 2890, gain: 270, email: "sardorbek@codial.uz",    avatarColor: "#FF6B6B", avatarEmoji: "👨"),
  StudentModel(id: 18, rank: 18, name: "Kamola Usmonova",       group: "Kiberxavfsizlik 05",  coins: 2850, gain: 280, email: "kamola@codial.uz",       avatarColor: "#4ECDC4", avatarEmoji: "👧"),
  StudentModel(id: 19, rank: 19, name: "Bobur Ergashev",        group: "Frontend 31",         coins: 2820, gain: 265, email: "bobur@codial.uz",        avatarColor: "#F0B27A", avatarEmoji: "👦"),
  StudentModel(id: 20, rank: 20, name: "Shahnoza Qurbonova",    group: "Backend 36",          coins: 2820, gain: 300, email: "shahnoza@codial.uz",     avatarColor: "#82E0AA", avatarEmoji: "👩"),
  StudentModel(id: 21, rank: 21, name: "Dildora Ergasheva",     group: "Flutter 12",          coins: 2780, gain: 280, email: "dildora@codial.uz",      avatarColor: "#45B7D1", avatarEmoji: "👩"),
  StudentModel(id: 22, rank: 22, name: "Nilufar Abdullayeva",   group: "Frontend 31",         coins: 2760, gain: 270, email: "nilufar@codial.uz",      avatarColor: "#96CEB4", avatarEmoji: "👧"),
  StudentModel(id: 23, rank: 23, name: "Akmal Toshmatov",       group: "Frontend 28",         coins: 2750, gain: 265, email: "akmal@codial.uz",        avatarColor: "#F7DC6F", avatarEmoji: "🧑"),
  StudentModel(id: 24, rank: 24, name: "Sanjar Rahmonov",       group: "Kiberxavfsizlik 08",  coins: 2740, gain: 275, email: "sanjar@codial.uz",       avatarColor: "#AED6F1", avatarEmoji: "👨"),
  StudentModel(id: 25, rank: 25, name: "Aziza Karimova",        group: "Backend 36",          coins: 2680, gain: 240, email: "aziza@codial.uz",        avatarColor: "#DDA0DD", avatarEmoji: "👩"),
  StudentModel(id: 26, rank: 26, name: "Zarina Nabiyeva",       group: "Backend 42",          coins: 2650, gain: 250, email: "zarina@codial.uz",       avatarColor: "#F1948A", avatarEmoji: "👧"),
  StudentModel(id: 27, rank: 27, name: "Gulnora Safarova",      group: "Frontend 28",         coins: 2580, gain: 245, email: "gulnora@codial.uz",      avatarColor: "#98D8C8", avatarEmoji: "👩"),
  StudentModel(id: 28, rank: 28, name: "Davron Ergashev",       group: "Frontend 31",         coins: 2540, gain: 255, email: "davron@codial.uz",       avatarColor: "#85C1E9", avatarEmoji: "👨"),
  StudentModel(id: 29, rank: 29, name: "Javohir Toshmatov",     group: "Backend 36",          coins: 2450, gain: 220, email: "javohir@codial.uz",      avatarColor: "#A9DFBF", avatarEmoji: "🧑"),
  StudentModel(id: 30, rank: 30, name: "Farhod Yusupov",        group: "Backend 42",          coins: 2420, gain: 230, email: "farhod@codial.uz",       avatarColor: "#FF6B6B", avatarEmoji: "👦"),
  StudentModel(id: 31, rank: 31, name: "Bobur Rahimov",         group: "Backend 36",          coins: 2180, gain: 210, email: "boburr@codial.uz",       avatarColor: "#4ECDC4", avatarEmoji: "🧔"),
];

// ─── Helper: rerank ───────────────────────────────────────────────────────────

List<StudentModel> _rerank(List<StudentModel> list) {
  final sorted = [...list]..sort((a, b) => b.coins.compareTo(a.coins));
  return List.generate(
    sorted.length,
        (i) => StudentModel(
      id: sorted[i].id,
      rank: i + 1,
      name: sorted[i].name,
      group: sorted[i].group,
      coins: sorted[i].coins,
      gain: sorted[i].gain,
      email: sorted[i].email,
      books: sorted[i].books,
      avatarColor: sorted[i].avatarColor,
      avatarEmoji: sorted[i].avatarEmoji,
    ),
  );
}

// ─── Students — Oylik & Umumiy ────────────────────────────────────────────────

final List<StudentModel> studentsOylik = _rerank(
  studentsHaftalik.map((s) => StudentModel(
    id: s.id, rank: s.rank, name: s.name, group: s.group,
    coins: s.coins + 150 + (s.id * 7 % 100), gain: s.gain + 20,
    email: s.email, books: s.books,
    avatarColor: s.avatarColor, avatarEmoji: s.avatarEmoji,
  )).toList(),
);

final List<StudentModel> studentsUmumiy = _rerank(
  studentsHaftalik.map((s) => StudentModel(
    id: s.id, rank: s.rank, name: s.name, group: s.group,
    coins: s.coins + 400 + (s.id * 13 % 200), gain: s.gain + 50,
    email: s.email, books: s.books,
    avatarColor: s.avatarColor, avatarEmoji: s.avatarEmoji,
  )).toList(),
);

List<StudentModel> getStudents(String period) {
  switch (period) {
    case 'oylik':  return studentsOylik;
    case 'umumiy': return studentsUmumiy;
    default:       return studentsHaftalik;
  }
}

// ─── Groups — Haftalik ────────────────────────────────────────────────────────

const List<GroupModel> groupsHaftalik = [
  GroupModel(id: 1, rank: 1, name: "Backend 36",        teacher: "Otabek Tursunov",         studentCount: 6, avgCoins: 2722, totalCoins: 16330, growth: 12),
  GroupModel(id: 2, rank: 2, name: "Frontend 28",        teacher: "Asadbek Mahmudov",         studentCount: 5, avgCoins: 2948, totalCoins: 14740, growth: 12),
  GroupModel(id: 3, rank: 3, name: "Kiberxavfsizlik 05", teacher: "Shukurulloh Zaylobidinov", studentCount: 4, avgCoins: 3168, totalCoins: 12670, growth: 12),
  GroupModel(id: 4, rank: 4, name: "Flutter 12",         teacher: "Shaxzodbek Baxtiyorov",    studentCount: 4, avgCoins: 3073, totalCoins: 12290, growth: 12),
  GroupModel(id: 5, rank: 5, name: "Backend 42",         teacher: "Otabek Tursunov",         studentCount: 4, avgCoins: 2765, totalCoins: 11060, growth: 12),
  GroupModel(id: 6, rank: 6, name: "Flutter 15",         teacher: "Shaxzodbek Baxtiyorov",    studentCount: 3, avgCoins: 3050, totalCoins:  9150, growth: 12),
  GroupModel(id: 7, rank: 7, name: "Kiberxavfsizlik 08", teacher: "Shukur Zaylobidinov",      studentCount: 3, avgCoins: 2900, totalCoins:  8700, growth: 10),
  GroupModel(id: 8, rank: 8, name: "Frontend 31",        teacher: "Asadbek Mahmudov",         studentCount: 3, avgCoins: 2760, totalCoins:  8280, growth:  9),
];

// ─── Helper: rerank groups ────────────────────────────────────────────────────

List<GroupModel> _rerankGroups(List<GroupModel> list) {
  final sorted = [...list]..sort((a, b) => b.totalCoins.compareTo(a.totalCoins));
  return List.generate(
    sorted.length,
        (i) => GroupModel(
      id: sorted[i].id, rank: i + 1, name: sorted[i].name,
      teacher: sorted[i].teacher, studentCount: sorted[i].studentCount,
      avgCoins: sorted[i].avgCoins, totalCoins: sorted[i].totalCoins,
      growth: sorted[i].growth,
    ),
  );
}

// ─── Groups — Oylik & Umumiy ──────────────────────────────────────────────────

final List<GroupModel> groupsOylik = _rerankGroups(
  groupsHaftalik.map((g) => GroupModel(
    id: g.id, rank: g.rank, name: g.name, teacher: g.teacher,
    studentCount: g.studentCount, avgCoins: g.avgCoins + 120,
    totalCoins: g.totalCoins + 1000 + (g.id * 50), growth: g.growth + 2,
  )).toList(),
);

final List<GroupModel> groupsUmumiy = _rerankGroups(
  groupsHaftalik.map((g) => GroupModel(
    id: g.id, rank: g.rank, name: g.name, teacher: g.teacher,
    studentCount: g.studentCount, avgCoins: g.avgCoins + 400,
    totalCoins: g.totalCoins + 4000 + (g.id * 200), growth: g.growth + 6,
  )).toList(),
);

List<GroupModel> getGroups(String period) {
  switch (period) {
    case 'oylik':  return groupsOylik;
    case 'umumiy': return groupsUmumiy;
    default:       return groupsHaftalik;
  }
}