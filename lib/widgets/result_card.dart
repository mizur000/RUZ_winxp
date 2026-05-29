import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const ResultCard({super.key, required this.title, this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        splashColor: isDark ? Colors.blue.shade800 : Colors.blue.shade100,
        highlightColor: isDark ? Colors.blue.shade900 : Colors.blue.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Material стиль — круглая иконка с фоном
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? Colors.blue.withValues(alpha: 0.15) : Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.search,
                  color: isDark ? Colors.blue.shade300 : const Color(0xFF1E88E5),
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.grey.shade800,
                        fontFamily: 'Roboto',
                        letterSpacing: 0.3,
                      ),
                    ),
                    if (subtitle != null && subtitle!.isNotEmpty)
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                          fontFamily: 'Roboto',
                        ),
                      ),
                  ],
                ),
              ),
              // Material стиль — стрелка с анимацией
              Icon(
                Icons.chevron_right,
                color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}