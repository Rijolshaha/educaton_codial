// ─── Admin Stats Model ────────────────────────────────────────────────────────

class AdminStats {
  final int totalStudents;
  final int totalTeachers;
  final int activeGroups;
  final int totalCoins;
  final double studentGrowth;
  final double teacherGrowth;
  final double groupGrowth;
  final double coinGrowth;

  const AdminStats({
    required this.totalStudents,
    required this.totalTeachers,
    required this.activeGroups,
    required this.totalCoins,
    required this.studentGrowth,
    required this.teacherGrowth,
    required this.groupGrowth,
    required this.coinGrowth,
  });

  static const mock = AdminStats(
    totalStudents: 32,
    totalTeachers: 7,
    activeGroups: 10,
    totalCoins: 93380,
    studentGrowth: 12,
    teacherGrowth: 5,
    groupGrowth: 8,
    coinGrowth: 24,
  );
}

// ─── Bar Chart Data ───────────────────────────────────────────────────────────

class BarChartItem {
  final String label;
  final int value;
  const BarChartItem(this.label, this.value);
}

const groupBarData = [
  BarChartItem('Backend 36',  16330),
  BarChartItem('Frontend 28', 14740),
  BarChartItem('Kibxav 05',   12670),
  BarChartItem('Flutter 12',  12290),
  BarChartItem('Backend 42',  11060),
  BarChartItem('Flutter 15',   9150),
  BarChartItem('Kibxav 08',    8700),
  BarChartItem('Frontend 31',  8280),
];

// ─── Line Chart Data ──────────────────────────────────────────────────────────

const weekTrendData   = [1230, 1420, 1350, 1310, 1580, 1350, 1510];
const weekTrendLabels = ['Dush','Sesh','Chor','Pay','Juma','Shan','Yak'];

const attendanceData   = [38,42,35,44,40,47,36,43,38,48,39,41,44,46];
const attendanceLabels = ['28Y','30Y','1F','3F','5F','7F','10F','12F','14F','16F','18F','20F','22F','24F'];