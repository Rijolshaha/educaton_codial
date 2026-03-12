import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../models/student_model.dart';
import '../../../widgets/admin/oquvchilar/oquvchi_stat_card.dart';
import '../../../widgets/admin/oquvchilar/oquvchi_card.dart';
import '../../../widgets/admin/oquvchilar/oquvchi_detail_dialog.dart';
import '../../../widgets/admin/oquvchilar/oquvchi_form_dialog.dart';
import '../../../widgets/admin/oquvchilar/oquvchi_confirm_dialog.dart';
import '../../models/oquvchi_admin_model.dart';

class AdminOquvchilarPage extends StatefulWidget {
  const AdminOquvchilarPage({super.key});

  @override
  State<AdminOquvchilarPage> createState() =>
      _AdminOquvchilarPageState();
}

class _AdminOquvchilarPageState extends State<AdminOquvchilarPage> {
  late List<StudentModel> _students;
  final _searchCtrl = TextEditingController();
  String? _filterUstoz;
  String? _filterGuruh;

  @override
  void initState() {
    super.initState();
    _students = List.from(studentsHaftalik);
    _searchCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // ── Computed ───────────────────────────────────────────────────────────────

  List<StudentModel> get _filtered {
    return _students.where((s) {
      // Search
      final q = _searchCtrl.text.toLowerCase();
      if (q.isNotEmpty &&
          !s.name.toLowerCase().contains(q) &&
          !s.email.toLowerCase().contains(q) &&
          !s.group.toLowerCase().contains(q)) return false;

      // Ustoz filter — guruh orqali
      if (_filterUstoz != null) {
        final ustoz = guruhUstozMap[s.group];
        if (ustoz != _filterUstoz) return false;
      }

      // Guruh filter
      if (_filterGuruh != null && s.group != _filterGuruh) {
        return false;
      }

      return true;
    }).toList();
  }

  int get _avgCoins {
    if (_students.isEmpty) return 0;
    return _students.fold(0, (s, e) => s + e.coins) ~/
        _students.length;
  }

  int get _maxCoins =>
      _students.isEmpty
          ? 0
          : _students.map((s) => s.coins).reduce(
              (a, b) => a > b ? a : b);

  // ── Actions ────────────────────────────────────────────────────────────────

  void _viewStudent(StudentModel s) => showDialog(
    context: context,
    builder: (_) => OquvchiDetailDialog(student: s),
  );

  void _addStudent() => _openForm();
  void _editStudent(StudentModel s) => _openForm(student: s);

  void _deleteStudent(StudentModel s) => showDialog(
    context: context,
    builder: (_) => OquvchiConfirmDialog(
      title: "O'quvchini o'chirish",
      message: "'${s.name}' ni o'chirishni xohlaysizmi?",
      onConfirm: () => setState(
              () => _students.removeWhere((e) => e.id == s.id)),
    ),
  );

  void _openForm({StudentModel? student}) => showDialog(
    context: context,
    builder: (_) => OquvchiFormDialog(
      student: student,
      onSave: (saved) => setState(() {
        if (student == null) {
          _students.insert(0, saved);
        } else {
          final i =
          _students.indexWhere((e) => e.id == saved.id);
          if (i != -1) _students[i] = saved;
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
                padding:
                const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Title ──
                    const Text(
                      "O'quvchilarni boshqarish",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      "Barcha o'quvchilar ro'yxati va boshqarish",
                      style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),

                    // ── Add button ──
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _addStudent,
                        icon: const Icon(Icons.add,
                            color: Colors.white, size: 18),
                        label: const Text(
                          "O'quvchi qo'shish",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                              vertical: 13),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ── Search ──
                    TextField(
                      controller: _searchCtrl,
                      decoration: InputDecoration(
                        hintText: "O'quvchi qidirish...",
                        hintStyle: const TextStyle(
                            color: AppColors.textHint,
                            fontSize: 13),
                        prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: AppColors.textHint,
                            size: 20),
                        suffixIcon:
                        _searchCtrl.text.isNotEmpty
                            ? IconButton(
                            icon: const Icon(
                                Icons.close_rounded,
                                size: 18,
                                color:
                                AppColors.textHint),
                            onPressed:
                            _searchCtrl.clear)
                            : null,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                        const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Color(0xFFE5E7EB))),
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Color(0xFFE5E7EB))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: AppColors.primary)),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // ── Ustoz filter dropdown ──
                    _FilterDropdown<String>(
                      icon: Icons.tune_rounded,
                      hint: 'Barcha ustozlar',
                      value: _filterUstoz,
                      items: allOquvchiUstozlar,
                      labelBuilder: (v) => v,
                      onChanged: (v) => setState(() {
                        _filterUstoz = v;
                        // guruh filterni reset
                        _filterGuruh = null;
                      }),
                    ),
                    const SizedBox(height: 10),

                    // ── Guruh filter dropdown ──
                    _FilterDropdown<String>(
                      icon: Icons.tune_rounded,
                      hint: 'Barcha guruhlar',
                      value: _filterGuruh,
                      items: _filterUstoz != null
                          ? allOquvchiGuruhlar
                          .where((g) =>
                      guruhUstozMap[g] ==
                          _filterUstoz)
                          .toList()
                          : allOquvchiGuruhlar,
                      labelBuilder: (v) => v,
                      onChanged: (v) =>
                          setState(() => _filterGuruh = v),
                    ),
                    const SizedBox(height: 16),

                    // ── Count ──
                    Text(
                      "${list.length} ta o'quvchi",
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

            // ── Student cards ──
            list.isEmpty
                ? SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Column(children: [
                  Icon(Icons.person_off_outlined,
                      size: 52,
                      color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  const Text("O'quvchi topilmadi",
                      style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14)),
                ]),
              ),
            )
                : SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                  16, 0, 16, 0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (_, i) => OquvchiCard(
                    student: list[i],
                    onView: () =>
                        _viewStudent(list[i]),
                    onEdit: () =>
                        _editStudent(list[i]),
                    onDelete: () =>
                        _deleteStudent(list[i]),
                  ),
                  childCount: list.length,
                ),
              ),
            ),

            // ── Bottom stats ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    16, 20, 16, 0),
                child: Column(
                  children: [
                    OquvchiStatCard(
                      label: "Jami o'quvchilar",
                      value: '${_students.length}',
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 10),
                    OquvchiStatCard(
                      label: "Faol o'quvchilar",
                      value: '${_students.length}',
                      color: AppColors.greenDark,
                    ),
                    const SizedBox(height: 10),
                    OquvchiStatCard(
                      label: "O'rtacha coin",
                      value:
                      oquvchiFormatCoins(_avgCoins),
                      color: AppColors.orange,
                    ),
                    const SizedBox(height: 10),
                    OquvchiStatCard(
                      label: 'Eng yuqori coin',
                      value:
                      oquvchiFormatCoins(_maxCoins),
                      color: const Color(0xFFFFB800),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(
                child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }
}

// ─── Filter Dropdown ──────────────────────────────────────────────────────────

class _FilterDropdown<T> extends StatelessWidget {
  final IconData icon;
  final String hint;
  final T? value;
  final List<T> items;
  final String Function(T) labelBuilder;
  final void Function(T?) onChanged;

  const _FilterDropdown({
    required this.icon,
    required this.hint,
    required this.value,
    required this.items,
    required this.labelBuilder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 14, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasValue
              ? AppColors.primary
              : const Color(0xFFE5E7EB),
          width: hasValue ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon,
              size: 18,
              color: hasValue
                  ? AppColors.primary
                  : AppColors.textHint),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                value: value,
                isExpanded: true,
                hint: Text(
                  hint,
                  style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13),
                ),
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13),
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: hasValue
                      ? AppColors.primary
                      : AppColors.textHint,
                ),
                items: [
                  DropdownMenuItem<T>(
                    value: null,
                    child: Text(hint,
                        style: const TextStyle(
                            color: AppColors.textHint,
                            fontSize: 13)),
                  ),
                  ...items.map((v) => DropdownMenuItem<T>(
                    value: v,
                    child: Text(labelBuilder(v)),
                  )),
                ],
                onChanged: onChanged,
              ),
            ),
          ),
          if (hasValue)
            GestureDetector(
              onTap: () => onChanged(null),
              child: const Icon(Icons.close_rounded,
                  size: 16, color: AppColors.textSecondary),
            ),
        ],
      ),
    );
  }
}