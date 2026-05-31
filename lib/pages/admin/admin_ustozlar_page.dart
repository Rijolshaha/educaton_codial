import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../models/ustoz_model.dart';
import '../../../services/mentor_service.dart';
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
  final MentorService _service = MentorService();
  List<UstozModel> _ustozlar = [];
  bool _loading = true;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() => setState(() {}));
    _load();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    if (mounted) setState(() => _loading = true);
    final list = await _service.fetchMentors();
    if (!mounted) return;
    setState(() {
      _ustozlar = list;
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
      onConfirm: () => _doDelete(u),
    ),
  );

  Future<void> _doDelete(UstozModel u) async {
    final ok = await _service.deleteMentor(u.id);
    if (!mounted) return;
    if (!ok) {
      _snack("O'chirib bo'lmadi", error: true);
      return;
    }
    _snack("Ustoz o'chirildi");
    await _load();
  }

  void _openForm({UstozModel? ustoz}) => showDialog(
    context: context,
    builder: (_) => UstozFormDialog(
      ustoz: ustoz,
      onSave: (res) async {
        final ok = ustoz == null
            ? await _service.createMentor(
                username: res.username,
                password: res.password,
                email: res.email,
                direction: res.kurs,
              )
            : await _service.updateMentor(
                ustoz.id,
                username: res.username,
                email: res.email,
                direction: res.kurs,
                bio: res.bio,
                avatar: res.avatar,
              );
        if (ok && mounted) {
          _snack(ustoz == null
              ? "Ustoz qo'shildi ✅"
              : "O'zgarishlar saqlandi ✅");
          await _load();
        }
        return ok;
      },
    ),
  );

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final list = _filtered;

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
      ),
    );
  }
}