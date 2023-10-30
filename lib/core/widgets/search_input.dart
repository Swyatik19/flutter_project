import 'package:flutter/material.dart';
import 'package:flutter_project/core/colors/colors.dart';
import 'package:flutter_project/core/dimensions/dimensions.dart';
import 'package:flutter_project/core/icons/icons.dart';
import 'package:flutter_svg/flutter_svg.dart';



class SearchInput extends StatefulWidget {
  final Function(String) onFieldSubmitted;
  final Function(String) onChanged;
  const SearchInput({super.key, required this.onFieldSubmitted, required this.onChanged});

  @override
  _SearchInputState createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  bool _showClearIcon = false;
  bool _isActive = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    setState(() {
      _isActive = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: size16),
      child: SizedBox(
        height: size56,
        child: TextFormField(
          onFieldSubmitted: widget.onFieldSubmitted,
          focusNode: _focusNode,
          controller: _controller,
          onChanged: widget.onChanged,
          cursorColor: Colors.black,
          cursorHeight: size20,
          cursorWidth: size1,
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(size30),
                borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(size30),
              borderSide: const BorderSide(color: primaryColor, width: size2),
            ),
            hintText: 'Search',
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: _isActive ? secondaryColor : layerColor,
            prefixIcon: Padding(
              padding: const EdgeInsets.all(size16),
              child: SvgPicture.asset(iconSearch),
            ),
            suffixIcon: _showClearIcon
                ? Padding(
                    padding: const EdgeInsets.only(right: size8),
                    child: IconButton(
                      icon: SvgPicture.asset(iconClose),
                      onPressed: () {
                        _controller.clear();
                        setState(() {
                          _showClearIcon = false;
                        });
                      },
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }
}
