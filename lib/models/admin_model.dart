// ─── Admin Stats Model ────────────────────────────────────────────────────────

import 'student_model.dart';

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

// ─── Admin Dashboard (API agregatsiyasi) ────────────────────────────────────────

class AdminDashboardModel {
  final AdminStats stats;
  final List<BarChartItem> groupBarData;
  final List<int> weekTrendData;
  final List<String> weekTrendLabels;
  final List<int> attendanceData;
  final List<String> attendanceLabels;
  final int ortachaDavomat;
  final int bugunQatnashdi;
  final List<StudentModel> topStudents;
  final List<GroupModel> topGroups;

  const AdminDashboardModel({
    required this.stats,
    required this.groupBarData,
    required this.weekTrendData,
    required this.weekTrendLabels,
    required this.attendanceData,
    required this.attendanceLabels,
    required this.ortachaDavomat,
    required this.bugunQatnashdi,
    required this.topStudents,
    required this.topGroups,
  });

  static AdminDashboardModel mock() => AdminDashboardModel(
        stats: AdminStats.mock,
        groupBarData: mockGroupBarData,
        weekTrendData: mockWeekTrendData,
        weekTrendLabels: mockWeekTrendLabels,
        attendanceData: mockAttendanceData,
        attendanceLabels: mockAttendanceLabels,
        ortachaDavomat: 89,
        bugunQatnashdi: 47,
        topStudents: studentsHaftalik.take(5).toList(),
        topGroups: groupsHaftalik,
      );
}

// ─── Bar Chart Data (mock) ────────────────────────────────────────────────────

class BarChartItem {
  final String label;
  final int value;
  const BarChartItem(this.label, this.value);
}

const mockGroupBarData = [
  BarChartItem('Backend 36',  16330),
  BarChartItem('Frontend 28', 14740),
  BarChartItem('Kibxav 05',   12670),
  BarChartItem('Flutter 12',  12290),
  BarChartItem('Backend 42',  11060),
  BarChartItem('Flutter 15',   9150),
  BarChartItem('Kibxav 08',    8700),
  BarChartItem('Frontend 31',  8280),
];

// ─── Line Chart Data (mock) ───────────────────────────────────────────────────

const mockWeekTrendData   = [1230, 1420, 1350, 1310, 1580, 1350, 1510];
const mockWeekTrendLabels = ['Dush','Sesh','Chor','Pay','Juma','Shan','Yak'];

const mockAttendanceData   = [38,42,35,44,40,47,36,43,38,48,39,41,44,46];
const mockAttendanceLabels = ['28Y','30Y','1F','3F','5F','7F','10F','12F','14F','16F','18F','20F','22F','24F'];