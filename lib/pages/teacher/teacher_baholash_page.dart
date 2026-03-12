import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../constants/app_colors.dart';
import '../../../models/teacher_model.dart';

// ─── Coin constants ───────────────────────────────────────────────────────────

const int _kQatnashdi = 25;
const int _kVaqtida   = 25;
const int _kFaollik   = 30;
const int _kOrganish  = 100;
const int _kKitob     = 100;
const int _kTozalik   = 25;
const int _kPodcast   = 50;

// ─── Student grade state ──────────────────────────────────────────────────────

class _StudentGrade {
  final TeacherStudent student;
  int  vazifa       = 0;
  bool qatnashdi    = false;
  bool vaqtida      = false;
  bool faollik      = false;
  bool organish     = false;
  bool kitob        = false;
  bool tozalik      = false;
  bool podcast      = false;  // toggle: +50 fixed
  int  podcastExtra = 0;      // qo'lda kiritiladi (0-500), ✨ da to'lmaydi

  _StudentGrade(this.student);

  int get totalCoins =>
      vazifa +
          (qatnashdi ? _kQatnashdi : 0) +
          (vaqtida   ? _kVaqtida   : 0) +
          (faollik   ? _kFaollik   : 0) +
          (organish  ? _kOrganish  : 0) +
          (kitob     ? _kKitob     : 0) +
          (tozalik   ? _kTozalik   : 0) +
          (podcast   ? _kPodcast   : 0) +
          podcastExtra;

  void setMax() {
    vazifa    = 100;
    qatnashdi = true;
    vaqtida   = true;
    faollik   = true;
    organish  = true;
    kitob     = true;
    tozalik   = true;
    podcast   = true;
    // podcastExtra — qo'lda kiritiladigan, ✨ da o'zgarmaydi
  }
}

// ─── Page ─────────────────────────────────────────────────────────────────────

class TeacherBaholashPage extends StatefulWidget {
  const TeacherBaholashPage({super.key});

  @override
  State<TeacherBaholashPage> createState() => _TeacherBaholashPageState();
}

class _TeacherBaholashPageState extends State<TeacherBaholashPage> {
  static final _teacher = TeacherModel.mock();

  int _selectedGroupIndex = 0;
  late List<_StudentGrade> _grades;

  // Barchaga qo'llash state
  bool _allQatnashdi = false;
  bool _allVaqtida   = false;
  bool _allFaollik   = false;
  bool _allOrganish  = false;
  bool _allKitob     = false;
  bool _allTozalik   = false;
  bool _allPodcast   = false;

  @override
  void initState() {
    super.initState();
    // Bugungi kunga mos birinchi guruhni avtomatik tanlash
    final todayIdx = _todayGroupIndexes;
    if (todayIdx.isNotEmpty) {
      _selectedGroupIndex = todayIdx.first;
    } else {
      _selectedGroupIndex = 0;
    }
    _initGrades();
  }

  /// Bugungi kunga mos keluvchi guruhlar indekslari
  List<int> get _todayGroupIndexes {
    return _teacher.groups.asMap().entries
        .where((e) => _isClassDay(e.value.schedule))
        .map((e) => e.key)
        .toList();
  }

  /// Berilgan schedule bugungi kunga mos keladi?
  bool _isClassDay(String schedule) {
    final today = DateTime.now().weekday;
    // "-" bilan ajratilgan kunlarni aniq moslashtirish
    // (masalan "Chorshanba" ichida "shanba" bor, contains xato ishlaydi)
    final days = schedule.toLowerCase().split('-').map((d) => d.trim()).toList();
    switch (today) {
      case 1: return days.contains('dushanba');
      case 2: return days.contains('seshanba');
      case 3: return days.contains('chorshanba');
      case 4: return days.contains('payshanba');
      case 5: return days.contains('juma');
      case 6: return days.contains('shanba');
      default: return false; // Yakshanba — hech qachon dars yo'q
    }
  }

  void _initGrades() {
    _grades = _currentGroup.students.map((s) => _StudentGrade(s)).toList();
  }

  TeacherGroup get _currentGroup =>
      _teacher.groups[_selectedGroupIndex];

  bool get _isTodayClassDay => _isClassDay(_currentGroup.schedule);

