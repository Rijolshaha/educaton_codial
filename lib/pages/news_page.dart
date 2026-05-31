import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/app_colors.dart';
import '../models/news_model.dart';
import '../services/news_service.dart';

// ─── Role enum ────────────────────────────────────────────────────────────────

enum NewsPageRole { student, admin, owner }

// ─── Page ─────────────────────────────────────────────────────────────────────

class NewsPage extends StatefulWidget {
  final NewsPageRole pageRole;
  const NewsPage({super.key, this.pageRole = NewsPageRole.student});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final _searchController = TextEditingController();
  final _service = NewsService();
  String _query = '';
  List<NewsItem> _news = const [];
  bool _loading = true;

  bool get _canEdit =>
      widget.pageRole == NewsPageRole.admin ||
      widget.pageRole == NewsPageRole.owner;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (mounted) setState(() => _loading = true);
    final list = await _service.fetchNews();
    if (!mounted) return;
    setState(() {
      _news = list;
      _loading = false;
    });
  }

  void _snack(String msg, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: error ? AppColors.red : const Color(0xFF059669),
      behavior: SnackBarBehavior.floating,
    ));
  }

  List<NewsItem> get _filtered {
    // Pinned items first
    final list = _query.trim().isEmpty
        ? List<NewsItem>.from(_news)
        : _news.where((n) {
      final q = _query.toLowerCase();
      return n.title.toLowerCase().contains(q) ||
          n.body.toLowerCase().contains(q) ||
          n.author.toLowerCase().contains(q);
    }).toList();
    list.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return 0;
    });
    return list;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Admin / Owner actions (API) ──────────────────────────────────────────────

  void _openAddDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _NewsEditSheet(
        onSubmit: ({required title, required body, required pin, image}) =>
            _service.createNews(
                title: title, description: body, pin: pin, image: image),
      ),
    ).then((ok) {
      if (ok == true) {
        _snack("Yangilik qo'shildi");
        _load();
      }
    });
  }

  void _openEditDialog(NewsItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _NewsEditSheet(
        existing: item,
        onSubmit: ({required title, required body, required pin, image}) =>
            _service.updateNews(
                id: item.id,
                title: title,
                description: body,
                pin: pin,
                image: image),
      ),
    ).then((ok) {
      if (ok == true) {
        _snack('Yangilik saqlandi');
        _load();
      }
    });
  }

  void _deleteItem(NewsItem item) {
    showDialog(
      context: context,
      builder: (_) => _DeleteDialog(
        title: item.title,
        onConfirm: () async {
          final ok = await _service.deleteNews(item.id);
          if (ok) {
            _snack("Yangilik o'chirildi");
            _load();
          } else {
            _snack("O'chirishda xatolik", error: true);
          }
        },
      ),
    );
  }

  Future<void> _togglePin(NewsItem item) async {
    final ok = await _service.setPin(item.id, !item.isPinned);
    if (ok) {
      setState(() => item.isPinned = !item.isPinned);
    } else {
      _snack('Pin holatini o\'zgartirib bo\'lmadi', error: true);
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Yangliklar',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      )),
                  const SizedBox(height: 4),
                  const Text("Platformadagi so'nggi yangiliklar va e'lonlar",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      )),
                  const SizedBox(height: 14),

                  // Admin/Owner: "Yangilik qo'shish" button
                  if (_canEdit) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _openAddDialog,
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text("Yangilik qo'shish",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],

                  // Search
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (v) => setState(() => _query = v),
                      style: const TextStyle(
                          fontSize: 14, color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Yangliklar qidirish...',
                        hintStyle: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 14),
                        prefixIcon: const Icon(Icons.search_rounded,
                            color: AppColors.textSecondary, size: 20),
                        suffixIcon: _query.isNotEmpty
                            ? IconButton(
                          icon: const Icon(Icons.close_rounded,
                              color: AppColors.textSecondary, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                        )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // ── List ──
            Expanded(
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primary))
                  : RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: _load,
                      child: _filtered.isEmpty
                          ? ListView(
                              physics:
                                  const AlwaysScrollableScrollPhysics(),
                              children: const [
                                SizedBox(height: 80),
                                Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('🔍',
                                          style: TextStyle(fontSize: 48)),
                                      SizedBox(height: 12),
                                      Text('Hech narsa topilmadi',
                                          style: TextStyle(
                                              color:
                                                  AppColors.textSecondary,
                                              fontSize: 15)),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : ListView.separated(
                              physics:
                                  const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.fromLTRB(
                                  20, 0, 20, 24),
                              itemCount: _filtered.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (ctx, i) {
                                final item = _filtered[i];
                                return _canEdit
                                    ? _AdminNewsCard(
                                        item: item,
                                        onEdit: () =>
                                            _openEditDialog(item),
                                        onDelete: () => _deleteItem(item),
                                        onTogglePin: () =>
                                            _togglePin(item),
                                      )
                                    : _StudentNewsCard(item: item);
                              },
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Student News Card (read-only) ────────────────────────────────────────────

class _StudentNewsCard extends StatelessWidget {
  final NewsItem item;
  const _StudentNewsCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.imageUrl != null)
            Stack(
              children: [
                Image.network(
                  item.imageUrl!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _imageFallback(),
                ),
                if (item.isPinned)
                  Positioned(
                    top: 12, right: 12,
                    child: _PinnedBadge(),
                  ),
              ],
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(item.title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            height: 1.3,
                          )),
                    ),
                    if (item.isPinned && item.imageUrl == null) ...[
                      const SizedBox(width: 8),
                      _PinnedBadge(),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Text(item.body,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.5)),
                const SizedBox(height: 12),
                _MetaRow(author: item.author, role: item.role, date: item.date),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Admin News Card (with actions) ──────────────────────────────────────────

class _AdminNewsCard extends StatelessWidget {
  final NewsItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTogglePin;

  const _AdminNewsCard({
    required this.item,
    required this.onEdit,
    required this.onDelete,
    required this.onTogglePin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          if (item.imageUrl != null)
            Stack(
              children: [
                Image.network(
                  item.imageUrl!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _imageFallback(),
                ),
                if (item.isPinned)
                  Positioned(
                    top: 12, right: 12,
                    child: _PinnedBadge(),
                  ),
              ],
            ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + pin badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(item.title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            height: 1.3,
                          )),
                    ),
                    if (item.isPinned && item.imageUrl == null) ...[
                      const SizedBox(width: 8),
                      _PinnedBadge(),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Text(item.body,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.5)),
                const SizedBox(height: 12),
                _MetaRow(author: item.author, role: item.role, date: item.date),
                const SizedBox(height: 12),
                const Divider(height: 1, color: Color(0xFFF3F4F6)),
                const SizedBox(height: 12),

                // Admin action buttons
                Row(
                  children: [
                    // Pin toggle
                    Expanded(
                      child: GestureDetector(
                        onTap: onTogglePin,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: item.isPinned
                                ? const Color(0xFFFFF3E0)
                                : const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.push_pin_rounded,
                                size: 16,
                                color: item.isPinned
                                    ? const Color(0xFFFF9800)
                                    : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                item.isPinned ? 'Olib tashlash' : 'Mahkamlash',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: item.isPinned
                                      ? const Color(0xFFFF9800)
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Edit
                    GestureDetector(
                      onTap: onEdit,
                      child: Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.edit_outlined,
                            color: AppColors.primary, size: 18),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Delete
                    GestureDetector(
                      onTap: onDelete,
                      child: Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.red.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.delete_outline,
                            color: AppColors.red, size: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Meta Row (author + role badge + date) ────────────────────────────────────

class _MetaRow extends StatelessWidget {
  final String author;
  final String role;
  final String date;
  const _MetaRow({required this.author, required this.role, required this.date});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.person_outline_rounded,
                size: 15, color: AppColors.textSecondary),
            const SizedBox(width: 5),
            Text(author,
                style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500)),
            const SizedBox(width: 8),
            _RoleBadge(role: role),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Icons.calendar_today_outlined,
                size: 14, color: AppColors.textSecondary),
            const SizedBox(width: 5),
            Text(date,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textSecondary)),
          ],
        ),
      ],
    );
  }
}

// ─── Pinned Badge ─────────────────────────────────────────────────────────────

class _PinnedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.push_pin_rounded, size: 13, color: Color(0xFFFF9800)),
          SizedBox(width: 4),
          Text('Muhim',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFFF9800))),
        ],
      ),
    );
  }
}

