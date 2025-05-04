import 'package:flutter_test/flutter_test.dart';
import 'package:student_life/services/reminder_service.dart';
import 'package:student_life/models/reminder.dart';
import 'package:mockito/mockito.dart';

// Клас обгортка для ReminderService, який дозволяє тестувати без Firebase
class MockReminderService {
  //iмітує отримання списку нагадувань з бази даних
  static Future<List<Reminder>> fetchReminders(String userId) async {
    return [
      Reminder(
        id: 'reminder-1',
        title: 'Тестове нагадування 1',
        subtitle: 'Опис тестового нагадування 1',
        dateTime: DateTime(2025, 5, 10, 14, 30),
        remindBefore: Duration(minutes: 10),
        userId: userId,
        isDone: false,
      ),
      Reminder(
        id: 'reminder-2',
        title: 'Тестове нагадування 2',
        subtitle: 'Опис тестового нагадування 2',
        dateTime: DateTime(2025, 5, 11, 16, 0),
        remindBefore: Duration(minutes: 15),
        userId: userId,
        isDone: true,
      ),
    ];
  }

  static Future<Reminder> saveReminder(Reminder reminder) async {
    // Симулюємо збереження і повертаємо нагадування з ID
    return Reminder(
      id: 'generated-id-${DateTime.now().millisecondsSinceEpoch}',
      title: reminder.title,
      subtitle: reminder.subtitle,
      dateTime: reminder.dateTime,
      remindBefore: reminder.remindBefore,
      userId: reminder.userId,
      isDone: reminder.isDone,
    );
  }

  static Future<void> updateReminder(Reminder reminder) async {
    // Симулюємо оновлення нагадування
    return;
  }

  static Future<void> deleteReminder(String reminderId) async {
    // Симулюємо видалення нагадування
    if (reminderId.isEmpty) {
      throw Exception('Invalid reminder ID');
    }
    return;
  }
}

void main() {
  group('MockReminderService Tests', () {
    test('fetchReminders should return list of reminders for user', () async {
      const String userId = 'test-user';

      final reminders = await MockReminderService.fetchReminders(userId);

      expect(reminders, isA<List<Reminder>>());
      expect(reminders.length, 2);
      expect(reminders[0].title, 'Тестове нагадування 1');
      expect(reminders[1].title, 'Тестове нагадування 2');
      expect(reminders.every((reminder) => reminder.userId == userId), isTrue);
    });

    test('saveReminder should add ID and return reminder', () async {
      final reminderToSave = Reminder(
        id: '',
        title: 'Нове нагадування',
        subtitle: 'Опис нового нагадування',
        dateTime: DateTime(2025, 5, 15, 12, 0),
        remindBefore: Duration(minutes: 5),
        userId: 'test-user',
        isDone: false,
      );


      final savedReminder = await MockReminderService.saveReminder(reminderToSave);


      expect(savedReminder.id, isNotEmpty);
      expect(savedReminder.id, startsWith('generated-id-'));
      expect(savedReminder.title, equals(reminderToSave.title));
      expect(savedReminder.subtitle, equals(reminderToSave.subtitle));
      expect(savedReminder.dateTime, equals(reminderToSave.dateTime));
    });

    test('deleteReminder should throw exception for empty ID', () async {
      const String emptyId = '';

      expect(
            () => MockReminderService.deleteReminder(emptyId),
        throwsException,
      );
    });

    test('deleteReminder should complete normally for valid ID', () async {
      const String validId = 'reminder-1';

      expect(
            () => MockReminderService.deleteReminder(validId),
        returnsNormally,
      );
    });
  });
}