import 'package:flutter_test/flutter_test.dart';
import 'package:student_life/models/reminder.dart';

void main() {
  group('Reminder Model Tests', () {
    test('should create Reminder with correct values', () {

      final DateTime testDate = DateTime(2025, 5, 10, 14, 30);
      const String testId = 'test-id';
      const String testTitle = 'Test Reminder';
      const String testSubtitle = 'Test Description';
      const Duration testRemindBefore = Duration(minutes: 10);
      const String testUserId = 'user-123';
      const bool testIsDone = false;

      final reminder = Reminder(
        id: testId,
        title: testTitle,
        subtitle: testSubtitle,
        dateTime: testDate,
        remindBefore: testRemindBefore,
        userId: testUserId,
        isDone: testIsDone,
      );

      // Assert
      expect(reminder.id, equals(testId));
      expect(reminder.title, equals(testTitle));
      expect(reminder.subtitle, equals(testSubtitle));
      expect(reminder.dateTime, equals(testDate));
      expect(reminder.remindBefore, equals(testRemindBefore));
      expect(reminder.userId, equals(testUserId));
      expect(reminder.isDone, equals(testIsDone));
    });

    test('should correctly update isDone status', () {
      // Arrange
      final reminder = Reminder(
        id: 'test-id',
        title: 'Test Reminder',
        subtitle: 'Test Description',
        dateTime: DateTime.now(),
        remindBefore: const Duration(minutes: 10),
        userId: 'user-123',
        isDone: false,
      );

      // створення копії з оновленим статусом
      final updatedReminder = Reminder(
        id: reminder.id,
        title: reminder.title,
        subtitle: reminder.subtitle,
        dateTime: reminder.dateTime,
        remindBefore: reminder.remindBefore,
        userId: reminder.userId,
        isDone: true, // Змінюємо статус
      );

      expect(updatedReminder.isDone, isTrue);
      expect(updatedReminder.id, equals(reminder.id)); // Перевіряємо, що інші поля не змінилися
    });
  });
}