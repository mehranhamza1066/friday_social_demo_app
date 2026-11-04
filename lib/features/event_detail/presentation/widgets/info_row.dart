import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/app_textstyles.dart';
import '../../../../utils/app_colors.dart';

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Icon(icon, size: 20.r, color: AppColors.primaryBlue),
          SizedBox(width: 12.w),
          Text(
            label,
            style: AppTextstyles.txt13w700.copyWith(color: AppColors.lightGrey),
          ),
          const Spacer(),
          Text(value, style: AppTextstyles.txt14w700),
        ],
      ),
    );
  }
}
