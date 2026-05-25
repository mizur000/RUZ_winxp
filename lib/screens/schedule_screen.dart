import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/lesson.dart';  // ⬅️ ЭТОТ ИМПОРТ БЫЛ ПОТЕРЯН
import '../services/schedule_service.dart';
import '../widgets/week_calendar.dart';
import '../widgets/lesson_card.dart';
import '../providers/favorites_provider.dart';
import '../providers/theme_provider.dart';

class ScheduleScreen extends StatefulWidget {
  final String entityId;
  final String entityType;
  final String entityName;
  final ScheduleService scheduleService;

  const ScheduleScreen({
    super.key,
    required this.entityId,
    required this.entityType,
    required this.entityName,
    required this.scheduleService,
  });

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  List<Lesson> _lessons = [];
  bool _isLoading = true;
  String? _error;
  DateTime _currentWeekStart = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadSchedule();
  }

  Future<void> _loadSchedule() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final monday = _currentWeekStart.subtract(Duration(days: _currentWeekStart.weekday - 1));
      final sunday = monday.add(const Duration(days: 6));

      final lessons = await widget.scheduleService.fetchSchedule(
        entityId: widget.entityId,
        entityType: widget.entityType,
        startDate: monday,
        endDate: sunday,
      );

      final sorted = List<Lesson>.from(lessons)..sort((a, b) {
        if (a.date != b.date) return a.date.compareTo(b.date);
        final pairA = a.lessonNumberStart ?? 999;
        final pairB = b.lessonNumberStart ?? 999;
        return pairA.compareTo(pairB);
      });

      setState(() {
        _lessons = sorted;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _changeWeek(int offset) {
    setState(() {
      _currentWeekStart = _currentWeekStart.add(Duration(days: offset * 7));
    });
    _loadSchedule();
  }

  Map<String, List<Lesson>> _groupLessonsByDay() {
    final Map<String, List<Lesson>> grouped = {};
    for (var lesson in _lessons) {
      if (!grouped.containsKey(lesson.date)) {
        grouped[lesson.date] = [];
      }
      grouped[lesson.date]!.add(lesson);
    }
    return grouped;
  }

  List<DateTime> _getAllDaysOfWeek(DateTime monday) {
    return List.generate(7, (i) => monday.add(Duration(days: i)));
  }

  String _getDayOfWeekString(DateTime date) {
    const weekdays = ['Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота', 'Воскресенье'];
    return weekdays[date.weekday - 1];
  }

  void _toggleFavorite(FavoritesProvider provider) {
    if (provider.isFavorite(widget.entityId)) {
      provider.removeFavorite(widget.entityId);
    } else {
      provider.addFavorite(FavoriteGroup(
        id: widget.entityId,
        name: widget.entityName,
        type: widget.entityType,
      ));
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
      'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'
    ];
    return '${date.day} ${months[date.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = context.watch<FavoritesProvider>();
    final isFavorite = favoritesProvider.isFavorite(widget.entityId);
    final showGroup = widget.entityType == 'person';

    return Scaffold(
      backgroundColor: const Color(0xFFECE9D8),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0058E3), Color(0xFF2560C9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border(
              bottom: BorderSide(color: Color(0xFF003399), width: 2),
            ),
          ),
          child: AppBar(
            title: Text(
              widget.entityName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
                fontFamily: 'Tahoma',
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 4),
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.star : Icons.star_border,
                    color: isFavorite ? Colors.amber : Colors.white,
                    size: 20,
                  ),
                  onPressed: () => _toggleFavorite(favoritesProvider),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 8),
                child: IconButton(
                  icon: const Icon(Icons.computer, color: Colors.white, size: 20),
                  onPressed: () => context.read<ThemeProvider>().toggleTheme(),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          WeekCalendar(
            currentStart: _currentWeekStart,
            onPrevWeek: () => _changeWeek(-1),
            onNextWeek: () => _changeWeek(1),
          ),
          Expanded(child: _buildBody(showGroup)),
        ],
      ),
    );
  }

  Widget _buildBody(bool showGroup) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Color(0xFF0058E3),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Color(0xFF990000)),
            const SizedBox(height: 16),
            Text(_error!, style: const TextStyle(fontFamily: 'Tahoma', fontSize: 12, color: Color(0xFF1E2F5A))),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE1DFD4),
                border: Border.all(color: const Color(0xFFACA899), width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: ElevatedButton(
                onPressed: _loadSchedule,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                ),
                child: const Text('Повторить', style: TextStyle(fontFamily: 'Tahoma', fontSize: 12, color: Color(0xFF1E2F5A))),
              ),
            ),
          ],
        ),
      );
    }

    final monday = _currentWeekStart.subtract(Duration(days: _currentWeekStart.weekday - 1));
    final allDays = _getAllDaysOfWeek(monday);
    final grouped = _groupLessonsByDay();

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: 7,
      itemBuilder: (context, index) {
        final date = allDays[index];
        final dateKey = date.toIso8601String().split('T')[0];
        final dayLessons = grouped[dateKey] ?? [];
        final isToday = date.year == DateTime.now().year &&
            date.month == DateTime.now().month &&
            date.day == DateTime.now().day;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isToday ? const Color(0xFF0058E3) : const Color(0xFFE1DFD4),
                  border: Border.all(color: const Color(0xFFACA899), width: 1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Text(
                      _getDayOfWeekString(date),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isToday ? Colors.white : const Color(0xFF1E2F5A),
                        fontFamily: 'Tahoma',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isToday ? Colors.white.withValues(alpha: 0.2) : const Color(0xFFECE9D8),
                        border: Border.all(color: const Color(0xFFACA899), width: 0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _formatDate(date),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isToday ? Colors.white : const Color(0xFF555555),
                          fontFamily: 'Tahoma',
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (dayLessons.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isToday ? Colors.white.withValues(alpha: 0.2) : const Color(0xFFECE9D8),
                          border: Border.all(color: const Color(0xFFACA899), width: 0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${dayLessons.length} пар',
                          style: TextStyle(
                            fontSize: 11,
                            color: isToday ? Colors.white : const Color(0xFF555555),
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Tahoma',
                          ),
                        ),
                      ),
                    if (isToday) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFACA899), width: 1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Сегодня',
                          style: TextStyle(fontSize: 10, color: Color(0xFF1E2F5A), fontWeight: FontWeight.w600, fontFamily: 'Tahoma'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 8),
              if (dayLessons.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECE9D8),
                    border: Border.all(color: const Color(0xFFACA899), width: 1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.free_breakfast, size: 40, color: Color(0xFF888888)),
                      const SizedBox(height: 8),
                      const Text(
                        'Пусто :)',
                        style: TextStyle(fontSize: 13, color: Color(0xFF555555), fontFamily: 'Tahoma'),
                      ),
                      const Text(
                        ' ',
                        style: TextStyle(fontSize: 11, color: Color(0xFF888888), fontFamily: 'Tahoma'),
                      ),
                    ],
                  ),
                )
              else
                ...dayLessons.map((lesson) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: LessonCard(lesson: lesson, showGroup: showGroup),
                )),
            ],
          ),
        );
      },
    );
  }
}