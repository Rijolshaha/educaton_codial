import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../constants/app_colors.dart';
import '../../../../models/ustoz_model.dart';
import '../../../../models/kurs_model.dart';
import '../../../../services/course_service.dart';

/// Forma natijasi — sahifaga qaytariladi.
class UstozFormResult {
  final String username;
  final String password;
  final String email;
  final String kurs; // backend `direction`
  final String bio;
  final File? avatar;

  const UstozFormResult({
    required this.username,
    required this.password,
    required this.email,
    required this.kurs,
    required this.bio,
    this.avatar,
  });
}

class UstozFormDialog extends StatefulWidget {
  final UstozModel? ustoz;

  /// Saqlashni bajaradi (API). `true` qaytsa — dialog yopiladi.
  final Future<bool> Function(UstozFormResult) onSave;

  const UstozFormDialog({
    super.key,
    this.ustoz,
    required this.onSave,
  });

  @override
  State<UstozFormDialog> createState() => _UstozFormDialogState();
}

class _UstozFormDialogState extends State<UstozFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameC;
  late TextEditingController _passwordC;
  late TextEditingController _emailC;
  late TextEditingController _bioC;

  String? _kurs;
  List<String> _kurslar = List.from(ustozKurslar);
  bool _obscure = true;
  bool _saving = false;
  File? _avatar;

  bool get _isEdit => widget.ustoz != null;

  @override
  void initState() {
    super.initState();
    final u = widget.ustoz;
    _usernameC = TextEditingController(text: u?.ism ?? '');
    _passwordC = TextEditingController();
    _emailC = TextEditingController(text: u?.email ?? '');
    _bioC = TextEditingController(text: u?.bio ?? '');
    _kurs = (u?.kurs.isNotEmpty ?? false) ? u!.kurs : null;
    _ensureKursInList();
    _loadKurslar();
  }

  void _ensureKursInList() {
    if (_kurs != null && _kurs!.isNotEmpty && !_kurslar.contains(_kurs)) {
      _kurslar = [_kurs!, ..._kurslar];
    }
  }

  Future<void> _loadKurslar() async {
    final courses = await CourseService().fetchCourses();
    if (!mounted) return;
    final names = courses
        .map((c) => c.nomi)
        .where((n) => n.trim().isNotEmpty)
        .toSet()
        .toList();
    if (names.isEmpty) return;
    setState(() {
      _kurslar = names;
      _ensureKursInList();
      _kurs ??= _kurslar.first;
    });
  }

  @override
  void dispose() {
    _usernameC.dispose();
    _passwordC.dispose();
    _emailC.dispose();
    _bioC.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        imageQuality: 85,
      );
      if (picked != null) setState(() => _avatar = File(picked.path));
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
    final ok = await widget.onSave(UstozFormResult(
      username: _usernameC.text.trim(),
      password: _passwordC.text,
      email: _emailC.text.trim(),
      kurs: _kurs ?? '',
      bio: _bioC.text.trim(),
      avatar: _avatar,
    ));
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context);
    } else {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Saqlab bo\'lmadi. Qayta urinib ko\'ring.'),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  DecorationImage? _avatarImage() {
    if (_avatar != null) {
      return DecorationImage(image: FileImage(_avatar!), fit: BoxFit.cover);
    }
    final url = widget.ustoz?.avatarUrl;
    if (url != null && url.isNotEmpty) {
      return DecorationImage(image: NetworkImage(url), fit: BoxFit.cover);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Title ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isEdit ? 'Ustozni tahrirlash' : "Ustoz qo'shish",
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

              // ── Avatar (faqat tahrirlashda yuklanadi) ──
              if (_isEdit) ...[
                Center(
                  child: GestureDetector(
                    onTap: _pickAvatar,
                    child: Stack(children: [
                      Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: const Color(0xFFE5E7EB), width: 2),
                          image: _avatarImage(),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: _avatarImage() == null
                            ? const Icon(Icons.person_outline_rounded,
                                size: 34, color: AppColors.textHint)
                            : null,
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.camera_alt_rounded,
                              size: 13, color: Colors.white),
                        ),
                      ),
                    ]),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // ── Username ──
              _lbl('Foydalanuvchi nomi *'),
              _field(
                controller: _usernameC,
                hint: 'masalan: otabek',
                validator: (v) {
                  final s = v?.trim() ?? '';
                  if (s.isEmpty) return 'Foydalanuvchi nomi kiritilmadi';
                  if (!RegExp(r'^[\w.@+-]+$').hasMatch(s)) {
                    return 'Faqat harf, raqam va @.+-_ belgilari';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // ── Parol (faqat yangi ustoz) ──
              if (!_isEdit) ...[
                _lbl('Parol *'),
                _field(
                  controller: _passwordC,
                  hint: 'Parol kiriting',
                  obscureText: _obscure,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'Parol kiritilmadi'
                      : null,
                ),
                const SizedBox(height: 12),
              ],

              // ── Email ──
              _lbl('Email'),
              _field(
                controller: _emailC,
                hint: 'masalan: otabek@codial.uz',
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  final s = v?.trim() ?? '';
                  if (s.isNotEmpty && !s.contains('@')) {
                    return "Email noto'g'ri";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // ── Kurs (direction) ──
              _lbl("Yo'nalish (kurs)"),
              _dropBox(
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _kurs,
                    isExpanded: true,
                    hint: const Text('Yo\'nalishni tanlang',
                        style: TextStyle(fontSize: 13)),
                    items: _kurslar
                        .map((k) => DropdownMenuItem(
                              value: k,
                              child: Row(children: [
                                Icon(ustozKursIcon(k),
                                    size: 16, color: ustozKursColor(k)),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(k,
                                      style: const TextStyle(fontSize: 13),
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ]),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _kurs = v),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // ── Bio (faqat tahrirlashda) ──
              if (_isEdit) ...[
                _lbl("Bio (qisqacha ma'lumot)"),
                _field(
                  controller: _bioC,
                  hint: 'Ustoz haqida...',
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 8),

              // ── Buttons ──
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
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: _saving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : Text(
                            _isEdit ? 'Saqlash' : "Qo'shish",
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed:
                        _saving ? null : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Color(0xFFE5E7EB)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Bekor',
                        style: TextStyle(color: AppColors.textSecondary)),
                  ),
                ),
              ]),
            ],
          ),
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

  Widget _field({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1,
    bool obscureText = false,
    Widget? suffixIcon,
  }) =>
      TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        maxLines: obscureText ? 1 : maxLines,
        obscureText: obscureText,
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          suffixIcon: suffixIcon,
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
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.red)),
          errorStyle: const TextStyle(fontSize: 11, color: AppColors.red),
        ),
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
}
