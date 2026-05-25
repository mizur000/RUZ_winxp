import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const ResultCard({super.key, required this.title, this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // XP style — игнорируем тему, везде классический вид

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFECE9D8), // Фон окна XP
        border: Border.all(color: const Color(0xFF003399), width: 1.5),
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            offset: Offset(1, 1),
            blurRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: onTap,
          splashColor: const Color(0xFF0058E3).withValues(alpha: 0.2),
          highlightColor: const Color(0xFF0058E3).withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // XP-стиль иконки (как в панели управления)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE1DFD4),
                    border: Border.all(color: const Color(0xFFACA899), width: 1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.search,
                    color: Color(0xFF1F3A6B),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E2F5A),
                          fontFamily: 'Tahoma',
                        ),
                      ),
                      if (subtitle != null && subtitle!.isNotEmpty)
                        Text(
                          subtitle!,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF555555),
                            fontFamily: 'Tahoma',
                          ),
                        ),
                    ],
                  ),
                ),
                // XP-стрелка (как в меню "Пуск")
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF1F3A6B),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}