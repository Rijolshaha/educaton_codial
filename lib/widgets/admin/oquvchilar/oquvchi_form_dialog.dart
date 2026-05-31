import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../constants/app_colors.dart';
import '../../../../models/student_model.dart';
import '../../../../models/guruh_model.dart';
import '../../../../services/group_service.dart';
import '../../../models/oquvchi_admin_model.dart';

/// Formadan qaytadigan natija (API uchun).
class OquvchiFormResult {
  final String username;
  final String password;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String bio;
  final int point;
  final String? groupId;
  final File? image;

  OquvchiFormResult({
    required this.username,
    required this.password,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.bio,
    required this.point,
    required this.groupId,
    required this.image,
  });
}

class OquvchiFormDialog extends StatefulWidget {
  final StudentModel? student;

  /// `true` qaytarsa — dialog yopiladi.
  final Future<bool> Function(OquvchiFormResult) onSave;

  const OquvchiFormDialog({
    super.key,
    this.student,
    required this.onSave,
  });

  @override
  State<OquvchiFormDialog> createState() => _OquvchiFormDialogState();
}

class _OquvchiFormDialogState extends State<OquvchiFormDialog> {
  late TextEditingController _nameC;
  late TextEditingController _emailC;
  late TextEditingController _coinsC;
  late TextEditingController _phoneC;
  late TextEditingController _bioC;
  late TextEditingController _userC;
  late TextEditingController _passC;

  List<AdminGuruh> _groups = const [];
  String? _groupId;
  File? _image;
  bool _loadingRefs = true;
  bool _saving = false;

  bool get _isEdit => widget.student != null;

  @override
  void initState() {
    super.initState();
    final s = widget.student;
    _nameC = TextEditingController(text: s?.name ?? '');
    _emailC = TextEditingController(text: s?.email ?? '');
    _coinsC = TextEditingController(text: s != null ? '${s.coins}' : '');
    _phoneC = TextEditingController(text: s?.phone ?? '');
    _bioC = TextEditingController(text: s?.bio ?? '');
    _userC = TextEditingController();
    _passC = TextEditingController();
    _groupId = (s?.groupId.isNotEmpty ?? false) ? s!.groupId : null;
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    final groups = await GroupService().fetchGroups();
    if (!mounted) return;
    setState(() {
      _groups = groups;
      if (_groupId != null && !_groups.any((g) => g.id == _groupId)) {
        _groupId = null;
      }
      _loadingRefs = false;
    });
  }

  @override
  void dispose() {
    _nameC.dispose();
    _emailC.dispose();
    _coinsC.dispose();
    _phoneC.dispose();
    _bioC.dispose();
    _userC.dispose();
    _passC.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) setState(() => _image = File(picked.path));
  }

  Future<void> _save() async {
    final name = _nameC.text.trim();
    if (name.isEmpty) {
      _err('Ism familiyani kiriting');
      return;
    }
    if (!_isEdit) {
      if (_userC.text.trim().isEmpty || _passC.text.trim().isEmpty) {
        _err('Username va parolni kiriting');
        return;
      }
    }
    final parts = name.split(RegExp(r'\s+'));
    final firstName = parts.first;
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    final coins = int.tryParse(_coinsC.text.trim()) ?? 0;

    setState(() => _saving = true);
    final ok = await widget.onSave(OquvchiFormResult(
      username: _userC.text.trim(),
      password: _passC.text.trim(),
      email: _emailC.text.trim(),
      firstName: firstName,
      lastName: lastName,
      phone: _phoneC.text.trim(),
      bio: _bioC.text.trim(),
      point: coins,
      groupId: _groupId,
      image: _image,
    ));
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context);
    } else {
      setState(() => _saving = false);
      _err('Saqlashda xatolik. Qaytadan urinib ko\'ring.');
    }
  }

  void _err(String m) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(m), backgroundColor: AppColors.red),
      );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isEdit ? "O'quvchini tahrirlash" : "O'quvchi qo'shish",
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close_rounded,
                      color: AppColors.textSecondary),
                ),
              ],
            ),
            const Divider(height: 20, color: Color(0xFFE5E7EB)),

            if (_loadingRefs)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Center(child: CircularProgressIndicator()),
              )
            else ...[
              // Avatar (faqat tahrirda yuklash mumkin)
              if (_isEdit) ...[
                Center(child: _avatarPreview()),
                const SizedBox(height: 6),
                Center(
                  child: TextButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.photo_camera_outlined, size: 18),
                    label: const Text('Rasm tanlash'),
                  ),
                ),
                const SizedBox(height: 8),
              ],

              // Username + parol (faqat yangi)
              if (!_isEdit) ...[
                _lbl('Username *'),
                TextField(
                  controller: _userC,
                  autocorrect: false,
                  enableSuggestions: false,
                  textCapitalization: TextCapitalization.none,
                  decoration: _dec('Masalan: abbos2024'),
                ),
                const SizedBox(height: 12),
                _lbl('Parol *'),
                TextField(
                  controller: _passC,
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: _dec('Parol'),
                ),
                const SizedBox(height: 12),
              ],

              _lbl('Ism Familiya *'),
              TextField(
                controller: _nameC,
                decoration: _dec('Masalan: Abbos Qodirov'),
              ),
              const SizedBox(height: 12),

              // Email — faqat yangida o'zgartiriladi
              if (!_isEdit) ...[
                _lbl('Email'),
                TextField(
                  controller: _emailC,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  enableSuggestions: false,
                  textCapitalization: TextCapitalization.none,
                  decoration: _dec('Masalan: abbos@codial.uz'),
                ),
                const SizedBox(height: 12),
              ],

              _lbl('Guruh'),
              _dropBox(
                DropdownButtonHideUnderline(
                  child: DropdownButton<String?>(
                    value: _groupId,
                    isExpanded: true,
                    hint: const Text('Tanlanmagan',
                        style: TextStyle(
                            fontSize: 13, color: AppColors.textHint)),
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('Tanlanmagan',
                            style: TextStyle(fontSize: 13)),
                      ),
                      ..._groups.map((g) => DropdownMenuItem<String?>(
                            value: g.id,
                            child: Row(children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: oquvchiGroupColor(g.nomi),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(g.nomi,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 13)),
                              ),
                            ]),
                          )),
                    ],
                    onChanged: (v) => setState(() => _groupId = v),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              _lbl('Coinlar'),
              TextField(
                controller: _coinsC,
                keyboardType: TextInputType.number,
                decoration: _dec('Masalan: 3450'),
              ),
              const SizedBox(height: 12),

              _lbl('Telefon'),
              TextField(
                controller: _phoneC,
                keyboardType: TextInputType.phone,
                decoration: _dec('Masalan: +998901234567'),
              ),
              const SizedBox(height: 12),

              _lbl('Bio'),
              TextField(
                controller: _bioC,
                maxLines: 2,
                decoration: _dec('Qisqacha...'),
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
                    onPressed: _saving ? null : () => Navigator.pop(context),
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
          ],
        ),
      ),
    );
  }

  Widget _avatarPreview() {
    final url = widget.student?.avatarUrl;
    if (_image != null) {
      return CircleAvatar(radius: 36, backgroundImage: FileImage(_image!));
    }
    if (url != null && url.isNotEmpty) {
      return CircleAvatar(radius: 36, backgroundImage: NetworkImage(url));
    }
    return CircleAvatar(
      radius: 36,
      backgroundColor: AppColors.primary.withOpacity(0.15),
      child: const Text('🧑', style: TextStyle(fontSize: 30)),
    );
  }

  Widget _lbl(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(t,
            style:
                const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
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
        hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 13),
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
