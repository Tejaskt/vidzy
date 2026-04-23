import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vidzy/res/app_colors.dart';

import '../constants.dart';

class ShimmerEffect extends StatelessWidget {
  const ShimmerEffect({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade50,
      child: Container(
        height: .infinity,
        width: .infinity,
        decoration: BoxDecoration(
          color: AppColors.white
        ),
        child: Stack(
            fit: StackFit.expand,
            children: [

              Positioned(
                top: 20.sp,
                right: 10.sp,
                child: Card(
                  color: AppColors.green300,
                  child: Padding(
                    padding: EdgeInsets.all(Constants.padding8),
                    child: Text('Na'),
                  ),
                ),
              ),

              Positioned(
                bottom: 20.sp,
                left: 10.sp,
                child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(Constants.padding8),
                        child: Text(
                          '@username',
                        ),
                      ),
                    ),
                ),

              Positioned(
                bottom: 20.sp,
                right: 10.sp,
                child: CircleAvatar(
                    radius: Constants.cornerRadius18,
                )),

            ],
          ),
      )
    );
  }
}
