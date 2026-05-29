import 'package:flutter/material.dart';

class WeekCalendar extends StatelessWidget {
  final DateTime currentStart;
  final VoidCallback onPrevWeek;
  final VoidCallback onNextWeek;

  const WeekCalendar({
    super.key,
    required this.currentStart,
    required this.onPrevWeek,
    required this.onNextWeek,
  });

  String _formatDateFull(DateTime date) {
    const months = [
      'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
      'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'
    ];
    return '${date.day} ${months[date.month - 1]}';
  }

  String _getWeekRange() {
    final monday = currentStart.subtract(Duration(days: currentStart.weekday - 1));
    final sunday = monday.add(const Duration(days: 6));
    return '${_formatDateFull(monday)} — ${_formatDateFull(sunday)}';
  }

  String _getWeekType() {
    final now = DateTime.now();
    DateTime academicYearStart;
    if (now.month >= 9) {
      academicYearStart = DateTime(now.year, 9, 1);
    } else {
      academicYearStart = DateTime(now.year - 1, 9, 1);
    }

    while (academicYearStart.weekday != 1) {
      academicYearStart = academicYearStart.subtract(const Duration(days: 1));
    }

    final currentMonday = currentStart.subtract(Duration(days: currentStart.weekday - 1));
    final difference = currentMonday.difference(academicYearStart).inDays;
    final weekNumber = (difference / 7).floor() + 1;
    final isEven = weekNumber % 2 == 0;
    return isEven ? 'Четная неделя' : 'Нечетная неделя';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black12 : Colors.grey.shade100,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Материал дизайн — большие круглые кнопки
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onPrevWeek,
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey.withValues(alpha: 0.15) : Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.chevron_left,
                      color: isDark ? Colors.grey.shade300 : const Color(0xFF1E88E5),
                      size: 24,
                    ),
                  ),
                ),
              ),
              // Материал стиль — карточка с тенью
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF0D47A1), const Color(0xFF1565C0)]
                        : [const Color(0xFF42A5F5), const Color(0xFF1E88E5)],
                  ),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  _getWeekRange(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.white,
                    fontFamily: 'Roboto',
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onNextWeek,
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey.withValues(alpha: 0.15) : Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.chevron_right,
                      color: isDark ? Colors.grey.shade300 : const Color(0xFF1E88E5),
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Материал стиль — чип
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? Colors.blue.withValues(alpha: 0.15) : Colors.blue.shade50,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark ? Colors.blue.withValues(alpha: 0.3) : Colors.blue.shade200,
                width: 0.5,
              ),
            ),
            child: Text(
              _getWeekType(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.blue.shade300 : const Color(0xFF1565C0),
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ],
      ),
    );
  }
}