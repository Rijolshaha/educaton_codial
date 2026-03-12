import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../models/student_model.dart';

class AdminGroupList extends StatelessWidget {
  final List<GroupModel> groups;
  const AdminGroupList({super.key, required this.groups});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: groups.asMap().entries.map((e) {
        final i = e.key;
        final g = e.value;
        return Column(
          children: [
            if (i > 0)
              const Divider(height: 1, color: Color(0xFFF3F4F6)),
            _GroupRow(group: g),
          ],
        );
      }).toList(),
    );
  }
}

class _GroupRow extends StatelessWidget {
  final GroupModel group;
  const _GroupRow({required this.group});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(group.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    )),
                const SizedBox(height: 4),
                const Text('Jami coinlar:',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    )),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("${group.studentCount} o'quvchi",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blue1,
                  )),
              const SizedBox(height: 4),
              Text('${group.totalCoins}',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}