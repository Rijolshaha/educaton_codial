import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/auction_model.dart';
import '../../../services/auction_service.dart';
import '../../../constants/app_colors.dart';

class AdminAuksionPage extends StatefulWidget {
  const AdminAuksionPage({super.key});

  @override
  State<AdminAuksionPage> createState() => _AdminAuksionPageState();
}

class _AdminAuksionPageState extends State<AdminAuksionPage> {
  final _service = AuctionService();
  List<AuctionEvent> _events = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final ev = await _service.fetchAuctions();
    if (!mounted) return;
    setState(() {
      _events = ev;
      _loading = false;
    });
  }

  void _snack(String m, {bool err = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(m),
        backgroundColor: err ? AppColors.red : AppColors.greenDark,
      ),
    );
  }

  // ── Event CRUD ──────────────────────────────────────────────────────────────

  void _addEvent() => _openEventDialog();
  void _editEvent(AuctionEvent event) => _openEventDialog(event: event);

  void _deleteEvent(AuctionEvent event) {
    showDialog(
      context: context,
      builder: (_) => _ConfirmDialog(
        title: "Auksionni o'chirish",
        message: "'${event.title}' auksionini o'chirishni xohlaysizmi?",
        onConfirm: () async {
          final ok = await _service.deleteAuction(event.id);
          if (!mounted) return;
          if (ok) {
            await _load();
            _snack("Auksion o'chirildi");
          } else {
            _snack("O'chirishda xatolik", err: true);
          }
        },
      ),
    );
  }

  void _openEventDialog({AuctionEvent? event}) {
    showDialog(
      context: context,
      builder: (_) => _EventDialog(
        event: event,
        onSave: (d) async {
          final ok = event == null
              ? await _service.createAuction(
                  title: d.title,
                  description: d.description,
                  date: d.date,
                  isActive: d.isActive,
                )
              : await _service.updateAuction(
                  event.id,
                  title: d.title,
                  description: d.description,
                  date: d.date,
                  isActive: d.isActive,
                );
          if (ok && mounted) {
            await _load();
            _snack(event == null ? "Auksion qo'shildi" : 'Auksion yangilandi');
          }
          return ok;
        },
      ),
    );
  }

  // ── Product CRUD ────────────────────────────────────────────────────────────

  void _addProduct(AuctionEvent event) => _openProductDialog(event: event);
  void _editProduct(AuctionEvent event, AuctionProduct product) =>
      _openProductDialog(event: event, product: product);

  void _deleteProduct(AuctionEvent event, AuctionProduct product) {
    showDialog(
      context: context,
      builder: (_) => _ConfirmDialog(
        title: "Mahsulotni o'chirish",
        message: "'${product.title}' mahsulotini o'chirishni xohlaysizmi?",
        onConfirm: () async {
          final ok = await _service.deleteProduct(product.id);
          if (!mounted) return;
          if (ok) {
            await _load();
            _snack("Mahsulot o'chirildi");
          } else {
            _snack("O'chirishda xatolik", err: true);
          }
        },
      ),
    );
  }

  void _openProductDialog({required AuctionEvent event, AuctionProduct? product}) {
    showDialog(
      context: context,
      builder: (_) => _ProductDialog(
        product: product,
        onSave: (d) async {
          final ok = product == null
              ? await _service.createProduct(
                  auctionId: event.id,
                  name: d.name,
                  description: d.description,
                  pointCost: d.pointCost,
                  amount: d.amount,
                  image: d.image,
                )
              : await _service.updateProduct(
                  product.id,
                  auctionId: event.id,
                  name: d.name,
                  description: d.description,
                  pointCost: d.pointCost,
                  amount: d.amount,
                  image: d.image,
                );
          if (ok && mounted) {
            await _load();
            _snack(product == null
                ? "Mahsulot qo'shildi"
                : 'Mahsulot yangilandi');
          }
          return ok;
        },
      ),
    );
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _load,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
            if (_loading)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: Center(child: CircularProgressIndicator()),
                ),
              )
            else if (_events.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Column(children: [
                    Icon(Icons.calendar_month_outlined,
                        size: 52, color: Colors.grey.shade300),
                    const SizedBox(height: 12),
                    const Text('Auksionlar topilmadi',
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 14)),
                  ]),
                ),
              )
            else
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
              if (product.imageUrl != null &&
                  product.imageUrl!.isNotEmpty) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product.imageUrl!,
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 44,
                      height: 44,
                      color: const Color(0xFFF3F4F6),
                      child: const Icon(Icons.inventory_2_outlined,
                          size: 20, color: AppColors.textSecondary),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
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
              const Text('coin',
                  style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500)),
              const Spacer(),
              Text('Soni: ${product.amount}',
                  style: const TextStyle(
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

class _EventData {
  final String title;
  final String description;
  final DateTime date;
  final bool isActive;
  _EventData(this.title, this.description, this.date, this.isActive);
}

class _EventDialog extends StatefulWidget {
  final AuctionEvent? event;
  final Future<bool> Function(_EventData) onSave;

  const _EventDialog({this.event, required this.onSave});

  @override
  State<_EventDialog> createState() => _EventDialogState();
}

class _EventDialogState extends State<_EventDialog> {
  late TextEditingController _titleC;
  late TextEditingController _descC;
  late DateTime _date;
  late bool _isActive;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final e = widget.event;
    _titleC = TextEditingController(text: e?.title ?? '');
    _descC  = TextEditingController(text: e?.description ?? '');
    _date   = e?.eventDate ?? DateTime.now().add(const Duration(days: 30));
    _isActive = e?.isActive ?? true;
  }

  @override
  void dispose() {
    _titleC.dispose();
    _descC.dispose();
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

  Future<void> _save() async {
    if (_titleC.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Auksion nomini kiriting')),
      );
      return;
    }
    setState(() => _saving = true);
    final ok = await widget.onSave(_EventData(
      _titleC.text.trim(),
      _descC.text.trim(),
      _date,
      _isActive,
    ));
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context);
    } else {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saqlashda xatolik')),
      );
    }
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
                child: DropdownButton<bool>(
                  value: _isActive,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: true, child: Text('Faol')),
                    DropdownMenuItem(value: false, child: Text('Faol emas')),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => _isActive = v);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
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
                      : const Text('Saqlash',
                          style: TextStyle(fontWeight: FontWeight.w600)),
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

