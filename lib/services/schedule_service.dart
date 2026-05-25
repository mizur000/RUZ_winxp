import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/lesson.dart';

class ScheduleService {
  final String baseUrl;
  final Map<String, List<Map<String, dynamic>>> _cache = {};

  ScheduleService({required this.baseUrl});

  Future<List<Map<String, dynamic>>> unifiedSearch(String query) async {
    if (query.length < 3) {
      throw Exception('Введите минимум 3 символа');
    }

    final normalizedQuery = query.trim().toLowerCase();

    if (_cache.containsKey(normalizedQuery)) {
      return _cache[normalizedQuery]!;
    }

    final results = await Future.wait([
      _searchGroups(query),
      _searchPersons(query),
    ]);

    final allResults = [...results[0], ...results[1]];
    _cache[normalizedQuery] = allResults;

    Future.delayed(const Duration(minutes: 10), () {
      _cache.remove(normalizedQuery);
    });

    return allResults;
  }

  Future<List<Map<String, dynamic>>> _searchGroups(String query) async {
    try {
      final url = Uri.parse('$baseUrl/search?type=group&term=${Uri.encodeComponent(query)}');
      final response = await http.get(url).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          return data.map((item) {
            return <String, dynamic>{
              'id': item['id'],
              'searchType': 'group',
              'displayName': item['name'] ?? item['label'] ?? 'Группа',
              'subtitle': 'Группа',
              ...item,
            };
          }).toList();
        }
      }
    } catch (e) {
      // Silent fail
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> _searchPersons(String query) async {
    try {
      final url = Uri.parse('$baseUrl/search?type=person&term=${Uri.encodeComponent(query)}');
      final response = await http.get(url).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          return data.map((item) {
            String name = item['fullName'] ??
                item['name'] ??
                item['label'] ??
                item['lecturer'] ??
                item['lecturer_title'] ??
                'Преподаватель';

            return <String, dynamic>{
              'id': item['id'],
              'searchType': 'person',
              'displayName': name,
              'subtitle': item['rank'] ?? item['lecturer_rank'] ?? 'Преподаватель',
              ...item,
            };
          }).toList();
        }
      }
    } catch (e) {
      // Silent fail
    }
    return [];
  }

  Future<List<Lesson>> fetchSchedule({
    required String entityId,
    required String entityType,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final start = _formatDate(startDate);
    final end = _formatDate(endDate);

    final url = Uri.parse(
      '$baseUrl/api/schedule/$entityType/$entityId?start=$start&finish=$end',
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Lesson.fromJson(item)).toList();
      } else {
        throw Exception('Ошибка загрузки');
      }
    } catch (e) {
      throw Exception('Ошибка соединения');
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
}