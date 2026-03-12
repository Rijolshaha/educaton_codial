import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../models/owner_admin_model.dart';

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
  late final TextEditingController _emailCtrl;
  late final TextEditingController _lavozimCtrl;

  bool get _isEdit => widget.admin != null;

  @override
  void initState() {
    super.initState();
    _ismCtrl     = TextEditingController(text: widget.admin?.ism);
    _emailCtrl   = TextEditingController(text: widget.admin?.email);
    _lavozimCtrl = TextEditingController(text: widget.admin?.lavozim);
  }

  @override
  void dispose() {
    _ismCtrl.dispose();
    _emailCtrl.dispose();
    _lavozimCtrl.dispose();
    super.dispose();
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(context, {
      'ism':     _ismCtrl.text.trim(),
      'email':   _emailCtrl.text.trim(),
      'lavozim': _lavozimCtrl.text.trim(),
    });
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

              // ── To'liq ism ──
              _FieldLabel(text: "To'liq ism *"),
              const SizedBox(height: 6),
              _FormField(
                controller: _ismCtrl,
                hint: 'Ism familiyani kiriting',
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Ism kiritilmadi'
                    : null,
              ),
              const SizedBox(height: 14),

              // ── Email ──
              const _FieldLabel(text: 'Email *'),
              const SizedBox(height: 6),
              _FormField(
                controller: _emailCtrl,
                hint: 'email@codial.uz',
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Email kiritilmadi';
                  }
                  if (!v.contains('@')) return "Email noto'g'ri";
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

  const _FormField({
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
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