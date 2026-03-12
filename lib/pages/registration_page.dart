import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import 'student/main_page.dart';
import 'teacher/teacher_main_page.dart';
import 'admin/admin_main_page.dart';
import 'owner/owner_main_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage>
    with SingleTickerProviderStateMixin {
  final _formKey            = GlobalKey<FormState>();
  final _loginController    = TextEditingController();
  final _passwordController = TextEditingController();

  bool    _obscurePassword = true;
  bool    _isLoading       = false;
  String? _errorMessage;

  late final AnimationController _animController;
  late final Animation<double>   _fadeAnim;
  late final Animation<Offset>   _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    setState(() => _errorMessage = null);
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    final login    = _loginController.text.trim();
    final password = _passwordController.text;

    Widget? destination;

    if (login == 'student' && password == '1234') {
      destination = const MainPage();
    } else if (login == 'teacher' && password == '4321') {
      destination = const TeacherMainPage();
    } else if (login == 'admin' && password == '4432') {
      destination = const AdminMainPage();
    } else if (login == 'owner' && password == '0000') {
      // ✅ Ega → OwnerMainPage
      destination = const OwnerMainPage();
    }

    if (destination != null) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, anim, __) => destination!,
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    } else {
      setState(() {
        _isLoading    = false;
        _errorMessage = "Login yoki parol noto'g'ri";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.scaffold,
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Positioned(
              top: 0, left: 0, right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDeep],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(40)),
                ),
              ),
            ),
            Positioned(top: -50, right: -50, child: _Circle(size: 180, opacity: 0.07)),
            Positioned(top: 70,  right: 20,  child: _Circle(size: 80,  opacity: 0.07)),
            Positioned(top: 20,  left: -40,  child: _Circle(size: 130, opacity: 0.05)),

            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 44),
                        Container(
                          width: 80, height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryDeep.withOpacity(0.25),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Center(
                              child: Text('🎓',
                                  style: TextStyle(fontSize: 38))),
                        ),
                        const SizedBox(height: 18),
                        const Text('Codial',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            )),
                        const SizedBox(height: 6),
                        const Text('Hisobingizga kiring',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 15)),
                        const SizedBox(height: 36),

                        // Form card
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.cardBg,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Error banner
                                AnimatedSize(
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeOut,
                                  child: _errorMessage != null
                                      ? Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(bottom: 20),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: AppColors.red.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppColors.red.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.error_outline_rounded,
                                            color: AppColors.red.withOpacity(0.85),
                                            size: 18),
                                        const SizedBox(width: 8),
                                        Text(
                                          _errorMessage!,
                                          style: TextStyle(
                                            color: AppColors.red.withOpacity(0.9),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                      : const SizedBox.shrink(),
                                ),

                                const _FieldLabel(text: 'Login'),
                                const SizedBox(height: 8),
                                _InputField(
                                  controller: _loginController,
                                  hint: 'login kiriting',
                                  prefixIcon: Icons.person_outline_rounded,
                                  onChanged: (_) =>
                                      setState(() => _errorMessage = null),
                                  validator: (v) =>
                                  (v == null || v.trim().isEmpty)
                                      ? 'Login kiritilmadi'
                                      : null,
                                ),
                                const SizedBox(height: 20),

                                const _FieldLabel(text: 'Parol'),
                                const SizedBox(height: 8),
                                _InputField(
                                  controller: _passwordController,
                                  hint: 'parol kiriting',
                                  prefixIcon: Icons.lock_outline_rounded,
                                  obscureText: _obscurePassword,
                                  onChanged: (_) =>
                                      setState(() => _errorMessage = null),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: AppColors.textHint,
                                      size: 20,
                                    ),
                                    onPressed: () => setState(() =>
                                    _obscurePassword = !_obscurePassword),
                                  ),
                                  validator: (v) =>
                                  (v == null || v.isEmpty)
                                      ? 'Parol kiritilmadi'
                                      : null,
                                ),
                                const SizedBox(height: 28),

                                SizedBox(
                                  width: double.infinity,
                                  height: 54,
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _onLogin,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      disabledBackgroundColor:
                                      AppColors.primary.withOpacity(0.55),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: _isLoading
                                        ? const SizedBox(
                                      width: 22, height: 22,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                        : const Text('Kirish',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.3,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Hisobingiz yo'qmi? ",
                                style: TextStyle(
                                    color: AppColors.textSecond,
                                    fontSize: 14)),
                            GestureDetector(
                              onTap: () async {
                                final uri = Uri(
                                    scheme: 'tel', path: '+998998204432');
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri,
                                      mode: LaunchMode.externalApplication);
                                }
                              },
                              child: Text("Bog'laning",
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  )),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  final double size;
  final double opacity;
  const _Circle({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) => Container(
    width: size, height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white.withOpacity(opacity),
    ),
  );
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) => Text(text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecond,
        letterSpacing: 0.2,
      ));
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: AppColors.textHint,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Icon(prefixIcon, color: AppColors.primary, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.scaffold,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.primary, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
          BorderSide(color: AppColors.red.withOpacity(0.8), width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
          BorderSide(color: AppColors.red.withOpacity(0.8), width: 1.8),
        ),
        errorStyle: TextStyle(
          fontSize: 12,
          color: AppColors.red.withOpacity(0.9),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}