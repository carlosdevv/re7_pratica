import 'package:flutter/material.dart';
import 'package:re7_pratica/constants/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.black,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
