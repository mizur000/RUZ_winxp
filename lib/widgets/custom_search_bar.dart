import 'package:flutter/material.dart';
import 'dart:async';

class CustomSearchBar extends StatefulWidget {
  final String hintText;
  final Function(String) onSearch;
  final bool isLoading;

  const CustomSearchBar({
    super.key,
    required this.hintText,
    required this.onSearch,
    this.isLoading = false,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (query.length >= 3 || query.isEmpty) {
        widget.onSearch(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black12 : Colors.grey.shade100,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Material стиль — круглая иконка с фоном
          Container(
            padding: const EdgeInsets.only(left: 16),
            child: widget.isLoading
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: isDark ? Colors.blue.shade300 : const Color(0xFF1E88E5),
                    ),
                  )
                : Icon(
                    Icons.search,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                    size: 22,
                  ),
          ),
          // Material стиль — поле ввода
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
                  fontSize: 14,
                  fontFamily: 'Roboto',
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              ),
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Roboto',
                color: isDark ? Colors.white : Colors.grey.shade800,
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          // Material стиль — кнопка очистки
          if (_controller.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _controller.clear();
                widget.onSearch('');
              },
              child: Container(
                padding: const EdgeInsets.only(right: 16),
                child: Icon(
                  Icons.clear,
                  color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }
}