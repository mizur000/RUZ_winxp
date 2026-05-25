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
    // XP style — игнорируем тему, везде классический вид

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFECE9D8), // Фон панели XP
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF003399),
            width: 2,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // XP-стрелка влево (как в проводнике)
              GestureDetector(
                onTap: onPrevWeek,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE1DFD4),
                    border: Border.all(color: const Color(0xFFACA899), width: 1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.chevron_left,
                    color: Color(0xFF1F3A6B),
                    size: 20,
                  ),
                ),
              ),
              // XP-стиль для диапазона недели (как заголовок окна)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0058E3), Color(0xFF2560C9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Text(
                  _getWeekRange(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.white,
                    fontFamily: 'Tahoma',
                  ),
                ),
              ),
              // XP-стрелка вправо
              GestureDetector(
                onTap: onNextWeek,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE1DFD4),
                    border: Border.all(color: const Color(0xFFACA899), width: 1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.chevron_right,
                    color: Color(0xFF1F3A6B),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // XP-статус бар для типа недели
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE1DFD4),
              border: Border.all(color: const Color(0xFFACA899), width: 1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              _getWeekType(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1E2F5A),
                fontFamily: 'Tahoma',
              ),
            ),
          ),
        ],
      ),
    );
  }
}