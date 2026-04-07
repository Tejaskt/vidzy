import 'package:flutter/cupertino.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'app_colors.dart';

class AppFonts {

  /// ------ Private internal constructor ------
  AppFonts._i();

  static TextStyle latoRegular = TextStyle (
   color: AppColors.black,
   fontSize: 14.sp
  );

  static final txtStyle = TextStyle(
    fontFamily: 'Lato',
    fontSize: 18.sp,
    fontWeight: .bold,
  );


}

