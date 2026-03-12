import 'package:flutter/material.dart';
import '../../../models/auction_model.dart';
import '../../../constants/app_colors.dart';

class AdminAuksionPage extends StatefulWidget {
  const AdminAuksionPage({super.key});

  @override
  State<AdminAuksionPage> createState() => _AdminAuksionPageState();
}

class _AdminAuksionPageState extends State<AdminAuksionPage> {
  late List<AuctionEvent> _events;

  @override
  void initState() {
    super.initState();
    _events = List.from(mockAuctionEvents);
  }

  // ── Event CRUD ──────────────────────────────────────────────────────────────

  void _addEvent() {
    _openEventDialog();
  }

  void _editEvent(AuctionEvent event) {
    _openEventDialog(event: event);
  }

  void _deleteEvent(AuctionEvent event) {
    showDialog(
      context: context,
      builder: (_) => _ConfirmDialog(
        title: "Auксionni o'chirish",
        message: "'${event.title}' auксionini o'chirishni xohlaysizmi?",
        onConfirm: () => setState(() => _events.removeWhere((e) => e.id == event.id)),
      ),
    );
  }

  void _openEventDialog({AuctionEvent? event}) {
    showDialog(
      context: context,
      builder: (_) => _EventDialog(
        event: event,
        onSave: (saved) => setState(() {
          if (event == null) {
            _events.insert(0, saved);
          } else {
            final i = _events.indexWhere((e) => e.id == saved.id);
            if (i != -1) _events[i] = saved;
          }
        }),
      ),
    );
  }

  // ── Product CRUD ────────────────────────────────────────────────────────────

  void _addProduct(AuctionEvent event) {
    _openProductDialog(event: event);
  }

  void _editProduct(AuctionEvent event, AuctionProduct product) {
    _openProductDialog(event: event, product: product);
  }

  void _deleteProduct(AuctionEvent event, AuctionProduct product) {
    showDialog(
      context: context,
      builder: (_) => _ConfirmDialog(
        title: "Mahsulotni o'chirish",
        message: "'${product.title}' mahsulotini o'chirishni xohlaysizmi?",
        onConfirm: () => setState(() {
          final i = _events.indexWhere((e) => e.id == event.id);
          if (i != -1) {
            final updatedProducts = List<AuctionProduct>.from(_events[i].products)
              ..removeWhere((p) => p.id == product.id);
            _events[i] = _events[i].copyWith(products: updatedProducts);
          }
        }),
      ),
    );
  }

  void _openProductDialog({required AuctionEvent event, AuctionProduct? product}) {
    showDialog(
      context: context,
      builder: (_) => _ProductDialog(
        product: product,
        onSave: (saved) => setState(() {
          final i = _events.indexWhere((e) => e.id == event.id);
          if (i != -1) {
            final products = List<AuctionProduct>.from(_events[i].products);
            if (product == null) {
              products.add(saved);
            } else {
              final pi = products.indexWhere((p) => p.id == saved.id);
              if (pi != -1) products[pi] = saved;
            }
            _events[i] = _events[i].copyWith(products: products);
          }
        }),
      ),
    );
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.calendar_month_rounded,
                            color: AppColors.primary, size: 26),
                        SizedBox(width: 8),
                        Text('Auksionlar',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text('Auksion eventlarini boshqarish',
                        style: TextStyle(
                            fontSize: 13, color: AppColors.textSecondary)),
                    const SizedBox(height: 16),

                    // Add event button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _addEvent,
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text("Auksion Qo'shish",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Events list
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (_, i) => _EventCard(
                  event: _events[i],
                  onEdit: () => _editEvent(_events[i]),
                  onDelete: () => _deleteEvent(_events[i]),
                  onAddProduct: () => _addProduct(_events[i]),
                  onEditProduct: (p) => _editProduct(_events[i], p),
                  onDeleteProduct: (p) => _deleteProduct(_events[i], p),
                ),
                childCount: _events.length,
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }
}

// ─── Event Card ───────────────────────────────────────────────────────────────

class _EventCard extends StatelessWidget {
  final AuctionEvent event;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onAddProduct;
  final void Function(AuctionProduct) onEditProduct;
  final void Function(AuctionProduct) onDeleteProduct;

  const _EventCard({
    required this.event,
    required this.onEdit,
    required this.onDelete,
    required this.onAddProduct,
    required this.onEditProduct,
    required this.onDeleteProduct,
  });

