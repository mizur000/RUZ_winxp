import 'package:flutter/material.dart';
import '../models/lesson.dart';

class LessonCard extends StatelessWidget {
  final Lesson lesson;
  final bool showGroup;

  const LessonCard({super.key, required this.lesson, this.showGroup = false});

  (Color bgColor, Color textColor, IconData icon) _getTypeStyle() {
    final type = lesson.lessonType.toLowerCase();

    if (type.contains('лекц')) {
      return (const Color(0xFFD4E3FD), const Color(0xFF003399), Icons.menu_book);
    } else if (type.contains('практик')) {
      return (const Color(0xFFD0F0D0), const Color(0xFF006600), Icons.people);
    } else if (type.contains('лабор')) {
      return (const Color(0xFFFFE5B4), const Color(0xFF804000), Icons.science);
    } else if (type.contains('зачет') || type.contains('экзамен')) {
      return (const Color(0xFFFFD2D2), const Color(0xFF990000), Icons.assignment_turned_in);
    }
    return (const Color(0xFFE8E8E8), const Color(0xFF444444), Icons.school);
  }

  @override
  Widget build(BuildContext context) {
    final typeStyle = _getTypeStyle();
    // XP style — игнорируем тему, везде классический вид

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFECE9D8), // Фон окна XP
        borderRadius: BorderRadius.circular(6), // Минимальное скругление
        border: Border.all(color: const Color(0xFF003399), width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            offset: Offset(2, 2),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // XP-заголовок (синий градиент)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0058E3), Color(0xFF2560C9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.tv, color: Colors.white, size: 14),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    lesson.pairNumberDisplay.isNotEmpty ? lesson.pairNumberDisplay : 'Пара',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Tahoma',
                    ),
                  ),
                ),
                const Icon(Icons.access_time, color: Colors.white, size: 12),
                const SizedBox(width: 4),
                Text(
                  lesson.formattedTime,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontFamily: 'Tahoma',
                  ),
                ),
              ],
            ),
          ),
          // Тело карточки
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.discipline,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2F5A),
                    fontFamily: 'Tahoma',
                  ),
                ),
                const SizedBox(height: 10),
                // Тег типа занятия (в стиле XP)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: typeStyle.$1,
                    border: Border.all(color: typeStyle.$2, width: 1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(typeStyle.$3, size: 12, color: typeStyle.$2),
                      const SizedBox(width: 4),
                      Text(
                        lesson.lessonType.isNotEmpty ? lesson.lessonType : 'Занятие',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: typeStyle.$2,
                          fontFamily: 'Tahoma',
                        ),
                      ),
                    ],
                  ),
                ),
                if (showGroup && lesson.groupName != null && lesson.groupName!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.group, size: 14, color: Color(0xFF1F3A6B)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          lesson.groupName!,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1E2F5A),
                            fontFamily: 'Tahoma',
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
                      const Icon(Icons.person, size: 14, color: Color(0xFF1F3A6B)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lesson.lecturerDisplay,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1E2F5A),
                                fontFamily: 'Tahoma',
                              ),
                            ),
                            if (lesson.lecturerRank != null && lesson.lecturerRank!.isNotEmpty)
                              Text(
                                lesson.lecturerRank!,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF555555),
                                  fontFamily: 'Tahoma',
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
                      const Icon(Icons.location_on, size: 14, color: Color(0xFF1F3A6B)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          lesson.location,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF1E2F5A),
                            fontFamily: 'Tahoma',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          // Нижняя синяя полоска XP
          Container(
            height: 3,
            color: const Color(0xFF0058E3),
          ),
        ],
      ),
    );
  }
}