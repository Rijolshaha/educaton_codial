// ─── Teacher Model ────────────────────────────────────────────────────────────

class TeacherModel {
  final String id;
  final String name;
  final String email;
  final String avatarEmoji;
  final List<TeacherGroup> groups;

  const TeacherModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarEmoji,
    required this.groups,
  });

  int get totalStudents =>
      groups.fold(0, (sum, g) => sum + g.students.length);

  int get totalCoins =>
      groups.fold(0, (sum, g) => sum + g.totalCoins);

  int get avgCoins =>
      totalStudents == 0 ? 0 : totalCoins ~/ totalStudents;

  // All students across all groups sorted by coins
  List<TeacherStudent> get topStudents {
    final all = groups.expand((g) => g.students).toList();
    all.sort((a, b) => b.totalCoins.compareTo(a.totalCoins));
    return all;
  }

  static TeacherModel mock() => TeacherModel(
    id: 't1',
    name: 'Otabek Tursunov',
    email: 'otabek@codial.uz',
    avatarEmoji: '👨‍🏫',
    groups: [
      TeacherGroup(
        id: 'g1',
        name: 'Backend 36',
        schedule: 'Dushanba-Chorshanba-Juma',
        students: [
          TeacherStudent(id: 's1', name: 'Hasanali Turdialiyev',  avatarEmoji: '🧔', groupName: 'Backend 36',  totalCoins: 3250),
          TeacherStudent(id: 's2', name: 'Muhammadmuso Alijonov', avatarEmoji: '👦', groupName: 'Backend 36',  totalCoins: 2950),
          TeacherStudent(id: 's3', name: 'Sardorbek Olimov',      avatarEmoji: '🧑', groupName: 'Backend 36',  totalCoins: 2890),
          TeacherStudent(id: 's4', name: 'Mavluda Qurbonova',     avatarEmoji: '👩', groupName: 'Backend 36',  totalCoins: 2820),
          TeacherStudent(id: 's5', name: 'Zulfiya Mirzayeva',     avatarEmoji: '👩‍🦰', groupName: 'Backend 36', totalCoins: 2760),
          TeacherStudent(id: 's6', name: 'Bobur Xasanov',         avatarEmoji: '🧒', groupName: 'Backend 36',  totalCoins: 2660),
        ],
      ),
      TeacherGroup(
        id: 'g2',
        name: 'Backend 42',
        schedule: 'Seshanba-Payshanba-Shanba',
        students: [
          TeacherStudent(id: 's7',  name: 'Dilnoza Ahmadova',  avatarEmoji: '👩‍🦳', groupName: 'Backend 42', totalCoins: 3100),
          TeacherStudent(id: 's8',  name: 'Sardorbek Olimov',  avatarEmoji: '🧑',  groupName: 'Backend 42', totalCoins: 2890),
          TeacherStudent(id: 's9',  name: 'Mavluda Qurbonova', avatarEmoji: '👩',  groupName: 'Backend 42', totalCoins: 2820),
          TeacherStudent(id: 's10', name: 'Jasur Toshmatov',   avatarEmoji: '👨',  groupName: 'Backend 42', totalCoins: 2250),
        ],
      ),
    ],
  );
}

// ─── Teacher Group ────────────────────────────────────────────────────────────

class TeacherGroup {
  final String id;
  final String name;
  final String schedule;
  final List<TeacherStudent> students;

  const TeacherGroup({
    required this.id,
    required this.name,
    required this.schedule,
    required this.students,
  });

  int get totalCoins =>
      students.fold(0, (sum, s) => sum + s.totalCoins);

  int get avgCoins =>
      students.isEmpty ? 0 : totalCoins ~/ students.length;

  List<TeacherStudent> get topStudents {
    final sorted = List<TeacherStudent>.from(students)
      ..sort((a, b) => b.totalCoins.compareTo(a.totalCoins));
    return sorted.take(5).toList();
  }
}

// ─── Teacher Student ──────────────────────────────────────────────────────────

class TeacherStudent {
  final String id;
  final String name;
  final String avatarEmoji;
  final String groupName;
  final int totalCoins;

  const TeacherStudent({
    required this.id,
    required this.name,
    required this.avatarEmoji,
    required this.groupName,
    required this.totalCoins,
  });
}