import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vidzy/res/app_colors.dart';

class ShimmerEffect extends StatelessWidget {
  const ShimmerEffect({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Shimmer.fromColors(
        baseColor: AppColors.baseColor,
        highlightColor: AppColors.highlightColor,
        child: Container(color: AppColors.white),
      ),
    );
  }
}
