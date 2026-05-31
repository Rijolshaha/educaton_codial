import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../models/kurs_model.dart';
import '../../../services/course_service.dart';
import '../../../widgets/admin/kurslar/kurs_stat_card.dart';
import '../../../widgets/admin/kurslar/kurs_card.dart';
import '../../../widgets/admin/kurslar/kurs_detail_dialog.dart';
import '../../../widgets/admin/kurslar/kurs_form_dialog.dart';
import '../../../widgets/admin/kurslar/kurs_confirm_dialog.dart';

class AdminKurslarPage extends StatefulWidget {
  const AdminKurslarPage({super.key});

  @override
  State<AdminKurslarPage> createState() => _AdminKurslarPageState();
}

class _AdminKurslarPageState extends State<AdminKurslarPage> {
  final CourseService _service = CourseService();
  List<KursModel> _kurslar = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (mounted) setState(() => _loading = true);
    final list = await _service.fetchCourses();
    if (!mounted) return;
    setState(() {
      _kurslar = list;
      _loading = false;
    });
  }

  void _snack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: error ? AppColors.red : AppColors.greenDark,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    ));
  }

  // ── Computed stats ─────────────────────────────────────────────────────────
  int get _jamiKurslar      => _kurslar.length;
  int get _faolKurslar      => _kurslar.where((k) => k.status == KursStatus.faol).length;
  int get _jamiOqituvchilar => _kurslar.fold(0, (s, k) => s + k.oqituvchilar);
  int get _jamiOquvchilar   => _kurslar.fold(0, (s, k) => s + k.oquvchilar);

  // ── Actions ────────────────────────────────────────────────────────────────
  void _addKurs() => _openForm();

  void _viewKurs(KursModel k) {
    showDialog(
      context: context,
      builder: (_) => KursDetailDialog(
        kurs: k,
        onEdit: () {
          Navigator.pop(context);
          _openForm(kurs: k);
        },
        onDelete: () {
          Navigator.pop(context);
          _confirmDelete(k);
        },
      ),
    );
  }

  void _confirmDelete(KursModel k) {
    showDialog(
      context: context,
      builder: (_) => KursConfirmDialog(
        title: "Kursni o'chirish",
        message: "'${k.nomi}' kursini o'chirishni xohlaysizmi?",
        onConfirm: () => _deleteKurs(k),
      ),
    );
  }

  Future<void> _deleteKurs(KursModel k) async {
    final ok = await _service.deleteCourse(k.id);
    if (!mounted) return;
    if (!ok) {
      _snack("O'chirib bo'lmadi", error: true);
      return;
    }
    _snack("Kurs o'chirildi");
    await _load();
  }

  void _openForm({KursModel? kurs}) {
    showDialog(
      context: context,
      builder: (_) => KursFormDialog(
        kurs: kurs,
        onSave: (saved) async {
          final ok = kurs == null
              ? await _service.createCourse(saved)
              : await _service.updateCourse(saved);
          if (ok && mounted) {
            _snack(kurs == null
                ? "Kurs qo'shildi ✅"
                : "O'zgarishlar saqlandi ✅");
            await _load();
          }
          return ok;
        },
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: _loading
          ? Center(child: CircularProgressIndicator(color: AppColors.primary))
          : SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: _load,
          child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // ── Header ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Row(children: [
                      const Icon(Icons.menu_book_rounded,
                          color: AppColors.primary, size: 26),
                      const SizedBox(width: 10),
                      const Text(
                        'Kurslar Boshqaruvi',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary),
                      ),
                    ]),
                    const SizedBox(height: 4),
                    const Text(
                      "Barcha kurslar va yo'nalishlar",
                      style: TextStyle(
                          fontSize: 13, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),

                    // ── Stats 2×2 ──
                    Row(children: [
                      Expanded(
                        child: KursStatCard(
                          count: _jamiKurslar,
                          label: 'Jami Kurslar',
                          icon: Icons.menu_book_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: KursStatCard(
                          count: _faolKurslar,
                          label: 'Faol Kurslar',
                          icon: Icons.check_circle_outline,
                          color: AppColors.greenDark,
                        ),
                      ),
                    ]),
                    const SizedBox(height: 12),
                    Row(children: [
                      Expanded(
                        child: KursStatCard(
                          count: _jamiOqituvchilar,
                          label: "O'qituvchilar",
                          icon: Icons.group_outlined,
                          color: AppColors.purple,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: KursStatCard(
                          count: _jamiOquvchilar,
                          label: "O'quvchilar",
                          icon: Icons.school_outlined,
                          color: AppColors.orange,
                        ),
                      ),
                    ]),
                    const SizedBox(height: 16),

                    // ── Add button ──
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _addKurs,
                        icon: const Icon(Icons.add,
                            color: Colors.white, size: 18),
                        label: const Text(
                          "Kurs qo'shish",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding:
                          const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // ── Kurs cards list ──
            if (_kurslar.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Column(children: [
                    Icon(Icons.menu_book_outlined,
                        size: 52, color: Colors.grey.shade300),
                    const SizedBox(height: 12),
                    const Text('Kurslar topilmadi',
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 14)),
                  ]),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (_, i) => KursCard(
                      kurs: _kurslar[i],
                      onView: () => _viewKurs(_kurslar[i]),
                    ),
                    childCount: _kurslar.length,
                  ),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
        ),
      ),
    );
  }
}