// ─── Role Badge ───────────────────────────────────────────────────────────────

class _RoleBadge extends StatelessWidget {
  final String role;
  const _RoleBadge({required this.role});

  @override
  Widget build(BuildContext context) {
    final isAdmin = role == 'Admin';
    final isEga = role == 'Ega';
    final color = isAdmin
        ? AppColors.blue1
        : isEga
        ? AppColors.purple
        : AppColors.textSecondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(role,
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color)),
    );
  }
}

// ─── Image Fallback ───────────────────────────────────────────────────────────

Widget _imageFallback() => Container(
  height: 180,
  color: AppColors.bgCard,
  child: const Center(
      child: Icon(Icons.image_outlined,
          size: 40, color: AppColors.textSecondary)),
);

// ─── Add / Edit Bottom Sheet ──────────────────────────────────────────────────

typedef NewsSubmit = Future<bool> Function({
  required String title,
  required String body,
  required bool pin,
  File? image,
});

class _NewsEditSheet extends StatefulWidget {
  final NewsItem? existing;
  final NewsSubmit onSubmit;

  const _NewsEditSheet({this.existing, required this.onSubmit});

  @override
  State<_NewsEditSheet> createState() => _NewsEditSheetState();
}

class _NewsEditSheetState extends State<_NewsEditSheet> {
  final _formKey  = GlobalKey<FormState>();
  late TextEditingController _titleC;
  late TextEditingController _bodyC;
  late bool _isPinned;

