import 'package:flutter/material.dart';
import 'package:flutter_project/core/colors/colors.dart';
import 'package:flutter_project/core/dimensions/dimensions.dart';
import 'package:flutter_svg/flutter_svg.dart';


class FavoritesBottom extends StatelessWidget {
  final VoidCallback onTap;
  final String iconBottom;

  const FavoritesBottom({
    super.key,
    required this.iconBottom,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: size16, vertical: size11),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: size44,
          width: size44,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(size12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(size8),
            child: SvgPicture.asset(iconBottom),
          ),
        ),
      ),
    );
  }
}