  String get _todayName {
    const days = ['', 'Dushanba', 'Seshanba', 'Chorshanba',
      'Payshanba', 'Juma', 'Shanba', 'Yakshanba'];
    return days[DateTime.now().weekday];
  }

  String get _todayDate {
    final n = DateTime.now();
    return '${n.day.toString().padLeft(2,'0')}.${n.month.toString().padLeft(2,'0')}.${n.year}';
  }

  void _applyAll(String key, bool value) {
    setState(() {
      for (final g in _grades) {
        switch (key) {
          case 'qatnashdi': g.qatnashdi = value; break;
          case 'vaqtida':   g.vaqtida   = value; break;
          case 'faollik':   g.faollik   = value; break;
          case 'organish':  g.organish  = value; break;
          case 'kitob':     g.kitob     = value; break;
          case 'tozalik':   g.tozalik   = value; break;
          case 'podcast':   g.podcast   = value; break;
        }
      }
    });
  }

  void _onGroupChanged(int? index) {
    if (index == null) return;
    setState(() {
      _selectedGroupIndex = index;
      _initGrades();
      _allQatnashdi = false; _allVaqtida = false; _allFaollik  = false;
      _allOrganish  = false; _allKitob   = false; _allTozalik  = false;
      _allPodcast   = false;
    });
  }

  void _onSave() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Baholar saqlandi! ✅'),
      backgroundColor: AppColors.green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [

            // ── Title ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Baholash',
                        style: TextStyle(
                          fontSize: 28, fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        )),
                    const SizedBox(height: 4),
                    const Text("O'quvchilarni baholash va coin berish",
                        style: TextStyle(
                            fontSize: 14, color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ),

            // ── Saqlash ───────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _onSave,
                    icon: const Icon(Icons.save_outlined, size: 20),
                    label: const Text('Saqlash',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue1,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ),
            ),

