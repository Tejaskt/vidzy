import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vidzy/res/app_colors.dart';

class ShimmerEffect extends StatelessWidget {
  const ShimmerEffect({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
        fit: StackFit.expand,
        children: [

          Shimmer.fromColors(
            baseColor: AppColors.baseColor,
            highlightColor:  AppColors.highlightColor,
            child: Container(color: AppColors.white),
          ),

          /*
          Positioned(
            top: 20.sp,
            right: 10.sp,
            child: Shimmer.fromColors(
              baseColor: AppColors.baseColor,
              highlightColor:  AppColors.highlightColor,
              child: Card(
                color: AppColors.white,
                child: Padding(
                  padding: EdgeInsets.all(Constants.padding8),
                  child: Text('na'),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 20.sp,
            left: 10.sp,
            child: Shimmer.fromColors(
              baseColor: AppColors.baseColor,
              highlightColor:  AppColors.highlightColor,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(Constants.padding8),
                  child: Text(
                    '@UserName',
                  ),
                ),
              ),
            )
          ),

          Positioned(
            bottom: 20.sp,
            right: 10.sp,
            child: Shimmer.fromColors(
              baseColor: AppColors.baseColor,
              highlightColor:  AppColors.highlightColor,
              child: CircleAvatar(
                radius: Constants.cornerRadius18,
                child: Padding(padding: EdgeInsets.all(Constants.padding12)),
              ),
            ),
          ),

           */
        ],
      // ),
    );
  }
}
