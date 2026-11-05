// -- all text styles in one place
// -- name = size + weight, txt14w700 is 14px bold

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/app_colors.dart';

class AppTextstyles {
  static TextStyle txt13w700 = GoogleFonts.openSans(
    fontSize: 13.sp,
    color: Colors.black,
    fontWeight: FontWeight.w700,
  );
  static TextStyle txt14w700 = GoogleFonts.openSans(
    fontSize: 14.sp,
    color: Colors.black,
    fontWeight: FontWeight.w700,
  );
  static TextStyle txt18w700 = GoogleFonts.openSans(
    fontSize: 18.sp,
    color: AppColors.lightGrey,
    fontWeight: FontWeight.w700,
  );
  static TextStyle txt18w400 = GoogleFonts.openSans(
    fontSize: 18.sp,
    color: AppColors.copeCode,
    fontWeight: FontWeight.w400,
  );
}
