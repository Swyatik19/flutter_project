import 'package:flutter/material.dart';
import 'package:flutter_project/core/colors/colors.dart';
import 'package:flutter_project/core/dimensions/dimensions.dart';
import 'package:flutter_project/core/icons/icons.dart';
import 'package:flutter_project/core/textStyle/textStyle.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchItem extends StatefulWidget {
  final String title;
  final VoidCallback onTap;
  final bool isInitiallyFavorite;

  const SearchItem({
    super.key,
    required this.onTap,
    required this.title,
    required this.isInitiallyFavorite,
  });

  @override
  _SearchItemState createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isInitiallyFavorite;
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: size16),
      child: GestureDetector(
        onTap: toggleFavorite,
        child: Container(
          height: size55,
          decoration: BoxDecoration(
              color: layerColor, borderRadius: BorderRadius.circular(size10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding:
                const EdgeInsets.only(left: size16, top: size18, bottom: size18),
                child: Text(
                  widget.title,
                  style: bodyText,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: size26),
                child: IconButton(
                  onPressed: toggleFavorite,
                  icon: isFavorite
                      ? SvgPicture.asset(iconFavoriteActive)
                      : SvgPicture.asset(iconFavoriteGrey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
