class Lesson {
  final String discipline;
  final String? kindOfWork;
  final String? beginLesson;
  final String? endLesson;
  final String? auditorium;
  final String? building;
  final String date;
  final int? lessonNumberStart;
  final int? lessonNumberEnd;
  final String? lecturer;
  final String? lecturerTitle;
  final String? lecturerRank;
  final String? dayOfWeekString;
  final String? groupName;
  final String? groupId;

  Lesson({
    required this.discipline,
    this.kindOfWork,
    this.beginLesson,
    this.endLesson,
    this.auditorium,
    this.building,
    required this.date,
    this.lessonNumberStart,
    this.lessonNumberEnd,
    this.lecturer,
    this.lecturerTitle,
    this.lecturerRank,
    this.dayOfWeekString,
    this.groupName,
    this.groupId,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    String? groupName;
    if (json['group'] != null) {
      groupName = json['group'];
    } else if (json['groupName'] != null) {
      groupName = json['groupName'];
    } else if (json['listGroups'] != null && json['listGroups'] is List && json['listGroups'].isNotEmpty) {
      groupName = json['listGroups'][0]['group'];
    }

    String? groupId;
    if (json['groupOid'] != null) {
      groupId = json['groupOid'].toString();
    } else if (json['listGroups'] != null && json['listGroups'] is List && json['listGroups'].isNotEmpty) {
      groupId = json['listGroups'][0]['groupOid']?.toString();
    }

    return Lesson(
      discipline: json['discipline'] ?? 'Без названия',
      kindOfWork: json['kindOfWork'],
      beginLesson: json['beginLesson'],
      endLesson: json['endLesson'],
      auditorium: json['auditorium'],
      building: json['building'],
      date: json['date'] ?? '',
      lessonNumberStart: json['lessonNumberStart'],
      lessonNumberEnd: json['lessonNumberEnd'],
      lecturer: json['lecturer'],
      lecturerTitle: json['lecturer_title'],
      lecturerRank: json['lecturer_rank'],
      dayOfWeekString: json['dayOfWeekString'],
      groupName: groupName,
      groupId: groupId,
    );
  }

  String get formattedTime {
    if (beginLesson != null && endLesson != null) {
      return '$beginLesson - $endLesson';
    }
    return 'Время не указано';
  }

  String get location {
    if (auditorium != null && auditorium!.isNotEmpty) {
      if (building != null && building!.isNotEmpty) {
        return '$building, $auditorium';
      }
      return auditorium!;
    }
    return 'Место не указано';
  }

  String get lecturerDisplay {
    if (lecturerTitle != null && lecturerTitle!.isNotEmpty) {
      return lecturerTitle!;
    }
    if (lecturer != null && lecturer!.isNotEmpty) {
      return lecturer!;
    }
    return '';
  }

  String get pairNumberDisplay {
    if (lessonNumberStart != null) {
      return '${lessonNumberStart}-я пара';
    }
    return '';
  }

  String get lessonType {
    if (kindOfWork != null && kindOfWork!.isNotEmpty) {
      if (kindOfWork!.contains('Практические')) return 'Практика';
      if (kindOfWork!.contains('Лекционные')) return 'Лекция';
      if (kindOfWork!.contains('Лабораторные')) return 'Лабораторная';
      return kindOfWork!;
    }
    return '';
  }
}