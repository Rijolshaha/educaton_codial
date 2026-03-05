import 'package:flutter/material.dart';
import '../../../models/book_model.dart';
import '../../../constants/app_colors.dart';

class BookEditDialog extends StatefulWidget {
  final BookModel? book;
  final void Function(BookModel) onSave;

  const BookEditDialog({super.key, this.book, required this.onSave});

  @override
  State<BookEditDialog> createState() => _BookEditDialogState();
}

class _BookEditDialogState extends State<BookEditDialog> {
  late TextEditingController _titleC;
  late TextEditingController _authorC;
  late TextEditingController _coverC;
  late TextEditingController _summaryC;
  late DateTime _startDate;
  DateTime? _endDate;
  late BookStatus _status;

  bool get _isEdit => widget.book != null;

  @override
  void initState() {
    super.initState();
    final b = widget.book;
    _titleC   = TextEditingController(text: b?.title ?? '');
    _authorC  = TextEditingController(text: b?.author ?? '');
    _coverC   = TextEditingController(text: b?.coverUrl ?? '');
    _summaryC = TextEditingController(text: b?.summary ?? '');
    _startDate = b?.startDate ?? DateTime.now();
    _endDate   = b?.endDate;
    _status    = b?.status ?? BookStatus.oqiyapman;
  }

  @override
  void dispose() {
    _titleC.dispose();
    _authorC.dispose();
    _coverC.dispose();
    _summaryC.dispose();
    super.dispose();
  }

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2,'0')}/${d.month.toString().padLeft(2,'0')}/${d.year}';

  Future<void> _pickDate({required bool isStart}) async {
    final d = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : (_endDate ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (d != null) setState(() => isStart ? _startDate = d : _endDate = d);
  }

  void _save() {
    if (_titleC.text.trim().isEmpty || _authorC.text.trim().isEmpty) return;
    final b = widget.book;
    widget.onSave(BookModel(
      id: b?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title:    _titleC.text.trim(),
      author:   _authorC.text.trim(),
      startDate: _startDate,
      endDate:   _endDate,
      status:    _status,
      coverUrl:  _coverC.text.trim().isEmpty ? null : _coverC.text.trim(),
      summary:   _summaryC.text.trim(),
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(_isEdit ? 'Kitobni Tahrirlash' : "Kitob Qo'shish",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
            ]),
            const SizedBox(height: 16),

            _label('Kitob nomi *'),
            _field(_titleC, 'Kitob nomini kiriting'),
            const SizedBox(height: 12),

            _label('Muallif *'),
            _field(_authorC, 'Muallif ismini kiriting'),
            const SizedBox(height: 12),

            // Dates
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _label('Boshlangan sana *'),
                GestureDetector(
                  onTap: () => _pickDate(isStart: true),
                  child: _dateField(_fmt(_startDate)),
                ),
              ])),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _label('Tugallangan sana'),
                GestureDetector(
                  onTap: () => _pickDate(isStart: false),
                  child: _dateField(_endDate != null ? _fmt(_endDate!) : '--/--/----'),
                ),
              ])),
            ]),
            const SizedBox(height: 12),

            _label('Holat *'),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<BookStatus>(
                  value: _status,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: BookStatus.oqiyapman, child: Text("O'qiyapman")),
                    DropdownMenuItem(value: BookStatus.tugatdim,  child: Text('Tugatdim')),
                  ],
                  onChanged: (v) { if (v != null) setState(() => _status = v); },
                ),
              ),
            ),
            const SizedBox(height: 12),

            _label('Muqova URL'),
            _field(_coverC, 'https://...'),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text("Bo'sh qoldirilsa, standart rasm qo'llaniladi",
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
            ),
            const SizedBox(height: 12),

            _label('Xulosa *'),
            TextField(
              controller: _summaryC,
              maxLines: 4,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primary)),
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
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Saqlash', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Bekor qilish', style: TextStyle(color: Colors.black54)),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _label(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(t, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
  );

  Widget _field(TextEditingController c, String hint) => TextField(
    controller: c,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary)),
    ),
  );

  Widget _dateField(String value) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(children: [
      Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
      Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey.shade500),
    ]),
  );
}