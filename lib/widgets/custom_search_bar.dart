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
    // XP не зависит от светлой/тёмной темы — всегда классика
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFECE9D8),
        borderRadius: BorderRadius.circular(0), // XP style — прямые углы или едва скруглённые
        border: Border.all(color: const Color(0xFF003399), width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            offset: Offset(1, 1),
            blurRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          // XP-стиль: иконка поиска как на старой панели задач
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: widget.isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFF0058E3),
                    ),
                  )
                : const Icon(
                    Icons.search,
                    color: Color(0xFF1F3A6B),
                    size: 18,
                  ),
          ),
          // XP-стиль: поле ввода как в диалоговых окнах
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: '',
                hintStyle: TextStyle(
                  color: Color(0xFF6B6B6B),
                  fontSize: 12,
                  fontFamily: 'Tahoma',
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'Tahoma',
                color: Color(0xFF1E2F5A),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          // Кнопка "Очистить" в стиле XP
          if (_controller.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _controller.clear();
                widget.onSearch('');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: const Text(
                  '✕',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1F3A6B),
                    fontFamily: 'Tahoma',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}