  String _fmtDate(DateTime d) =>
      '${d.year} M${d.month.toString().padLeft(2, '0')} ${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final isKutilmoqda = event.status == AuctionStatus.kutilmoqda;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(event.title,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary)),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: isKutilmoqda
                        ? const Color(0xFFEEF2FF)
                        : const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    event.statusLabel,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isKutilmoqda
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Description
            Text(event.description,
                style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.5)),
            const SizedBox(height: 12),

            // Date / Time / Location
            _InfoRow(
                icon: Icons.calendar_month_outlined,
                text: _fmtDate(event.eventDate)),
            const SizedBox(height: 6),
            _InfoRow(
                icon: Icons.access_time_rounded,
                text:
                '${event.eventDate.hour.toString().padLeft(2, '0')}:${event.eventDate.minute.toString().padLeft(2, '0')}'),
            const SizedBox(height: 6),
            _InfoRow(
                icon: Icons.location_on_outlined, text: event.location),
            const SizedBox(height: 14),

            // Edit / Delete buttons
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined,
                      size: 16, color: Colors.white),
                  label: const Text('Tahrirlash',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: onDelete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                    minimumSize: Size.zero,
                  ),
                  child: const Icon(Icons.delete_outline,
                      color: Colors.white, size: 20),
                ),
              ],
            ),

            const Divider(height: 24, color: Color(0xFFF3F4F6)),

            // Products header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('📦', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Text(
                      'Mahsulotlar (${event.products.length})',
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: onAddProduct,
                  icon: const Icon(Icons.add, size: 16, color: Colors.white),
                  label: const Text('Mahsulot qo\'shish',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Products list
            if (event.products.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.inventory_2_outlined,
                        size: 40, color: Color(0xFFD1D5DB)),
                    SizedBox(height: 8),
                    Text("Mahsulotlar hali qo'shilmagan",
                        style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary)),
                  ],
                ),
              )
            else
              ...event.products.map((p) => _ProductCard(
                product: p,
                onEdit: () => onEditProduct(p),
                onDelete: () => onDeleteProduct(p),
              )),
          ],
        ),
      ),
    );
  }
}

// ─── Product Card ─────────────────────────────────────────────────────────────

class _ProductCard extends StatelessWidget {
  final AuctionProduct product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProductCard({
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  String _fmt(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i != 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(product.title,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary)),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: onEdit,
                    child: const Icon(Icons.edit_outlined,
                        size: 20, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: onDelete,
                    child: const Icon(Icons.delete_outline,
                        size: 20, color: AppColors.red),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(product.description,
              style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4)),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                _fmt(product.startingPrice),
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.orange),
              ),
              const SizedBox(width: 6),
              const Text('CODIAL',
                  style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Info Row ─────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(text,
            style: const TextStyle(
                fontSize: 13, color: AppColors.textSecondary)),
      ],
    );
  }
}

// ─── Confirm Dialog ───────────────────────────────────────────────────────────

