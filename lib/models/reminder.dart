class Reminder {
  final String id;
  final String title;
  final String subtitle;
  final DateTime dateTime;
  final Duration remindBefore;
  final String userId;
  final bool isDone;

  Reminder({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.dateTime,
    required this.remindBefore,
    required this.userId,
    required this.isDone,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'dateTime': dateTime.toIso8601String(),
      'remindBefore': remindBefore.inMinutes,
      'userId': userId,
      'isDone': isDone,
    };
  }

  factory Reminder.fromMap(String id, Map<String, dynamic> map) {
    return Reminder(
      id: id,
      title: map['title'],
      subtitle: map['subtitle'],
      dateTime: DateTime.parse(map['dateTime']),
      remindBefore: Duration(minutes: map['remindBefore']),
      userId: map['userId'],
      isDone: map['isDone'],
    );
  }
}