  File? _pickedImage;
  bool _saving = false;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _titleC   = TextEditingController(text: e?.title ?? '');
    _bodyC    = TextEditingController(text: e?.body ?? '');
    _isPinned = e?.isPinned ?? false;
  }

  @override
  void dispose() {
    _titleC.dispose();
    _bodyC.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        imageQuality: 85,
      );
      if (picked != null) {
        setState(() => _pickedImage = File(picked.path));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Rasm tanlab bo\'lmadi'),
          behavior: SnackBarBehavior.floating,
        ));
      }
    }
  }

  Future<void> _save() async {
    if (_saving) return;
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final ok = await widget.onSubmit(
      title: _titleC.text.trim(),
      body: _bodyC.text.trim(),
      pin: _isPinned,
      image: _pickedImage,
    );
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context, true);
    } else {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Saqlashda xatolik yuz berdi'),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(24, 0, 24, 24 + bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Handle bar ────────────────────────────────────────────────
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 20),
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),

              // ── Header ────────────────────────────────────────────────────
              Row(
                children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: _isEdit
                          ? AppColors.blue1.withOpacity(0.1)
                          : AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      _isEdit
                          ? Icons.edit_rounded
                          : Icons.add_rounded,
                      color: _isEdit ? AppColors.blue1 : AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isEdit ? 'Yanglikni tahrirlash' : "Yangilik qo'shish",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF111827),
                          ),
                        ),
                        Text(
                          _isEdit
                              ? 'Mavjud yanglikni o\'zgartiring'
                              : 'Yangi yanglik e\'lon qiling',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.close_rounded,
                          size: 18, color: Color(0xFF374151)),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ── Sarlavha ─────────────────────────────────────────────────
              _SheetLabel(
                icon: Icons.title_rounded,
                text: 'Sarlavha',
                required: true,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleC,
                textCapitalization: TextCapitalization.sentences,
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Sarlavha kiritilmadi' : null,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
                decoration: _inputDeco('Yangilik sarlavasini kiriting...'),
              ),

              const SizedBox(height: 18),

              // ── Matn ──────────────────────────────────────────────────────
              _SheetLabel(
                icon: Icons.notes_rounded,
                text: 'Matn',
                required: true,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _bodyC,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Matn kiritilmadi' : null,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF111827),
                ),
                decoration: _inputDeco('Yangilik matnini kiriting...'),
              ),

              const SizedBox(height: 18),

              // ── Rasm ──────────────────────────────────────────────────────
              _SheetLabel(
                icon: Icons.image_outlined,
                text: 'Rasm',
                required: false,
              ),
              const SizedBox(height: 8),
              _ImagePickerField(
                pickedImage: _pickedImage,
                existingUrl: widget.existing?.imageUrl,
                onPick: _pickImage,
                onClear: () => setState(() => _pickedImage = null),
              ),

              const SizedBox(height: 18),

              // ── Muhim toggle ──────────────────────────────────────────────
              GestureDetector(
                onTap: () => setState(() => _isPinned = !_isPinned),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: _isPinned
                        ? const LinearGradient(
                      colors: [Color(0xFFFFF8E8), Color(0xFFFFF3CD)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                        : const LinearGradient(
                      colors: [Color(0xFFF9FAFB), Color(0xFFF3F4F6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _isPinned
                          ? const Color(0xFFFFB300)
                          : const Color(0xFFE5E7EB),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Custom switch
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 44, height: 26,
                        decoration: BoxDecoration(
                          color: _isPinned
                              ? const Color(0xFFFFB300)
                              : const Color(0xFFD1D5DB),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: AnimatedAlign(
                          duration: const Duration(milliseconds: 200),
                          alignment: _isPinned
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.all(3),
                            width: 20, height: 20,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x22000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.push_pin_rounded,
                          size: 18, color: Color(0xFFFFB300)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Muhim yangilik',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: _isPinned
                                    ? const Color(0xFFB45309)
                                    : const Color(0xFF374151),
                              ),
                            ),
                            Text(
                              "Tepada doim ko'rinib turadi",
                              style: TextStyle(
                                fontSize: 11,
                                color: _isPinned
                                    ? const Color(0xFFF59E0B)
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── Buttons ───────────────────────────────────────────────────
              Row(
                children: [
                  // Bekor qilish
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Center(
                          child: Text(
                            'Bekor qilish',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF374151),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Saqlash / Qo'shish
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: _saving ? null : _save,
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _isEdit
                                ? [AppColors.blue1, const Color(0xFF1D4ED8)]
                                : [AppColors.primary, AppColors.primaryDeep],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: (_isEdit
                                  ? AppColors.blue1
                                  : AppColors.primary)
                                  .withOpacity(0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: _saving
                            ? const Center(
                                child: SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _isEdit
                                        ? Icons.check_rounded
                                        : Icons.add_circle_outline_rounded,
                                    color: Colors.white, size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _isEdit ? 'Saqlash' : "Qo'shish",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),   // Column
        ),     // SingleChildScrollView
      ),       // Form
    );
  }

  InputDecoration _inputDeco(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(
        color: AppColors.textSecondary, fontSize: 13),
    contentPadding:
    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    filled: true,
    fillColor: const Color(0xFFF9FAFB),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
          color: AppColors.red.withOpacity(0.7), width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.red, width: 1.8),
    ),
    errorStyle: const TextStyle(
        fontSize: 12, color: AppColors.red),
  );
}

// ── Sheet field label ─────────────────────────────────────────────────────────

class _SheetLabel extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool required;
  const _SheetLabel({
    required this.icon,
    required this.text,
    required this.required,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF374151),
          ),
        ),
        if (required) ...[
          const SizedBox(width: 4),
          const Text('*',
              style: TextStyle(
                  color: AppColors.red,
                  fontWeight: FontWeight.w800,
                  fontSize: 14)),
        ],
      ],
    );
  }
}