            // ── Guruh + Sana ──────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10, offset: const Offset(0, 3))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Guruhni tanlang',
                          style: TextStyle(fontSize: 13,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      Builder(builder: (context) {
                        final todayIdxs = _todayGroupIndexes;
                        final dropdownGroups = todayIdxs.isEmpty
                            ? _teacher.groups.asMap().entries.toList()
                            : _teacher.groups.asMap().entries
                            .where((e) => todayIdxs.contains(e.key))
                            .toList();

                        // Agar tanlangan guruh filterlangan ro'yxatda yo'q bo'lsa
                        final validValue = dropdownGroups
                            .any((e) => e.key == _selectedGroupIndex)
                            ? _selectedGroupIndex
                            : dropdownGroups.first.key;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 4),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColors.blue1, width: 1.5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  value: validValue,
                                  isExpanded: true,
                                  icon: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: AppColors.textSecondary),
                                  style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                  onChanged: _onGroupChanged,
                                  items: dropdownGroups
                                      .map((e) => DropdownMenuItem(
                                    value: e.key,
                                    child: Text(e.value.name),
                                  ))
                                      .toList(),
                                ),
                              ),
                            ),
                            if (todayIdxs.isEmpty) ...[
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFDE7),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.info_outline_rounded,
                                        size: 15, color: Colors.orange.shade700),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Bugun hech qaysi guruhda dars yo\'q',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.orange.shade800),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        );
                      }),
                      const SizedBox(height: 14),

                      const Text('Bugun',
                          style: TextStyle(fontSize: 13,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.scaffold,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_todayName,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary)),
                            Text(_todayDate,
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      const Text('Dars kunlari',
                          style: TextStyle(fontSize: 13,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _isTodayClassDay
                              ? const Color(0xFFE8F5E9)
                              : const Color(0xFFFFEBEE),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _currentGroup.schedule,
                          style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600,
                            color: _isTodayClassDay
                                ? AppColors.green
                                : AppColors.red,
                          ),
                        ),
                      ),
                      if (!_isTodayClassDay) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFDE7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.info_outline_rounded,
                                  size: 16, color: Colors.orange.shade700),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Bugun ushbu guruhda dars yo'q. Baholash faqat dars kunlarida amalga oshiriladi.",
                                  style: TextStyle(fontSize: 13,
                                      color: Colors.orange.shade800,
                                      height: 1.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // ── Barchaga qo'llash ─────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10, offset: const Offset(0, 3))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Barchaga qo'llash:",
                          style: TextStyle(fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary)),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8, runSpacing: 8,
                        children: [
                          _BulkChip(
                            label: 'Vazifa 100',
                            color: AppColors.blue1, active: false,
                            onTap: () => setState(() {
                              for (final g in _grades) g.vazifa = 100;
                            }),
                          ),
                          _BulkChip(
                            label: 'Qatnashdi +$_kQatnashdi',
                            color: AppColors.green, active: _allQatnashdi,
                            onTap: () {
                              setState(() => _allQatnashdi = !_allQatnashdi);
                              _applyAll('qatnashdi', _allQatnashdi);
                            },
                          ),
                          _BulkChip(
                            label: 'Vaqtida +$_kVaqtida',
                            color: AppColors.green, active: _allVaqtida,
                            onTap: () {
                              setState(() => _allVaqtida = !_allVaqtida);
                              _applyAll('vaqtida', _allVaqtida);
                            },
                          ),
                          _BulkChip(
                            label: 'Faollik +$_kFaollik',
                            color: AppColors.green, active: _allFaollik,
                            onTap: () {
                              setState(() => _allFaollik = !_allFaollik);
                              _applyAll('faollik', _allFaollik);
                            },
                          ),
                          _BulkChip(
                            label: "O'rganish +$_kOrganish",
                            color: AppColors.purple, active: _allOrganish,
                            onTap: () {
                              setState(() => _allOrganish = !_allOrganish);
                              _applyAll('organish', _allOrganish);
                            },
                          ),
                          _BulkChip(
                            label: 'Kitob +$_kKitob',
                            color: AppColors.orange, active: _allKitob,
                            onTap: () {
                              setState(() => _allKitob = !_allKitob);
                              _applyAll('kitob', _allKitob);
                            },
                          ),
                          _BulkChip(
                            label: 'Tozalik +$_kTozalik',
                            color: const Color(0xFF00BCD4), active: _allTozalik,
                            onTap: () {
                              setState(() => _allTozalik = !_allTozalik);
                              _applyAll('tozalik', _allTozalik);
                            },
                          ),
                          _BulkChip(
                            label: 'Podcast +$_kPodcast',
                            color: const Color(0xFFE91E63), active: _allPodcast,
                            onTap: () {
                              setState(() => _allPodcast = !_allPodcast);
                              _applyAll('podcast', _allPodcast);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Student cards ─────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (ctx, i) => _StudentCard(
                    grade: _grades[i],
                    onChanged: () => setState(() {}),
                  ),
                  childCount: _grades.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Bulk chip ────────────────────────────────────────────────────────────────

class _BulkChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool active;
  final VoidCallback onTap;
  const _BulkChip({required this.label, required this.color,
    required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? color : color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: active ? color : color.withOpacity(0.3), width: 1.5),
        ),
        child: Text(label,
            style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w700,
              color: active ? Colors.white : color,
            )),
      ),
    );
  }
}

// ─── Student Card ─────────────────────────────────────────────────────────────

class _StudentCard extends StatefulWidget {
  final _StudentGrade grade;
  final VoidCallback onChanged;
  const _StudentCard({required this.grade, required this.onChanged});

  @override
  State<_StudentCard> createState() => _StudentCardState();
}

class _StudentCardState extends State<_StudentCard> {
  late final TextEditingController _vazifaCtrl;
  late final TextEditingController _podcastCtrl;

  _StudentGrade get g => widget.grade;

  @override
  void initState() {
    super.initState();
    _vazifaCtrl  = TextEditingController(text: g.vazifa == 0 ? '' : '${g.vazifa}');
    _podcastCtrl = TextEditingController(text: g.podcastExtra == 0 ? '' : '${g.podcastExtra}');
  }

  @override
  void dispose() {
    _vazifaCtrl.dispose();
    _podcastCtrl.dispose();
    super.dispose();
  }

