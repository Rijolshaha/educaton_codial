import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../constants/app_colors.dart';
import '../../../models/owner_admin_model.dart';

/// Form natijasi — sahifaga qaytariladi.
class OwnerAdminFormResult {
  final String ism;
  final String username;
  final String password;
  final String email;
  final String lavozim;
  final File? avatar;

  const OwnerAdminFormResult({
    required this.ism,
    required this.username,
    required this.password,
    required this.email,
    required this.lavozim,
    this.avatar,
  });
}

class OwnerAdminFormDialog extends StatefulWidget {
  final OwnerAdminModel? admin; // null = yangi, not-null = tahrirlash

  const OwnerAdminFormDialog({super.key, this.admin});

  @override
  State<OwnerAdminFormDialog> createState() =>
      _OwnerAdminFormDialogState();
}

class _OwnerAdminFormDialogState
    extends State<OwnerAdminFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _ismCtrl;
  late final TextEditingController _usernameCtrl;
  late final TextEditingController _passwordCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _lavozimCtrl;

  bool _obscure = true;
  File? _avatar;

  bool get _isEdit => widget.admin != null;

  @override
  void initState() {
    super.initState();
    _ismCtrl      = TextEditingController(text: widget.admin?.ism);
    _usernameCtrl = TextEditingController();
    _passwordCtrl = TextEditingController();
    _emailCtrl    = TextEditingController(text: widget.admin?.email);
    _lavozimCtrl  = TextEditingController(text: widget.admin?.lavozim);
  }

  @override
  void dispose() {
    _ismCtrl.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    _emailCtrl.dispose();
    _lavozimCtrl.dispose();
    super.dispose();
  }

  DecorationImage? _avatarImage() {
    if (_avatar != null) {
      return DecorationImage(image: FileImage(_avatar!), fit: BoxFit.cover);
    }
    final url = widget.admin?.avatarUrl;
    if (url != null && url.isNotEmpty) {
      return DecorationImage(image: NetworkImage(url), fit: BoxFit.cover);
    }
    return null;
  }

  Future<void> _pickAvatar() async {
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        imageQuality: 85,
      );
      if (picked != null) {
        setState(() => _avatar = File(picked.path));
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

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      OwnerAdminFormResult(
        ism: _ismCtrl.text.trim(),
        username: _usernameCtrl.text.trim(),
        password: _passwordCtrl.text,
        email: _emailCtrl.text.trim(),
        lavozim: _lavozimCtrl.text.trim(),
        avatar: _avatar,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 40),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isEdit
                        ? 'Adminni Tahrirlash'
                        : 'Yangi Admin',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded,
                        size: 20,
                        color: AppColors.textSecondary),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Divider(color: Color(0xFFF3F4F6)),
              const SizedBox(height: 16),

              // ── Avatar (rasm) ──
              Center(
                child: GestureDetector(
                  onTap: _pickAvatar,
                  child: Stack(
                    children: [
                      Container(
                        width: 84,
                        height: 84,
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
                                size: 36, color: AppColors.textHint)
                            : null,
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.camera_alt_rounded,
                              size: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              if (_isEdit) ...[
                // ── To'liq ism (tahrirlash) ──
                const _FieldLabel(text: "To'liq ism *"),
                const SizedBox(height: 6),
                _FormField(
                  controller: _ismCtrl,
                  hint: 'Ism familiyani kiriting',
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Ism kiritilmadi'
                      : null,
                ),
                const SizedBox(height: 14),
              ] else ...[
                // ── Foydalanuvchi nomi (yangi admin) ──
                const _FieldLabel(text: 'Foydalanuvchi nomi *'),
                const SizedBox(height: 6),
                _FormField(
                  controller: _usernameCtrl,
                  hint: 'masalan: robiya_admin',
                  validator: (v) {
                    final s = v?.trim() ?? '';
                    if (s.isEmpty) return 'Foydalanuvchi nomi kiritilmadi';
                    if (!RegExp(r'^[\w.@+-]+$').hasMatch(s)) {
                      return "Faqat harf, raqam va @.+-_ belgilari";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // ── Parol (yangi admin) ──
                const _FieldLabel(text: 'Parol *'),
                const SizedBox(height: 6),
                _FormField(
                  controller: _passwordCtrl,
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
                const SizedBox(height: 14),
              ],

              // ── Email ──
              const _FieldLabel(text: 'Email'),
              const SizedBox(height: 6),
              _FormField(
                controller: _emailCtrl,
                hint: 'email@codial.uz',
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  final s = v?.trim() ?? '';
                  if (s.isNotEmpty && !s.contains('@')) {
                    return "Email noto'g'ri";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // ── Lavozim ──
              const _FieldLabel(text: "Qisqacha ma'lumot"),
              const SizedBox(height: 6),
              _FormField(
                controller: _lavozimCtrl,
                hint: 'Lavozim yoki vazifasini kiriting',
                maxLines: 2,
              ),
              const SizedBox(height: 24),

              // ── Buttons ──
              Row(children: [
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
                    child: const Text(
                      'Bekor qilish',
                      style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding:
                      const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      'Saqlash',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Field Label ──────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary),
  );
}

// ─── Form Field ───────────────────────────────────────────────────────────────

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool obscureText;
  final Widget? suffixIcon;

  const _FormField({
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines = 1,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
        hintStyle: const TextStyle(
            color: AppColors.textHint,
            fontSize: 13,
            fontWeight: FontWeight.w400),
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
          const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
          const BorderSide(color: AppColors.red, width: 1.5),
        ),
        errorStyle: const TextStyle(
            fontSize: 11, color: AppColors.red),
      ),
    );
  }
}