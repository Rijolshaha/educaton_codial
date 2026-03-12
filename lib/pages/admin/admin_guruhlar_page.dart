import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../models/guruh_model.dart';
import '../../../models/student_model.dart';
import '../../../widgets/admin/guruhlar/guruh_stat_chip.dart';
import '../../../widgets/admin/guruhlar/guruh_card.dart';
import '../../../widgets/admin/guruhlar/guruh_students_dialog.dart';
import '../../../widgets/admin/guruhlar/guruh_form_dialog.dart';
import '../../../widgets/admin/guruhlar/guruh_confirm_dialog.dart';
import '../../../widgets/admin/guruhlar/guruh_inline_dropdown.dart';

class AdminGuruhlarPage extends StatefulWidget {
  const AdminGuruhlarPage({super.key});

  @override
  State<AdminGuruhlarPage> createState() => _AdminGuruhlarPageState();
}

class _AdminGuruhlarPageState extends State<AdminGuruhlarPage> {
  late List<AdminGuruh> _guruhlar;
  final _searchCtrl = TextEditingController();

  String? _filterUstoz;
  String? _filterKurs;
  JadvalTuri? _filterJadval;
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _guruhlar = List.from(mockGuruhlar);
    _searchCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // ── Computed ───────────────────────────────────────────────────────────────
  List<AdminGuruh> get _filtered => _guruhlar.where((g) {
    final q = _searchCtrl.text.toLowerCase();
    if (q.isNotEmpty &&
        !g.nomi.toLowerCase().contains(q) &&
        !g.ustoz.toLowerCase().contains(q) &&
        !g.kurs.toLowerCase().contains(q)) return false;
    if (_filterUstoz != null && g.ustoz != _filterUstoz) return false;
    if (_filterKurs != null && g.kurs != _filterKurs) return false;
    if (_filterJadval != null && g.jadval != _filterJadval) return false;
    return true;
  }).toList();

  bool get _hasFilter =>
      _filterUstoz != null || _filterKurs != null || _filterJadval != null;

  void _clearFilters() => setState(() {
    _filterUstoz = null;
    _filterKurs = null;
    _filterJadval = null;
  });

  // ── Actions ────────────────────────────────────────────────────────────────
  void _showStudents(AdminGuruh guruh) {
    final students =
    studentsHaftalik.where((s) => s.group == guruh.nomi).toList();
    showDialog(
      context: context,
      builder: (_) =>
          GuruhStudentsDialog(guruh: guruh, students: students),
    );
  }

  void _addGuruh() => _openForm();
  void _editGuruh(AdminGuruh g) => _openForm(guruh: g);

  void _deleteGuruh(AdminGuruh g) => showDialog(
    context: context,
    builder: (_) => GuruhConfirmDialog(
      title: "Guruhni o'chirish",
      message: "'${g.nomi}' guruhini o'chirishni xohlaysizmi?",
      onConfirm: () =>
          setState(() => _guruhlar.removeWhere((e) => e.id == g.id)),
    ),
  );