// ─── Image Picker Field ───────────────────────────────────────────────────────

class _ImagePickerField extends StatelessWidget {
  final File? pickedImage;
  final String? existingUrl;
  final VoidCallback onPick;
  final VoidCallback onClear;

  const _ImagePickerField({
    required this.pickedImage,
    required this.existingUrl,
    required this.onPick,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final hasPicked = pickedImage != null;
    final hasExisting = existingUrl != null && existingUrl!.isNotEmpty;

    if (hasPicked || hasExisting) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: hasPicked
                ? Image.file(pickedImage!,
                    height: 170,
                    width: double.infinity,
                    fit: BoxFit.cover)
                : Image.network(existingUrl!,
                    height: 170,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder(onPick)),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Row(
              children: [
                _circleBtn(Icons.edit_rounded, onPick),
                if (hasPicked) ...[
                  const SizedBox(width: 6),
                  _circleBtn(Icons.close_rounded, onClear),
                ],
              ],
            ),
          ),
        ],
      );
    }

    return _placeholder(onPick);
  }

  Widget _placeholder(VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          height: 110,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: const Color(0xFFE5E7EB),
                style: BorderStyle.solid,
                width: 1.5),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_photo_alternate_outlined,
                  size: 30, color: AppColors.textSecondary),
              SizedBox(height: 6),
              Text('Galereyadan rasm tanlang',
                  style: TextStyle(
                      fontSize: 13, color: AppColors.textSecondary)),
            ],
          ),
        ),
      );

  Widget _circleBtn(IconData icon, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.55),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
      );
}

// ─── Delete Dialog ────────────────────────────────────────────────────────────

class _DeleteDialog extends StatelessWidget {
  final String title;
  final VoidCallback onConfirm;
  const _DeleteDialog({required this.title, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                color: AppColors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.delete_outline, color: AppColors.red, size: 28),
            ),
            const SizedBox(height: 16),
            const Text("Yanglikni o'chirish",
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                    fontSize: 14, color: AppColors.textSecondary),
                children: [
                  TextSpan(
                    text: '"$title"',
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary),
                  ),
                  const TextSpan(
                      text: " yangligini o'chirishni xohlaysizmi?"),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Color(0xFFE5E7EB)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Bekor qilish',
                        style: TextStyle(color: AppColors.textSecondary)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      onConfirm();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text("O'chirish",
                        style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}