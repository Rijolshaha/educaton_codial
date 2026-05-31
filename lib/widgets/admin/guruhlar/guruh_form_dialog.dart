import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../models/guruh_model.dart';
import '../../../../models/kurs_model.dart';
import '../../../../models/ustoz_model.dart';
import '../../../../services/course_service.dart';
import '../../../../services/mentor_service.dart';

/// Forma natijasi — sahifaga qaytariladi.
class GuruhFormResult {
  final String name;
  final String courseId;
  final String? mentorId;
  final JadvalTuri jadval;
  final bool active;

  const GuruhFormResult({
    required this.name,
    required this.courseId,
    required this.mentorId,
    required this.jadval,
    required this.active,
  });
}

class GuruhFormDialog extends StatefulWidget {
  final AdminGuruh? guruh;

  /// Saqlashni bajaradi (API). `true` qaytsa — dialog yopiladi.
  final Future<bool> Function(GuruhFormResult) onSave;

  const GuruhFormDialog({
    super.key,
    this.guruh,
    required this.onSave,
  });

  @override
  State<GuruhFormDialog> createState() => _GuruhFormDialogState();
}

class _GuruhFormDialogState extends State<GuruhFormDialog> {
  late TextEditingController _nomiC;
  late JadvalTuri _jadval;
  late GuruhStatus _status;

  String? _courseId;
  String? _mentorId;

  List<KursModel> _courses = [];
  List<UstozModel> _mentors = [];
  bool _loadingRefs = true;
  bool _saving = false;

  bool get _isEdit => widget.guruh != null;

  @override
  void initState() {
    super.initState();
    final g = widget.guruh;
    _nomiC = TextEditingController(text: g?.nomi ?? '');
    _jadval = g?.jadval ?? JadvalTuri.jadvalA;
    _status = g?.status ?? GuruhStatus.faol;
    _courseId = (g?.courseId.isNotEmpty ?? false) ? g!.courseId : null;
    _mentorId = (g?.mentorId?.isNotEmpty ?? false) ? g!.mentorId : null;
    _loadRefs();
  }

  Future<void> _loadRefs() async {
    final results = await Future.wait([
      CourseService().fetchCourses(),
      MentorService().fetchMentors(),
    ]);
    if (!mounted) return;
    setState(() {
      _courses = results[0] as List<KursModel>;
      _mentors = results[1] as List<UstozModel>;
      // Tanlangan qiymat ro'yxatda bo'lmasa — null.
      if (!_courses.any((c) => c.id == _courseId)) _courseId = null;
      if (!_mentors.any((m) => m.id == _mentorId)) _mentorId = null;
      _loadingRefs = false;
    });
  }

  @override
  void dispose() {
    _nomiC.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    if (_nomiC.text.trim().isEmpty) {
      _err('Guruh nomi kiritilmadi');
      return;
    }
    if (_courseId == null) {
      _err('Kurs tanlanmadi');
      return;
    }
    setState(() => _saving = true);
    final ok = await widget.onSave(GuruhFormResult(
      name: _nomiC.text.trim(),
      courseId: _courseId!,
      mentorId: _mentorId,
      jadval: _jadval,
      active: _status == GuruhStatus.faol,
    ));
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context);
    } else {
      setState(() => _saving = false);
      _err('Saqlab bo\'lmadi. Qayta urinib ko\'ring.');
    }
  }

  void _err(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isEdit ? 'Guruhni tahrirlash' : "Guruh qo'shish",
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Guruh nomi
            _lbl('Guruh nomi *'),
            TextField(
              controller: _nomiC,
              decoration: _dec('Masalan: Backend 36'),
            ),
            const SizedBox(height: 12),

            // Kurs (course_id)
            _lbl('Kurs *'),
            _loadingRefs
                ? _loadingBox()
                : _dropBox(
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _courseId,
                        isExpanded: true,
                        hint: const Text('Kursni tanlang',
                            style: TextStyle(fontSize: 13)),
                        items: _courses
                            .map((c) => DropdownMenuItem(
                                  value: c.id,
                                  child: Text(c.nomi,
                                      style: const TextStyle(fontSize: 13),
                                      overflow: TextOverflow.ellipsis),
                                ))
                            .toList(),
                        onChanged: (v) => setState(() => _courseId = v),
                      ),
                    ),
                  ),
            const SizedBox(height: 12),

            // Ustoz (mentor_id, ixtiyoriy)
            _lbl('Ustoz'),
            _loadingRefs
                ? _loadingBox()
                : _dropBox(
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String?>(
                        value: _mentorId,
                        isExpanded: true,
                        hint: const Text('Ustozni tanlang',
                            style: TextStyle(fontSize: 13)),
                        items: [
                          const DropdownMenuItem<String?>(
                            value: null,
                            child: Text('Tanlanmagan',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textHint)),
                          ),
                          ..._mentors.map((m) => DropdownMenuItem<String?>(
                                value: m.id,
                                child: Text(m.ism,
                                    style: const TextStyle(fontSize: 13),
                                    overflow: TextOverflow.ellipsis),
                              )),
                        ],
                        onChanged: (v) => setState(() => _mentorId = v),
                      ),
                    ),
                  ),
            const SizedBox(height: 12),

            // Jadval
            _lbl('Jadval'),
            _dropBox(
              DropdownButtonHideUnderline(
                child: DropdownButton<JadvalTuri>(
                  value: _jadval,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(
                      value: JadvalTuri.jadvalA,
                      child: Text('Jadval A (Du-Ch-Ju)'),
                    ),
                    DropdownMenuItem(
                      value: JadvalTuri.jadvalB,
                      child: Text('Jadval B (Se-Pa-Sh)'),
                    ),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => _jadval = v);
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Status
            _lbl('Status'),
            _dropBox(
              DropdownButtonHideUnderline(
                child: DropdownButton<GuruhStatus>(
                  value: _status,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(
                      value: GuruhStatus.faol,
                      child: Text('Faol'),
                    ),
                    DropdownMenuItem(
                      value: GuruhStatus.faolEmas,
                      child: Text('Faol emas'),
                    ),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => _status = v);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Buttons
            Row(children: [
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        AppColors.primary.withOpacity(0.6),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  child: _saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : Text(_isEdit ? 'Saqlash' : "Qo'shish",
                          style:
                              const TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: _saving ? null : () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Color(0xFFE5E7EB)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Bekor',
                      style: TextStyle(color: AppColors.textSecondary)),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _lbl(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(t,
            style:
                const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      );

  Widget _loadingBox() => Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 10),
          Text('Yuklanmoqda...',
              style: TextStyle(fontSize: 13, color: AppColors.textHint)),
        ]),
      );

  Widget _dropBox(Widget child) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: child,
      );

  InputDecoration _dec(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 13),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.primary)),
      );
}
