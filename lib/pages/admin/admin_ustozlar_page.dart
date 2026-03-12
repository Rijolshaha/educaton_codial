import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../models/ustoz_model.dart';
import '../../../widgets/admin/ustozlar/ustoz_stat_card.dart';
import '../../../widgets/admin/ustozlar/ustoz_card.dart';
import '../../../widgets/admin/ustozlar/ustoz_form_dialog.dart';
import '../../../widgets/admin/ustozlar/ustoz_confirm_dialog.dart';

class AdminUstozlarPage extends StatefulWidget {
  const AdminUstozlarPage({super.key});

  @override
  State<AdminUstozlarPage> createState() => _AdminUstozlarPageState();
}

class _AdminUstozlarPageState extends State<AdminUstozlarPage> {
  late List<UstozModel> _ustozlar;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ustozlar = List.from(mockUstozlar);
    _searchCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // ── Computed ───────────────────────────────────────────────────────────────
  List<UstozModel> get _filtered {
    final q = _searchCtrl.text.toLowerCase();
    if (q.isEmpty) return _ustozlar;
    return _ustozlar.where((u) =>
    u.ism.toLowerCase().contains(q) ||
        u.email.toLowerCase().contains(q) ||
        u.kurs.toLowerCase().contains(q)).toList();
  }

  int get _faolCount =>
      _ustozlar.where((u) => u.status == UstozStatus.faol).length;

  double get _ortachaGuruhlar {
    if (_ustozlar.isEmpty) return 0;
    final total = _ustozlar.fold(0, (s, u) => s + u.guruhlarSoni);
    return total / _ustozlar.length;
  }

  // ── Actions ────────────────────────────────────────────────────────────────
  void _addUstoz() => _openForm();
  void _editUstoz(UstozModel u) => _openForm(ustoz: u);

  void _deleteUstoz(UstozModel u) => showDialog(
    context: context,
    builder: (_) => UstozConfirmDialog(
      title: "Ustozni o'chirish",
      message: "'${u.ism}' ustozni o'chirishni xohlaysizmi?",
      onConfirm: () =>
          setState(() => _ustozlar.removeWhere((e) => e.id == u.id)),
    ),
  );

  void _openForm({UstozModel? ustoz}) => showDialog(
    context: context,
    builder: (_) => UstozFormDialog(
      ustoz: ustoz,
      onSave: (saved) => setState(() {
        if (ustoz == null) {
          _ustozlar.insert(0, saved);
        } else {
          final i = _ustozlar.indexWhere((e) => e.id == saved.id);
          if (i != -1) _ustozlar[i] = saved;
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
                      'Ustozlarni boshqarish',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      "Barcha ustozlar ro'yxati va boshqarish",
                      style: TextStyle(
                          fontSize: 13, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),

                    // ── Add button ──
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _addUstoz,
                        icon: const Icon(Icons.add,
                            color: Colors.white, size: 18),
                        label: const Text(
                          "Ustoz qo'shish",
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

                    // ── Search ──
                    TextField(
                      controller: _searchCtrl,
                      decoration: InputDecoration(
                        hintText: 'Ustoz qidirish (ism, email, kurs)...',
                        hintStyle: const TextStyle(
                            color: AppColors.textHint, fontSize: 13),
                        prefixIcon: const Icon(Icons.search_rounded,
                            color: AppColors.textHint, size: 20),
                        suffixIcon: _searchCtrl.text.isNotEmpty
                            ? IconButton(
                            icon: const Icon(Icons.close_rounded,
                                size: 18, color: AppColors.textHint),
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
                    const SizedBox(height: 16),

                    // ── Result count ──
                    Text(
                      "${list.length} ta ustoz",
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

            // ── Ustoz cards ──
            list.isEmpty
                ? SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Column(children: [
                  Icon(Icons.person_off_outlined,
                      size: 52, color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  const Text('Ustoz topilmadi',
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
                      (_, i) => UstozCard(
                    ustoz: list[i],
                    onEdit: () => _editUstoz(list[i]),
                    onDelete: () => _deleteUstoz(list[i]),
                  ),
                  childCount: list.length,
                ),
              ),
            ),

            // ── Bottom stats ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: Column(
                  children: [
                    UstozStatCard(
                      label: 'Jami ustozlar',
                      value: '${_ustozlar.length}',
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 10),
                    UstozStatCard(
                      label: 'Faol ustozlar',
                      value: '$_faolCount',
                      color: AppColors.greenDark,
                    ),
                    const SizedBox(height: 10),
                    UstozStatCard(
                      label: "O'rtacha guruhlar",
                      value: _ortachaGuruhlar
                          .toStringAsFixed(0),
                      color: AppColors.orange,
                    ),
                  ],
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