class _ProductData {
  final String name;
  final String description;
  final int pointCost;
  final int amount;
  final File? image;
  _ProductData(this.name, this.description, this.pointCost, this.amount, this.image);
}

class _ProductDialog extends StatefulWidget {
  final AuctionProduct? product;
  final Future<bool> Function(_ProductData) onSave;

  const _ProductDialog({this.product, required this.onSave});

  @override
  State<_ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<_ProductDialog> {
  late TextEditingController _titleC;
  late TextEditingController _descC;
  late TextEditingController _priceC;
  late TextEditingController _amountC;
  File? _image;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _titleC = TextEditingController(text: p?.title ?? '');
    _descC  = TextEditingController(text: p?.description ?? '');
    _priceC = TextEditingController(text: p != null ? '${p.startingPrice}' : '');
    _amountC = TextEditingController(text: p != null ? '${p.amount}' : '1');
  }

  @override
  void dispose() {
    _titleC.dispose();
    _descC.dispose();
    _priceC.dispose();
    _amountC.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) setState(() => _image = File(picked.path));
  }

  Future<void> _save() async {
    if (_titleC.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mahsulot nomini kiriting')),
      );
      return;
    }
    setState(() => _saving = true);
    final ok = await widget.onSave(_ProductData(
      _titleC.text.trim(),
      _descC.text.trim(),
      int.tryParse(_priceC.text.trim()) ?? 0,
      int.tryParse(_amountC.text.trim()) ?? 1,
      _image,
    ));
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context);
    } else {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saqlashda xatolik')),
      );
    }
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
            TextField(controller: _titleC, decoration: _dec('Masalan: MacBook Air M2')),
            const SizedBox(height: 12),
            _label('Tavsif'),
            TextField(
                controller: _descC,
                maxLines: 3,
                decoration: _dec('Mahsulot haqida...')),
            const SizedBox(height: 12),
            _label('Narx (coin) *'),
            TextField(
              controller: _priceC,
              keyboardType: TextInputType.number,
              decoration: _dec('Masalan: 300').copyWith(
                suffixText: 'coin',
                suffixStyle: const TextStyle(
                    color: AppColors.orange, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 12),
            _label('Soni'),
            TextField(
              controller: _amountC,
              keyboardType: TextInputType.number,
              decoration: _dec('Masalan: 1'),
            ),
            const SizedBox(height: 12),
            _label('Rasm'),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(_image!,
                            height: 90, fit: BoxFit.cover),
                      )
                    : (widget.product?.imageUrl != null &&
                            widget.product!.imageUrl!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(widget.product!.imageUrl!,
                                height: 90, fit: BoxFit.cover),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image_outlined,
                                  size: 18, color: AppColors.textSecondary),
                              SizedBox(width: 8),
                              Text('Rasm tanlash',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary)),
                            ],
                          )),
              ),
            ),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    foregroundColor: Colors.white,
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
                      : const Text('Saqlash',
                          style: TextStyle(fontWeight: FontWeight.w600)),
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

  Widget _label(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(t,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
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