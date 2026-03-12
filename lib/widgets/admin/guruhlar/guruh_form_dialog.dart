import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../models/guruh_model.dart';

class GuruhFormDialog extends StatefulWidget {
  final AdminGuruh? guruh;
  final void Function(AdminGuruh) onSave;

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
  late String _ustoz;
  late String _kurs;
  late JadvalTuri _jadval;
  late GuruhStatus _status;

  @override
  void initState() {
    super.initState();
    final g = widget.guruh;
    _nomiC  = TextEditingController(text: g?.nomi ?? '');
    _ustoz  = g?.ustoz  ?? allUstozlar.first;
    _kurs   = g?.kurs   ?? allKurslar.first;
    _jadval = g?.jadval ?? JadvalTuri.jadvalA;
    _status = g?.status ?? GuruhStatus.faol;
  }

  @override
  void dispose() {
    _nomiC.dispose();
    super.dispose();
  }

  void _save() {
    if (_nomiC.text.trim().isEmpty) return;
    final g = widget.guruh;
    widget.onSave(AdminGuruh(
      id: g?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      nomi: _nomiC.text.trim(),
      yaratilganSana: g?.yaratilganSana ??
          DateTime.now().toString().substring(0, 10),
      ustoz: _ustoz,
      kurs: _kurs,
      jadval: _jadval,
      status: _status,
      oquvchilar: g?.oquvchilar ?? 0,
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.guruh != null;

    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
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
                  isEdit ? 'Guruhni tahrirlash' : "Guruh qo'shish",
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

            // Ustoz
            _lbl('Ustoz'),
            _dropStr(
              value: _ustoz,
              items: allUstozlar.toList(),
              onChanged: (v) => setState(() => _ustoz = v!),
            ),
            const SizedBox(height: 12),

            // Kurs
            _lbl('Kurs'),
            _dropStr(
              value: _kurs,
              items: allKurslar.toList(),
              onChanged: (v) => setState(() => _kurs = v!),
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
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding:
                    const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  child: const Text('Saqlash',
                      style:
                      TextStyle(fontWeight: FontWeight.w600)),
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
                        borderRadius: BorderRadius.circular(10)),
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
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(t,
        style: const TextStyle(
            fontSize: 13, fontWeight: FontWeight.w600)),
  );

  Widget _dropStr({
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) =>
      _dropBox(
        DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            items: items
                .map((v) => DropdownMenuItem(
                value: v,
                child: Text(v,
                    style: const TextStyle(fontSize: 13))))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      );

  Widget _dropBox(Widget child) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      border:
      Border.all(color: const Color(0xFFE5E7EB)),
      borderRadius: BorderRadius.circular(10),
    ),
    child: child,
  );

  InputDecoration _dec(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(
        color: AppColors.textHint, fontSize: 13),
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