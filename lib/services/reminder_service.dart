import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reminder.dart';

class ReminderService {
  static Future<void> saveReminder(Reminder reminder) async {
    await FirebaseFirestore.instance.collection('reminders').add(reminder.toMap());
  }

  static Future<List<Reminder>> fetchReminders(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('reminders')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs.map((doc) {
      return Reminder.fromMap(doc.id, doc.data());
    }).toList();
  }

  static Future<void> deleteReminder(String reminderId) async {
    await FirebaseFirestore.instance
        .collection('reminders')
        .doc(reminderId)
        .delete();
  }
}