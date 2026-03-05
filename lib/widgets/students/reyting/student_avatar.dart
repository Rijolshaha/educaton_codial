import 'package:flutter/material.dart';
import '../../../models/student_model.dart';

class StudentAvatar extends StatelessWidget {
  final StudentModel student;
  final double size;
  final Border? border;

  const StudentAvatar({
    super.key,
    required this.student,
    this.size = 44,
    this.border,
  });

  static Color _hexToColor(String hex) {
    final h = hex.replaceAll('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _hexToColor(student.avatarColor),
        shape: BoxShape.circle,
        border: border,
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Center(
        child: Text(
          student.avatarEmoji,
          style: TextStyle(fontSize: size * 0.45),
        ),
      ),
    );
  }
}