  void _toggle(String key) {
    setState(() {
      switch (key) {
        case 'qatnashdi': g.qatnashdi = !g.qatnashdi; break;
        case 'vaqtida':   g.vaqtida   = !g.vaqtida;   break;
        case 'faollik':   g.faollik   = !g.faollik;   break;
        case 'organish':  g.organish  = !g.organish;  break;
        case 'kitob':     g.kitob     = !g.kitob;     break;
        case 'tozalik':   g.tozalik   = !g.tozalik;   break;
      }
    });
    widget.onChanged();
  }

  void _setMax() {
    setState(() {
      g.setMax();
      _vazifaCtrl.text = '100';
      // podcastExtra — qo'lda kiritiladigan, ✨ da o'zgarmaydi
    });
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    // Sync vazifa controller when bulk applied externally
    if (int.tryParse(_vazifaCtrl.text) != g.vazifa) {
      _vazifaCtrl.text = '${g.vazifa}';
    }
    // podcastExtra controller — faqat foydalanuvchi o'zi kiritadi, sync qilinmaydi

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                    color: AppColors.bgCard, shape: BoxShape.circle),
                child: Center(child: Text(g.student.avatarEmoji,
                    style: const TextStyle(fontSize: 26))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(g.student.name,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary)),
                    Text('${g.totalCoins} coin',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w900,
                            color: AppColors.green)),
                  ],
                ),
              ),
              // ✨ Max button
              GestureDetector(
                onTap: _setMax,
                child: Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.blue1.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                      child: Text('✨', style: TextStyle(fontSize: 20))),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Vazifa
          const Text('Vazifa (0-100)',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 6),
          TextField(
            controller: _vazifaCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              _MaxFormatter(100),
            ],
            onChanged: (v) {
              setState(() => g.vazifa = int.tryParse(v) ?? 0);
              widget.onChanged();
            },
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              filled: true, fillColor: AppColors.scaffold,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 12),

          // Toggle grid
          GridView.count(
            crossAxisCount: 2, shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8, crossAxisSpacing: 8,
            childAspectRatio: 3.5,
            children: [
              _Btn('qatnashdi', 'Qatnashdi', '+$_kQatnashdi', g.qatnashdi, AppColors.green),
              _Btn('vaqtida',   'Vaqtida',   '+$_kVaqtida',   g.vaqtida,   AppColors.green),
              _Btn('faollik',   'Faollik',   '+$_kFaollik',   g.faollik,   AppColors.green),
              _Btn('organish',  "O'rganish", '+$_kOrganish',  g.organish,  AppColors.purple),
              _Btn('kitob',     'Kitob',     '+$_kKitob',     g.kitob,     AppColors.orange),
              _Btn('tozalik',   'Tozalik',   '+$_kTozalik',   g.tozalik,   const Color(0xFF00BCD4)),
            ].map((b) => GestureDetector(
              onTap: () => _toggle(b.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                decoration: BoxDecoration(
                  color: b.active ? b.color : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    b.active ? '${b.label} ${b.value}' : b.label,
                    style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700,
                      color: b.active ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 8),

          // Podcast row: toggle (+50 fixed) + manual extra input (0-500)
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => g.podcast = !g.podcast);
                    widget.onChanged();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: g.podcast
                          ? const Color(0xFFE91E63)
                          : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        g.podcast ? 'Podcast +$_kPodcast' : 'Podcast',
                        style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w700,
                          color: g.podcast
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Qo'lda kiritiladigan qo'shimcha ball (0-500)
              Expanded(
                child: TextField(
                  controller: _podcastCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    _MaxFormatter(500),
                  ],
                  onChanged: (v) {
                    setState(() => g.podcastExtra = int.tryParse(v) ?? 0);
                    widget.onChanged();
                  },
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    hintText: 'Imtihon uchun ball',
                    hintStyle: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w400),
                    filled: true, fillColor: AppColors.scaffold,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Helper classes ───────────────────────────────────────────────────────────

class _Btn {
  final String key, label, value;
  final bool active;
  final Color color;
  const _Btn(this.key, this.label, this.value, this.active, this.color);
}

class _MaxFormatter extends TextInputFormatter {
  final int max;
  const _MaxFormatter(this.max);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue old, TextEditingValue next) {
    if (next.text.isEmpty) return next;
    final v = int.tryParse(next.text);
    if (v == null || v > max) return old;
    return next;
  }
}