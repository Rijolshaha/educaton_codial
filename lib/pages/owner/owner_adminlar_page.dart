import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/owner/adminlar/owner_admin_stat_card.dart';
import '../../../widgets/owner/adminlar/owner_admin_card.dart';
import '../../../widgets/owner/adminlar/owner_admin_form_dialog.dart';
import '../../../widgets/owner/adminlar/owner_admin_confirm_dialog.dart';
import '../../../services/owner_service.dart';
import '../../models/owner_admin_model.dart';

class OwnerAdminlarPage extends StatefulWidget {
  const OwnerAdminlarPage({super.key});

  @override
  State<OwnerAdminlarPage> createState() => _OwnerAdminlarPageState();
}

class _OwnerAdminlarPageState extends State<OwnerAdminlarPage> {
  final OwnerService _service = OwnerService();
  List<OwnerAdminModel> _adminlar = [];
  bool _loading = true;

  int get _faolCount   => _adminlar.where((a) => a.isFaol).length;
  int get _nofaolCount => _adminlar.where((a) => !a.isFaol).length;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final list = await _service.fetchAdmins();
    if (!mounted) return;
    setState(() {
      _adminlar = list;
      _loading = false;
    });
  }

  void _snack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: error ? AppColors.red : const Color(0xFF059669),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    ));
  }

  Future<void> _toggleStatus(OwnerAdminModel admin) async {
    final newStatus =
        admin.isFaol ? OwnerAdminStatus.nofaol : OwnerAdminStatus.faol;
    final ok = await _service.setStatus(admin.id, newStatus);
    if (!mounted) return;
    if (!ok) {
      _snack("Holatni o'zgartirib bo'lmadi", error: true);
      return;
    }
    setState(() {
      final idx = _adminlar.indexOf(admin);
      if (idx != -1) _adminlar[idx] = admin.copyWith(status: newStatus);
    });
  }

  Future<void> _showAddDialog() async {
    final result = await showDialog<OwnerAdminFormResult>(
      context: context,
      builder: (_) => const OwnerAdminFormDialog(),
    );
    if (result == null) return;
    final ok = await _service.createAdmin(
      username: result.username,
      password: result.password,
      email: result.email,
      lavozim: result.lavozim,
      avatar: result.avatar,
    );
    if (!mounted) return;
    if (!ok) {
      _snack("Admin qo'shilmadi", error: true);
      return;
    }
    _snack("Admin qo'shildi ✅");
    await _load(); // yangi admin id'si server'dan keladi
  }

  Future<void> _showEditDialog(OwnerAdminModel admin) async {
    final result = await showDialog<OwnerAdminFormResult>(
      context: context,
      builder: (_) => OwnerAdminFormDialog(admin: admin),
    );
    if (result == null) return;
    final ok = await _service.updateAdmin(
      admin.id,
      ism: result.ism,
      email: result.email,
      lavozim: result.lavozim,
      avatar: result.avatar,
    );
    if (!mounted) return;
    if (!ok) {
      _snack("Tahrirlab bo'lmadi", error: true);
      return;
    }
    _snack("O'zgarishlar saqlandi ✅");
    await _load(); // yangilangan ma'lumot (avatar URL) server'dan keladi
  }

  Future<void> _showDeleteDialog(OwnerAdminModel admin) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => OwnerAdminConfirmDialog(admin: admin),
    );
    if (confirmed != true) return;
    final ok = await _service.deleteAdmin(admin.id);
    if (!mounted) return;
    if (!ok) {
      _snack("O'chirib bo'lmadi", error: true);
      return;
    }
    setState(() => _adminlar.remove(admin));
    _snack("Admin o'chirildi");
  }

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded,
              color: Color(0xFF111827)),
        ),
        title: Text(
          'Adminlar',
          style: TextStyle(
              fontSize: r.fontLg,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF111827)),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFF3F4F6)),
        ),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator(color: AppColors.primary))
          : CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(r.padH, r.padV, r.padH, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Title row ──
                  Row(children: [
                    Container(
                      width: r.avatarSm,
                      height: r.avatarSm,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(r.radiusMd),
                      ),
                      child: Icon(Icons.shield_outlined,
                          color: AppColors.primary, size: r.iconMd),
                    ),
                    SizedBox(width: r.gapMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Adminlar Boshqaruvi',
                            style: TextStyle(
                                fontSize: r.fontXl,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary),
                          ),
                          Text(
                            'Tizim administratorlari va ularning huquqlari',
                            style: TextStyle(
                                fontSize: r.fontXs,
                                color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ]),
                  SizedBox(height: r.gapMd),

                  // ── + Yangi Admin ──
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _showAddDialog,
                      icon: Icon(Icons.add_rounded,
                          color: Colors.white, size: r.iconSm),
                      label: Text(
                        'Yangi Admin',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: r.fontMd),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(vertical: r.gapMd),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(r.radiusMd)),
                      ),
                    ),
                  ),
                  SizedBox(height: r.gapMd),

                  // ── Stat cards:
                  // phone → vertikal list, tablet+ → 3 ustun row ──
                  if (r.isPhone) ...[
                    OwnerAdminStatCard(
                      icon: Icons.shield_outlined,
                      iconColor: AppColors.primary,
                      iconBg: AppColors.primary.withOpacity(0.1),
                      count: _adminlar.length,
                      label: 'Jami Adminlar',
                    ),
                    OwnerAdminStatCard(
                      icon: Icons.check_circle_outline_rounded,
                      iconColor: const Color(0xFF059669),
                      iconBg: const Color(0xFFECFDF5),
                      count: _faolCount,
                      label: 'Faol Adminlar',
                    ),
                    OwnerAdminStatCard(
                      icon: Icons.cancel_outlined,
                      iconColor: AppColors.red,
                      iconBg: AppColors.red.withOpacity(0.08),
                      count: _nofaolCount,
                      label: 'Nofaol Adminlar',
                    ),
                  ] else
                    Row(children: [
                      Expanded(
                        child: OwnerAdminStatCard(
                          icon: Icons.shield_outlined,
                          iconColor: AppColors.primary,
                          iconBg: AppColors.primary.withOpacity(0.1),
                          count: _adminlar.length,
                          label: 'Jami Adminlar',
                        ),
                      ),
                      SizedBox(width: r.gapMd),
                      Expanded(
                        child: OwnerAdminStatCard(
                          icon: Icons.check_circle_outline_rounded,
                          iconColor: const Color(0xFF059669),
                          iconBg: const Color(0xFFECFDF5),
                          count: _faolCount,
                          label: 'Faol Adminlar',
                        ),
                      ),
                      SizedBox(width: r.gapMd),
                      Expanded(
                        child: OwnerAdminStatCard(
                          icon: Icons.cancel_outlined,
                          iconColor: AppColors.red,
                          iconBg: AppColors.red.withOpacity(0.08),
                          count: _nofaolCount,
                          label: 'Nofaol Adminlar',
                        ),
                      ),
                    ]),
                  SizedBox(height: r.gapSm),
                ],
              ),
            ),
          ),

          // ── Admin cards:
          // phone → 1 ustun, tablet+ → 2 ustun ──
          _adminlar.isEmpty
              ? SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: r.gapLg * 2),
              child: Column(children: [
                Icon(Icons.shield_outlined,
                    size: 52, color: Colors.grey.shade300),
                SizedBox(height: r.gapMd),
                Text('Adminlar topilmadi',
                    style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: r.fontMd)),
              ]),
            ),
          )
              : r.isPhone
              ? SliverPadding(
            padding: EdgeInsets.fromLTRB(
                r.padH, 0, r.padH, 0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (_, i) => OwnerAdminCard(
                  admin: _adminlar[i],
                  onToggleStatus: () =>
                      _toggleStatus(_adminlar[i]),
                  onEdit: () =>
                      _showEditDialog(_adminlar[i]),
                  onDelete: () =>
                      _showDeleteDialog(_adminlar[i]),
                ),
                childCount: _adminlar.length,
              ),
            ),
          )
              : SliverPadding(
            padding: EdgeInsets.fromLTRB(
                r.padH, 0, r.padH, 0),
            sliver: SliverGrid(
              gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: r.cardGridCols,
                crossAxisSpacing: r.gapMd,
                mainAxisSpacing: r.gapMd,
                childAspectRatio: 0.9,
              ),
              delegate: SliverChildBuilderDelegate(
                    (_, i) => OwnerAdminCard(
                  admin: _adminlar[i],
                  onToggleStatus: () =>
                      _toggleStatus(_adminlar[i]),
                  onEdit: () =>
                      _showEditDialog(_adminlar[i]),
                  onDelete: () =>
                      _showDeleteDialog(_adminlar[i]),
                ),
                childCount: _adminlar.length,
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: r.gapLg * 2)),
        ],
      ),
    );
  }
}