class _ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;

  const _ConfirmDialog({
    required this.title,
    required this.message,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                  color: AppColors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.delete_outline,
                  color: AppColors.red, size: 26),
            ),
            const SizedBox(height: 14),
            Text(title,
                style: const TextStyle(
                    fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textSecondary, height: 1.4)),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    onConfirm();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  child: const Text("O'chirish",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    side: const BorderSide(color: Color(0xFFE5E7EB)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Bekor qilish',
                      style: TextStyle(color: AppColors.textSecondary)),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

// ─── Event Dialog ─────────────────────────────────────────────────────────────

class _EventDialog extends StatefulWidget {
  final AuctionEvent? event;
  final void Function(AuctionEvent) onSave;

  const _EventDialog({this.event, required this.onSave});

  @override
  State<_EventDialog> createState() => _EventDialogState();
}

class _EventDialogState extends State<_EventDialog> {
  late TextEditingController _titleC;
  late TextEditingController _descC;
  late TextEditingController _locC;
  late DateTime _date;
  late AuctionStatus _status;

  @override
  void initState() {
    super.initState();
    final e = widget.event;
    _titleC = TextEditingController(text: e?.title ?? '');
    _descC  = TextEditingController(text: e?.description ?? '');
    _locC   = TextEditingController(text: e?.location ?? "CODIAL Ta'lim Markazi, Toshkent");
    _date   = e?.eventDate ?? DateTime.now().add(const Duration(days: 30));
    _status = e?.status ?? AuctionStatus.kutilmoqda;
  }

  @override
  void dispose() {
    _titleC.dispose();
    _descC.dispose();
    _locC.dispose();
    super.dispose();
  }

  String _fmtDate(DateTime d) =>
      '${d.year} M${d.month.toString().padLeft(2, '0')} ${d.day.toString().padLeft(2, '0')} - ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (d != null) {
      final t = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_date),
      );
      if (t != null) {
        setState(() => _date = DateTime(d.year, d.month, d.day, t.hour, t.minute));
      }
    }
  }

  void _save() {
    if (_titleC.text.trim().isEmpty) return;
    final e = widget.event;
    widget.onSave(AuctionEvent(
      id: e?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleC.text.trim(),
      description: _descC.text.trim(),
      location: _locC.text.trim(),
      eventDate: _date,
      status: _status,
      products: e?.products ?? [],
      rules: e?.rules ?? [],
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.event != null;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(isEdit ? 'Auksionni tahrirlash' : "Auksion qo'shish",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close)),
              ],
            ),
            const SizedBox(height: 14),
            _label('Nomi *'),
            _field(_titleC, 'Auksion nomi'),
            const SizedBox(height: 12),
            _label('Tavsif'),
            TextField(
              controller: _descC,
              maxLines: 3,
              decoration: _dec('Auksion haqida qisqacha...'),
            ),
            const SizedBox(height: 12),
            _label('Manzil'),
            _field(_locC, 'Manzilni kiriting'),
            const SizedBox(height: 12),
            _label('Sana va vaqt'),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(_fmtDate(_date),
                        style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            _label('Holat'),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<AuctionStatus>(
                  value: _status,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(
                        value: AuctionStatus.kutilmoqda,
                        child: Text('Kutilmoqda')),
                    DropdownMenuItem(
                        value: AuctionStatus.yakunlangan,
                        child: Text('Yakunlangan')),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => _status = v);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  child: const Text('Saqlash',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
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

  Widget _label(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(t,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
  );

  Widget _field(TextEditingController c, String hint) => TextField(
    controller: c,
    decoration: _dec(hint),
  );

  InputDecoration _dec(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 13),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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

// ─── Product Dialog ───────────────────────────────────────────────────────────

class _ProductDialog extends StatefulWidget {
  final AuctionProduct? product;
  final void Function(AuctionProduct) onSave;

  const _ProductDialog({this.product, required this.onSave});

  @override
  State<_ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<_ProductDialog> {
  late TextEditingController _titleC;
  late TextEditingController _descC;
  late TextEditingController _priceC;
  late TextEditingController _catC;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _titleC = TextEditingController(text: p?.title ?? '');
    _descC  = TextEditingController(text: p?.description ?? '');
    _priceC = TextEditingController(text: p != null ? '${p.startingPrice}' : '');
    _catC   = TextEditingController(text: p?.category ?? '');
  }

  @override
  void dispose() {
    _titleC.dispose();
    _descC.dispose();
    _priceC.dispose();
    _catC.dispose();
    super.dispose();
  }

  void _save() {
    if (_titleC.text.trim().isEmpty) return;
    final price = int.tryParse(_priceC.text.trim()) ?? 0;
    final p = widget.product;
    widget.onSave(AuctionProduct(
      id: p?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleC.text.trim(),
      description: _descC.text.trim(),
      category: _catC.text.trim().isEmpty ? 'Boshqa' : _catC.text.trim(),
      startingPrice: price,
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.product != null;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(isEdit ? 'Mahsulotni tahrirlash' : "Mahsulot qo'shish",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close)),
              ],
            ),
            const SizedBox(height: 14),
            _label('Mahsulot nomi *'),
            _field(_titleC, 'Masalan: MacBook Air M2'),
            const SizedBox(height: 12),
            _label('Tavsif'),
            TextField(
                controller: _descC,
                maxLines: 3,
                decoration: _dec('Mahsulot haqida...')),
            const SizedBox(height: 12),
            _label('Kategoriya'),
            _field(_catC, 'Texnologiya, Audio, Aksesuar...'),
            const SizedBox(height: 12),
            _label('Narx (CODIAL coin) *'),
            TextField(
              controller: _priceC,
              keyboardType: TextInputType.number,
              decoration: _dec('Masalan: 50000').copyWith(
                suffixText: 'CODIAL',
                suffixStyle: const TextStyle(
                    color: AppColors.orange, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  child: const Text('Saqlash',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
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

  Widget _label(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(t,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
  );

  Widget _field(TextEditingController c, String hint) => TextField(
    controller: c,
    decoration: _dec(hint),
  );

  InputDecoration _dec(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 13),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.orange)),
  );
}