import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'AddEventScreen.dart';
import '../services/reminder_service.dart';
import '../models/reminder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'GroupScheduleScreen.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  List<Reminder> reminders = [];
  int _currentNavIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final loadedReminders = await ReminderService.fetchReminders(userId);
      setState(() {
        reminders = loadedReminders;
      });
    }
  }

  Future<void> _deleteReminder(String reminderId) async {
    try {
      await ReminderService.deleteReminder(reminderId);
      _loadReminders();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Нагадування видалено')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Помилка видалення: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F7FA),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Нагадування',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: reminders.isEmpty
                ? const Center(child: Text('Немає нагадувань'))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: reminders.length,
              itemBuilder: (context, index) {
                final reminder = reminders[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: reminder.isDone ? Colors.grey.shade300 : const Color(0xFFD2EFEA),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              reminder.title,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _showDeleteConfirmation(reminder),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(reminder.subtitle),
                      const SizedBox(height: 8),
                      Text(
                        DateFormat('dd MMMM, yyyy  HH:mm', 'uk').format(reminder.dateTime),
                        style: const TextStyle(fontSize: 12, color: Colors.redAccent),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF526FAA),
        onPressed: () {
          // Використовуємо AddEventScreen для створення нового нагадування
          Navigator.of(context)
              .push(MaterialPageRoute(
              builder: (_) => AddEventScreen(selectedDate: DateTime.now())
          ))
              .then((_) => _loadReminders());
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  void _showDeleteConfirmation(Reminder reminder) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Видалити нагадування?'),
          content: Text('Ви впевнені, що хочете видалити нагадування "${reminder.title}"?'),
          actions: [
            TextButton(
              child: const Text('Скасувати'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Видалити', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteReminder(reminder.id);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentNavIndex,
      onTap: (index) {
        setState(() {
          _currentNavIndex = index;
          if (index == 0) {
            Navigator.pushNamed(context, '/NotesCategoriesScreen');
          } else if (index == 3) {
            Navigator.pushNamed(context, '/CalendarScreen');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/RemindersScreen');
          } else if (index == 4) {
            Navigator.pushNamed(context, '/MapScreen');
          } else if (index == 2) {
            _navigateToGroupSchedule(context, "ПЗ-31");
          }
        });
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.note), label: "Нотатки"),
        BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Нагадування"),
        BottomNavigationBarItem(icon: Icon(Icons.schedule), label: "Розклад"),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Календар"),
        BottomNavigationBarItem(icon: Icon(Icons.map), label: "Карта"),
      ],
      selectedItemColor: Colors.purple,
      unselectedItemColor: Colors.black,
      type: BottomNavigationBarType.fixed,
    );
  }

  void _navigateToGroupSchedule(BuildContext context, String groupName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupScheduleScreen(groupName: groupName),
      ),
    );
  }
}