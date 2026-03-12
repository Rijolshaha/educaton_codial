import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../models/student_model.dart';
import '../../../models/oquvchi_admin_model.dart';

class OquvchiFormDialog extends StatefulWidget {
  final StudentModel? student;
  final void Function(StudentModel) onSave;

  const OquvchiFormDialog({
    super.key,
    this.student,
    required this.onSave,
  });

  @override
  State<OquvchiFormDialog> createState() => _OquvchiFormDialogState();
}

class _OquvchiFormDialogState extends State<OquvchiFormDialog> {
  late TextEditingController _nameC;
  late TextEditingController _emailC;
  late TextEditingController _coinsC;
  late String _group;
  late String _emoji;
  late String _color;

  static const List<String> _emojis = [
    '👩', '👨', '👧', '👦', '🧑', '🧔', '👩‍💻', '👨‍💻',
  ];
  static const List<String> _colors = [
    '#4ECDC4', '#FF6B6B', '#F0B27A', '#BB8FCE',
    '#45B7D1', '#96CEB4', '#F7DC6F', '#82E0AA',
  ];

  final List<String> _guruhlar = allOquvchiGuruhlar;

  @override
  void initState() {
    super.initState();
    final s = widget.student;
    _nameC  = TextEditingController(text: s?.name ?? '');
    _emailC = TextEditingController(text: s?.email ?? '');
    _coinsC = TextEditingController(
        text: s != null ? '${s.coins}' : '');
    _group  = s?.group  ?? allOquvchiGuruhlar.first;
    _emoji  = s?.avatarEmoji  ?? _emojis.first;
    _color  = s?.avatarColor  ?? _colors.first;
  }

  @override
  void dispose() {
    _nameC.dispose();
    _emailC.dispose();
    _coinsC.dispose();
    super.dispose();
  }

  void _save() {
    if (_nameC.text.trim().isEmpty || _emailC.text.trim().isEmpty) return;
    final s = widget.student;
    final coins = int.tryParse(_coinsC.text) ?? 0;
    widget.onSave(StudentModel(
      id: s?.id ?? DateTime.now().millisecondsSinceEpoch,
      rank: s?.rank ?? 99,
      name: _nameC.text.trim(),
      email: _emailC.text.trim(),
      group: _group,
      coins: coins,
      gain: s?.gain ?? 0,
      avatarEmoji: _emoji,
      avatarColor: _color,
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.student != null;
    final previewColor = oquvchiAvatarColor(_color);

    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
      insetPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
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
                  isEdit ? "O'quvchini tahrirlash" : "O'quvchi qo'shish",
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close_rounded,
                      color: AppColors.textSecondary),
                ),
              ],
            ),
            const Divider(height: 20, color: Color(0xFFE5E7EB)),

            // Avatar preview
            Center(
              child: Container(
                width: 64, height: 64,
                decoration: BoxDecoration(
                  color: previewColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(_emoji,
                      style: const TextStyle(fontSize: 30)),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Emoji picker
            _lbl('Avatar'),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: _emojis.map((e) {
                final sel = e == _emoji;
                return GestureDetector(
                  onTap: () => setState(() => _emoji = e),
                  child: Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: sel
                          ? AppColors.primary.withOpacity(0.1)
                          : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(10),
                      border: sel
                          ? Border.all(
                          color: AppColors.primary, width: 2)
                          : null,
                    ),
                    child: Center(
                      child: Text(e,
                          style: const TextStyle(fontSize: 22)),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),

            // Color picker
            _lbl('Rang'),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: _colors.map((c) {
                final sel = c == _color;
                final col = oquvchiAvatarColor(c);
                return GestureDetector(
                  onTap: () => setState(() => _color = c),
                  child: Container(
                    width: 34, height: 34,
                    decoration: BoxDecoration(
                      color: col,
                      shape: BoxShape.circle,
                      border: sel
                          ? Border.all(
                          color: Colors.white, width: 2.5)
                          : null,
                      boxShadow: sel
                          ? [
                        BoxShadow(
                          color: col.withOpacity(0.5),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                          : null,
                    ),
                    child: sel
                        ? const Icon(Icons.check_rounded,
                        color: Colors.white, size: 16)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),

            // Ism
            _lbl('Ism Familiya *'),
            TextField(
              controller: _nameC,
              decoration: _dec('Masalan: Abbos Qodirov'),
            ),
            const SizedBox(height: 12),

            // Email
            _lbl('Email *'),
            TextField(
              controller: _emailC,
              keyboardType: TextInputType.emailAddress,
              decoration: _dec('Masalan: abbos@codial.uz'),
            ),
            const SizedBox(height: 12),

            // Guruh
            _lbl('Guruh'),
            _dropBox(
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _group,
                  isExpanded: true,
                  items: _guruhlar
                      .map((g) => DropdownMenuItem(
                    value: g,
                    child: Row(children: [
                      Container(
                        width: 10, height: 10,
                        decoration: BoxDecoration(
                          color: oquvchiGroupColor(g),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(g,
                          style: const TextStyle(
                              fontSize: 13)),
                    ]),
                  ))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _group = v);
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Coinlar
            _lbl('Coinlar'),
            TextField(
              controller: _coinsC,
              keyboardType: TextInputType.number,
              decoration: _dec('Masalan: 3450'),
            ),
            const SizedBox(height: 20),

            // Buttons
            Row(children: [
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding:
                    const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text(
                    isEdit ? 'Saqlash' : "Qo'shish",
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding:
                    const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(
                        color: Color(0xFFE5E7EB)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Bekor',
                      style: TextStyle(
                          color: AppColors.textSecondary)),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _lbl(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(t,
        style: const TextStyle(
            fontSize: 13, fontWeight: FontWeight.w600)),
  );

  Widget _dropBox(Widget child) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: const Color(0xFFF9FAFB),
      border: Border.all(color: const Color(0xFFE5E7EB)),
      borderRadius: BorderRadius.circular(10),
    ),
    child: child,
  );

  InputDecoration _dec(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(
        color: AppColors.textHint, fontSize: 13),
    filled: true,
    fillColor: const Color(0xFFF9FAFB),
    contentPadding: const EdgeInsets.symmetric(
        horizontal: 12, vertical: 12),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:
        const BorderSide(color: Color(0xFFE5E7EB))),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:
        const BorderSide(color: Color(0xFFE5E7EB))),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:
        const BorderSide(color: AppColors.primary)),
  );
}