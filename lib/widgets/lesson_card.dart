import 'package:flutter/material.dart';
import '../models/lesson.dart';

class LessonCard extends StatelessWidget {
  final Lesson lesson;
  final bool showGroup;

  const LessonCard({super.key, required this.lesson, this.showGroup = false});

  (Color bgColor, Color textColor, IconData icon) _getTypeStyle() {
    final type = lesson.lessonType.toLowerCase();

    if (type.contains('лекц')) {
      return (const Color(0xFFE3F2FD), const Color(0xFF1565C0), Icons.menu_book);
    } else if (type.contains('практик')) {
      return (const Color(0xFFE8F5E9), const Color(0xFF2E7D32), Icons.people);
    } else if (type.contains('лабор')) {
      return (const Color(0xFFFFF3E0), const Color(0xFFE65100), Icons.science);
    } else if (type.contains('зачет') || type.contains('экзамен')) {
      return (const Color(0xFFFFEBEE), const Color(0xFFC62828), Icons.assignment_turned_in);
    }
    return (const Color(0xFFF5F5F5), const Color(0xFF616161), Icons.school);
  }

  @override
  Widget build(BuildContext context) {
    final typeStyle = _getTypeStyle();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Material заголовок с градиентом
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF0D47A1), const Color(0xFF1565C0)]
                    : [const Color(0xFF42A5F5), const Color(0xFF1E88E5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.schedule, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    lesson.pairNumberDisplay.isNotEmpty ? lesson.pairNumberDisplay : 'Пара',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'Roboto',
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const Icon(Icons.access_time, color: Colors.white, size: 14),
                const SizedBox(width: 6),
                Text(
                  lesson.formattedTime,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
          ),
          // Тело карточки
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.discipline,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.grey.shade800,
                    fontFamily: 'Roboto',
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 10),
                // Material стиль — чип типа занятия
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: typeStyle.$1,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: typeStyle.$2.withValues(alpha: 0.3),
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(typeStyle.$3, size: 14, color: typeStyle.$2),
                      const SizedBox(width: 6),
                      Text(
                        lesson.lessonType.isNotEmpty ? lesson.lessonType : 'Занятие',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: typeStyle.$2,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ],
                  ),
                ),
                if (showGroup && lesson.groupName != null && lesson.groupName!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.group, size: 16, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          lesson.groupName!,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                if (!showGroup && lesson.lecturerDisplay.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.person, size: 16, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lesson.lecturerDisplay,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            if (lesson.lecturerRank != null && lesson.lecturerRank!.isNotEmpty)
                              Text(
                                lesson.lecturerRank!,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
                if (lesson.location.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          lesson.location,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}