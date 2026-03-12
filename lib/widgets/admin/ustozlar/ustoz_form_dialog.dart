import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../models/ustoz_model.dart';

class UstozFormDialog extends StatefulWidget {
  final UstozModel? ustoz;
  final void Function(UstozModel) onSave;

  const UstozFormDialog({
    super.key,
    this.ustoz,
    required this.onSave,
  });

  @override
  State<UstozFormDialog> createState() => _UstozFormDialogState();
}

class _UstozFormDialogState extends State<UstozFormDialog> {
  late TextEditingController _ismC;
  late TextEditingController _emailC;
  late String _kurs;
  late UstozStatus _status;

  // Avatar options
  static const List<String> _emojis = [
    '👨‍💻', '👩‍💻', '🧑‍🏫', '👩‍🏫',
    '👨‍🔬', '👩‍🔬', '🧑‍💼', '👩‍💼',
    '👨‍🎨', '👩‍🎨',
  ];

  static const List<String> _colors = [
    '#3B82F6', '#8B5CF6', '#EF4444', '#06B6D4',
    '#A855F7', '#F97316', '#059669', '#F59E0B',
  ];

  late String _selectedEmoji;
  late String _selectedColor;

  @override
  void initState() {
    super.initState();
    final u = widget.ustoz;
    _ismC           = TextEditingController(text: u?.ism ?? '');
    _emailC         = TextEditingController(text: u?.email ?? '');
    _kurs           = u?.kurs   ?? ustozKurslar.first;
    _status         = u?.status ?? UstozStatus.faol;
    _selectedEmoji  = u?.avatarEmoji ?? _emojis[0];
    _selectedColor  = u?.avatarColor ?? _colors[0];
  }

  @override
  void dispose() {
    _ismC.dispose();
    _emailC.dispose();
    super.dispose();
  }

  void _save() {
    if (_ismC.text.trim().isEmpty || _emailC.text.trim().isEmpty) return;
    final u = widget.ustoz;
    widget.onSave(UstozModel(
      id: u?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      ism: _ismC.text.trim(),
      email: _emailC.text.trim(),
      kurs: _kurs,
      guruhlarSoni: u?.guruhlarSoni ?? 0,
      oquvchilarSoni: u?.oquvchilarSoni ?? 0,
      status: _status,
      avatarEmoji: _selectedEmoji,
      avatarColor: _selectedColor,
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.ustoz != null;
    final avatarColor = ustozAvatarColor(_selectedColor);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Title ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEdit ? 'Ustozni tahrirlash' : "Ustoz qo'shish",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close_rounded,
                      color: AppColors.textSecondary),
                ),
              ],
            ),
            const Divider(height: 20, color: Color(0xFFE5E7EB)),

            // ── Avatar preview ──
            Center(
              child: Container(
                width: 64, height: 64,
                decoration: BoxDecoration(
                  color: avatarColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(_selectedEmoji,
                      style: const TextStyle(fontSize: 30)),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── Emoji picker ──
            _lbl('Avatar'),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: _emojis.map((e) {
                final sel = e == _selectedEmoji;
                return GestureDetector(
                  onTap: () => setState(() => _selectedEmoji = e),
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
                          style: const TextStyle(fontSize: 20)),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),

            // ── Color picker ──
            _lbl('Rang'),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: _colors.map((c) {
                final sel = c == _selectedColor;
                final color = ustozAvatarColor(c);
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = c),
                  child: Container(
                    width: 34, height: 34,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: sel
                          ? Border.all(
                          color: Colors.white, width: 2.5)
                          : null,
                      boxShadow: sel
                          ? [
                        BoxShadow(
                          color: color.withOpacity(0.5),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
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

            // ── Ism ──
            _lbl('Ism Familiya *'),
            TextField(
              controller: _ismC,
              decoration: _dec('Masalan: Otabek Tursunov'),
            ),
            const SizedBox(height: 12),

            // ── Email ──
            _lbl('Email *'),
            TextField(
              controller: _emailC,
              keyboardType: TextInputType.emailAddress,
              decoration: _dec('Masalan: otabek@codial.uz'),
            ),
            const SizedBox(height: 12),

            // ── Kurs ──
            _lbl('Kurs'),
            _dropBox(
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _kurs,
                  isExpanded: true,
                  items: ustozKurslar
                      .map((k) => DropdownMenuItem(
                    value: k,
                    child: Row(children: [
                      Icon(ustozKursIcon(k),
                          size: 16,
                          color: ustozKursColor(k)),
                      const SizedBox(width: 8),
                      Text(k,
                          style: const TextStyle(
                              fontSize: 13)),
                    ]),
                  ))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _kurs = v);
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── Status ──
            _lbl('Status'),
            Row(children: [
              _StatusChip(
                label: 'Faol',
                selected: _status == UstozStatus.faol,
                color: AppColors.greenDark,
                onTap: () =>
                    setState(() => _status = UstozStatus.faol),
              ),
              const SizedBox(width: 8),
              _StatusChip(
                label: 'Nofaol',
                selected: _status == UstozStatus.nofaol,
                color: AppColors.red,
                onTap: () =>
                    setState(() => _status = UstozStatus.nofaol),
              ),
            ]),
            const SizedBox(height: 20),

            // ── Buttons ──
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
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary)),
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
    hintStyle:
    const TextStyle(color: AppColors.textHint, fontSize: 13),
    filled: true,
    fillColor: const Color(0xFFF9FAFB),
    contentPadding: const EdgeInsets.symmetric(
        horizontal: 12, vertical: 12),
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

// ─── Status Chip ──────────────────────────────────────────────────────────────

class _StatusChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _StatusChip({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? color.withOpacity(0.12)
              : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(20),
          border: selected ? Border.all(color: color) : null,
        ),
        child: Text(
          label,
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? color : AppColors.textSecondary),
        ),
      ),
    );
  }
}