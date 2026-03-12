import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../models/kurs_model.dart';

class KursFormDialog extends StatefulWidget {
  final KursModel? kurs;
  final void Function(KursModel) onSave;

  const KursFormDialog({
    super.key,
    this.kurs,
    required this.onSave,
  });

  @override
  State<KursFormDialog> createState() => _KursFormDialogState();
}

class _KursFormDialogState extends State<KursFormDialog> {
  late TextEditingController _nomiC;
  late TextEditingController _tavsifC;
  late KursIconOption _belgi;
  late KursRangOption _rang;
  late KursStatus _status;

  @override
  void initState() {
    super.initState();
    final k = widget.kurs;
    _nomiC   = TextEditingController(text: k?.nomi ?? '');
    _tavsifC = TextEditingController(text: k?.tavsif ?? '');
    _belgi   = k?.belgi  ?? kursIconOptions[0];
    _rang    = k?.rang   ?? kursRangOptions[0];
    _status  = k?.status ?? KursStatus.faol;
  }

  @override
  void dispose() {
    _nomiC.dispose();
    _tavsifC.dispose();
    super.dispose();
  }

  void _save() {
    if (_nomiC.text.trim().isEmpty) return;
    final k = widget.kurs;
    widget.onSave(KursModel(
      id: k?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      nomi: _nomiC.text.trim(),
      tavsif: _tavsifC.text.trim(),
      belgi: _belgi,
      rang: _rang,
      status: _status,
      oqituvchilar: k?.oqituvchilar ?? 0,
      guruhlar: k?.guruhlar ?? 0,
      oquvchilar: k?.oquvchilar ?? 0,
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.kurs != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
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
                  isEdit ? "Kurs Ma'lumotlari" : "Kurs Qo'shish",
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

            // ── Kurs Nomi ──
            _lbl('Kurs Nomi'),
            TextField(
              controller: _nomiC,
              decoration: _dec('Masalan: Backend'),
            ),
            const SizedBox(height: 14),

            // ── Tavsif ──
            _lbl('Tavsif'),
            TextField(
              controller: _tavsifC,
              maxLines: 3,
              decoration: _dec('Kurs haqida qisqacha...'),
            ),
            const SizedBox(height: 14),

            // ── Belgi ──
            _lbl('Belgi'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: kursIconOptions.map((opt) {
                final sel = opt.icon == _belgi.icon;
                return GestureDetector(
                  onTap: () => setState(() => _belgi = opt),
                  child: Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      color: sel
                          ? AppColors.primary.withOpacity(0.12)
                          : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(10),
                      border: sel
                          ? Border.all(
                          color: AppColors.primary, width: 2)
                          : null,
                    ),
                    child: Icon(
                      opt.icon,
                      color: sel
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      size: 22,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 4),
            Text(_belgi.label,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 14),

            // ── Rang ──
            _lbl('Rang'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: kursRangOptions.map((opt) {
                final sel = opt.label == _rang.label;
                return GestureDetector(
                  onTap: () => setState(() => _rang = opt),
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [opt.color1, opt.color2],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      border: sel
                          ? Border.all(
                          color: Colors.white, width: 2.5)
                          : null,
                      boxShadow: sel
                          ? [
                        BoxShadow(
                          color:
                          opt.color1.withOpacity(0.5),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ]
                          : null,
                    ),
                    child: sel
                        ? const Icon(Icons.check_rounded,
                        color: Colors.white, size: 18)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 4),
            Text(_rang.label,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 14),

            // ── Status ──
            _lbl('Status'),
            Row(children: [
              _StatusChip(
                label: 'Faol',
                selected: _status == KursStatus.faol,
                color: AppColors.greenDark,
                onTap: () =>
                    setState(() => _status = KursStatus.faol),
              ),
              const SizedBox(width: 8),
              _StatusChip(
                label: 'Nofaol',
                selected: _status == KursStatus.nofaol,
                color: AppColors.red,
                onTap: () =>
                    setState(() => _status = KursStatus.nofaol),
              ),
            ]),
            const SizedBox(height: 20),

            // ── Save button ──
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text(
                  isEdit ? 'Yopish' : 'Saqlash',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ),
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

  InputDecoration _dec(String hint) => InputDecoration(
    hintText: hint,
    hintStyle:
    const TextStyle(color: AppColors.textHint, fontSize: 13),
    filled: true,
    fillColor: const Color(0xFFF9FAFB),
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