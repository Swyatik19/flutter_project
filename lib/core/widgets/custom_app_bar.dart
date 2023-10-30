import 'package:flutter/material.dart';
import 'package:flutter_project/core/colors/colors.dart';
import 'package:flutter_project/core/dimensions/dimensions.dart';
import 'package:flutter_project/core/textStyle/textStyle.dart';
import 'package:flutter_project/core/widgets/favorites_bottom.dart';


class CustomAppBar extends StatelessWidget {
  final VoidCallback favoriteBottomCallback;
  final VoidCallback backCallback;
  final bool isIconRight;
  final String iconFavoritesBottom;
  final String iconBackBottom;

  const CustomAppBar({
    super.key,
    required this.isIconRight,
    required this.iconFavoritesBottom,
    required this.iconBackBottom,
    required this.favoriteBottomCallback,
    required this.backCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            height: size117,
            width: double.infinity,
            child: Stack(
              children: [
                Align(
                  alignment: isIconRight
                      ? Alignment.bottomRight
                      : Alignment.bottomLeft,
                  child: isIconRight
                      ? FavoritesBottom(
                          iconBottom: iconFavoritesBottom,
                          onTap: favoriteBottomCallback,
                        )
                      : FavoritesBottom(
                          iconBottom: iconBackBottom,
                          onTap: backCallback,
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: size22),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: isIconRight
                        ? const Text(
                            'Github repos list',
                            style: mainText,
                          )
                        : const Text(
                            'Favorite repos list',
                            style: mainText,
                          ),
                  ),
                ),
              ],
            )),
        Container(
          height: size3,
          width: double.infinity,
          color: layerColor,
        )
      ],
    );
  }
}