  void _openForm({AdminGuruh? guruh}) => showDialog(
    context: context,
    builder: (_) => GuruhFormDialog(
      guruh: guruh,
      onSave: (saved) => setState(() {
        if (guruh == null) {
          _guruhlar.insert(0, saved);
        } else {
          final i = _guruhlar.indexWhere((e) => e.id == saved.id);
          if (i != -1) _guruhlar[i] = saved;
        }
      }),
    ),
  );

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final list = _filtered;

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Title ──
                    const Text(
                      'Guruhlarni boshqarish',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      "Barcha guruhlar ro'yxati va boshqarish",
                      style: TextStyle(
                          fontSize: 13, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 14),

                    // ── Stats chips ──
                    Row(children: [
                      GuruhStatChip(
                          label: 'Jami',
                          count: _guruhlar.length,
                          color: AppColors.primary),
                      const SizedBox(width: 8),
                      GuruhStatChip(
                          label: 'Faol',
                          count: _guruhlar
                              .where((g) => g.status == GuruhStatus.faol)
                              .length,
                          color: const Color(0xFF059669)),
                      const SizedBox(width: 8),
                      GuruhStatChip(
                          label: 'Faol emas',
                          count: _guruhlar
                              .where(
                                  (g) => g.status == GuruhStatus.faolEmas)
                              .length,
                          color: AppColors.red),
                    ]),
                    const SizedBox(height: 14),

                    // ── Add button ──
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _addGuruh,
                        icon: const Icon(Icons.add,
                            color: Colors.white, size: 18),
                        label: const Text(
                          "Guruh qo'shish",
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
                    const SizedBox(height: 12),

                    // ── Search + filter toggle ──
                    Row(children: [
                      Expanded(
                        child: TextField(
                          controller: _searchCtrl,
                          decoration: InputDecoration(
                            hintText: 'Guruh qidirish...',
                            hintStyle: const TextStyle(
                                color: AppColors.textHint, fontSize: 13),
                            prefixIcon: const Icon(Icons.search_rounded,
                                color: AppColors.textHint, size: 20),
                            suffixIcon: _searchCtrl.text.isNotEmpty
                                ? IconButton(
                                icon: const Icon(Icons.close_rounded,
                                    size: 18,
                                    color: AppColors.textHint),
                                onPressed: _searchCtrl.clear)
                                : null,
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Color(0xFFE5E7EB))),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Color(0xFFE5E7EB))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: AppColors.primary)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => setState(
                                () => _showFilters = !_showFilters),
                        child: Container(
                          width: 46, height: 46,
                          decoration: BoxDecoration(
                            color: _hasFilter
                                ? AppColors.primary
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _hasFilter
                                  ? AppColors.primary
                                  : const Color(0xFFE5E7EB),
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(Icons.tune_rounded,
                                  size: 20,
                                  color: _hasFilter
                                      ? Colors.white
                                      : AppColors.textSecondary),
                              if (_hasFilter)
                                Positioned(
                                  top: 6, right: 6,
                                  child: Container(
                                    width: 8, height: 8,
                                    decoration: const BoxDecoration(
                                        color: Colors.orange,
                                        shape: BoxShape.circle),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ]),

                    // ── Filter panel ──
                    if (_showFilters) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: const Color(0xFFE5E7EB)),
                        ),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Filtrlar',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight:
                                        FontWeight.w700)),
                                if (_hasFilter)
                                  GestureDetector(
                                    onTap: _clearFilters,
                                    child: const Text('Tozalash',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.red,
                                            fontWeight:
                                            FontWeight.w600)),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            GuruhInlineDropdown<String>(
                              label: 'Ustoz',
                              hint: 'Barcha ustozlar',
                              value: _filterUstoz,
                              items: allUstozlar.toList(),
                              labelBuilder: (v) => v,
                              onChanged: (v) =>
                                  setState(() => _filterUstoz = v),
                            ),
                            const SizedBox(height: 8),
                            GuruhInlineDropdown<String>(
                              label: 'Kurs',
                              hint: 'Barcha kurslar',
                              value: _filterKurs,
                              items: allKurslar.toList(),
                              labelBuilder: (v) => v,
                              onChanged: (v) =>
                                  setState(() => _filterKurs = v),
                            ),
                            const SizedBox(height: 8),
                            GuruhInlineDropdown<JadvalTuri>(
                              label: 'Jadval',
                              hint: 'Barcha jadvallar',
                              value: _filterJadval,
                              items: JadvalTuri.values,
                              labelBuilder: (v) =>
                              v == JadvalTuri.jadvalA
                                  ? 'Jadval A'
                                  : 'Jadval B',
                              onChanged: (v) =>
                                  setState(() => _filterJadval = v),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 16),
                    Text(
                      "${list.length} ta guruh",
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),

            // ── Cards / Empty ──
            list.isEmpty
                ? SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Column(children: [
                  Icon(Icons.groups_2_outlined,
                      size: 52, color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  const Text('Guruh topilmadi',
                      style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14)),
                ]),
              ),
            )
                : SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (_, i) => GuruhCard(
                    guruh: list[i],
                    onShowStudents: () =>
                        _showStudents(list[i]),
                    onEdit: () => _editGuruh(list[i]),
                    onDelete: () => _deleteGuruh(list[i]),
                  ),
                  childCount: list.length,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }
}