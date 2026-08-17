import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CoinSearchBar extends StatefulWidget {
  const CoinSearchBar({
    required this.onChanged,
    required this.onClear,
    this.initialValue = '',
    super.key,
  });

  final String initialValue;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  State<CoinSearchBar> createState() => _CoinSearchBarState();
}

class _CoinSearchBarState extends State<CoinSearchBar> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  bool get _hasText => _controller.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue)
      ..addListener(_onTextUpdated);
    _focusNode = FocusNode();
  }

  void _onTextUpdated() => setState(() {});

  void _clearSearch() {
    _controller.clear();
    _focusNode.unfocus();
    widget.onClear();
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onTextUpdated)
      ..dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      textInputAction: TextInputAction.search,
      style: TextStyle(color: Colors.black, fontSize: 16.sp),
      autocorrect: false,
      enableSuggestions: false,
      inputFormatters: [LengthLimitingTextInputFormatter(50)],
      onChanged: widget.onChanged,
      onTapOutside: (_) => _focusNode.unfocus(),
      decoration: InputDecoration(
        hintText: 'Search',
        hintStyle: TextStyle(color: const Color(0xFF8C8C8C), fontSize: 16.sp),
        prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF8C8C8C)),
        suffixIcon: _hasText
            ? IconButton(
                tooltip: 'Clear search',
                onPressed: _clearSearch,
                icon: const Icon(Icons.close_rounded, color: Color(0xFF8C8C8C)),
              )
            : null,
        filled: true,
        fillColor: const Color(0xFFEFE9F0),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: _border(),
        enabledBorder: _border(),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3478F6), width: 1.5),
        ),
      ),
    );
  }

  OutlineInputBorder _border() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    );
  }
}
